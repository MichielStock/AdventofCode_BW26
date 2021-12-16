# --- Day 16: Packet Decoder --- #
#     Author: Bram De Jaegher    #
# --- ---------------------- --- #

abstract type BITS end

struct LiteralValue <: BITS 
  version::Int
  typeID::Int
  value::Int
  rest::BitArray
  
  function LiteralValue(version,typeID,raw::BitArray)
    raw = raw[7:end] # remove version and typeID
    N_trail, final_bit = find_end_literal(raw)
    println("Final_bit = $final_bit")
    literal = raw[1+N_trail:final_bit+N_trail]

    number = BitArray([])
    for i in 1:(final_bit ÷ 5)
      fiver = BitArray([popfirst!(raw) for i in 1:5])
      number = vcat(number, fiver[2:end]) 
    end
    new(version, typeID, decode(number), raw[final_bit+N_trail+1:end])
  end
end

function find_end_literal(raw::BitArray)
  for N_prefix in 0:3
    raw_temp = raw[1+N_prefix:end]                      # shift reading window one to the right (add prefixed zero)
    first_zero= findfirst(.!raw_temp[1:5:end])          # find first zero of first bit
    # println(first_zero)
    first_one = findfirst(raw_temp[first_zero+5:end])   # find first one after first bit   
    
    if first_one === nothing                            # End of stream
      last_bit = first_zero + 4  
    else
      last_bit = (cld(first_zero-1 + first_one+5,5)-1)*5                 # last bit of literal
    end 

    # println(first_one)
    # println(last_bit)

    if mod(last_bit + N_prefix, 5) == 0                 # check if the found literal is groupable by five
      return N_prefix, last_bit + N_prefix              # return last bit of literal
    else
      continue
    end
  end
  return false
end

struct Operator <: BITS 
  version::Int
  typeID::Int
  subpackets::Array
  rest::BitArray
  
  function Operator(version,typeID,raw::BitArray)
    I = raw[7]
    println("Length index $I")
    raw = raw[8:end] # remove version and typeID
    subpackets = BITS[]

    if !I 
      L = decode(raw[1:15])
      raw = raw[16:end]
      rawNew = copy(raw)
      change = 0
      while  change < L 
        packet, rawNew = parse_packet(raw) 
        push!(subpackets, packet)
        println(raw)
        change += (length(rawNew) - length(raw))
        raw = copy(rawNew)
      end

    else
      N = decode(raw[1:11])
      println("Found $N subpackets")
      raw = raw[12:end]
      for i in 1:N 
        packet, raw = parse_packet(raw) 
        println(packet)
        println(length(raw))
        push!(subpackets, packet)
      end
    end

    new(version, typeID, subpackets, raw)
  end
end

function parse_packet(b::BitArray)
  (v, t) = version_type(b)
  println("Type: $t")
  if t == 4
    packet = LiteralValue(v, t, b)    
  else 
    packet = Operator(v, t, b)
  end
    return packet, packet.rest
end

decode(b::BitArray) = sum([value*2^(i-1) for (i,value) in enumerate(reverse(b))])
  
function decode(c::Char)
  mapping = Dict(
    '0' => BitArray("0000" |> collect .== '1'),
    '1' => BitArray("0001" |> collect .== '1'),
    '2' => BitArray("0010" |> collect .== '1'),
    '3' => BitArray("0011" |> collect .== '1'),
    '4' => BitArray("0100" |> collect .== '1'),
    '5' => BitArray("0101" |> collect .== '1'),
    '6' => BitArray("0110" |> collect .== '1'),
    '7' => BitArray("0111" |> collect .== '1'),
    '8' => BitArray("1000" |> collect .== '1'),
    '9' => BitArray("1001" |> collect .== '1'),
    'A' => BitArray("1010" |> collect .== '1'),
    'B' => BitArray("1011" |> collect .== '1'),
    'C' => BitArray("1100" |> collect .== '1'),
    'D' => BitArray("1101" |> collect .== '1'),
    'E' => BitArray("1110" |> collect .== '1'),
    'F' => BitArray("1111" |> collect .== '1')
    )
    if haskey(mapping, c)
      return mapping[c]
    else
      return false
    end
  end
    
decode(s::String) = vcat([decode(c) for c in s]...)
version_type(s::BitArray) = (decode(s[1:3]), decode(s[4:6]))


example_1 = "D2FE28"
example_2 = "EE00D40C823060"

# Sandbox
decode(example_1) |> parse_packet
decode(example_2) |> parse_packet




parse_packet("10110000001100100000100011000001100000" |> collect .== '1')

£decode("D2FE28") |> x -> LiteralValue(4, 6, x)
decode




decode([0,1,1,1] .== 1)

BitArray[1, 0, 1, 0]

