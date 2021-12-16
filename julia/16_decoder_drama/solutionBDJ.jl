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
    number = BitArray([])

    while true
      if raw[1] == 1                                    # end of literal reached
        fiver = BitArray([popfirst!(raw) for i in 1:5])
        number = vcat(number, fiver[2:end]) 
      else 
        fiver = BitArray([popfirst!(raw) for i in 1:5])
        number = vcat(number, fiver[2:end]) 
        num_trail = rem(6+length(number)÷4*5, 4, RoundUp) # number of trailing zeros
        _ = [popfirst!(raw) for i in 1:num_trail]         # remove these zeroes
        break
      end
    end
    return new(version, typeID, decode(number), deepcopy(raw))
  end
end



struct Operator <: BITS 
  version::Int
  typeID::Int
  subpackets::Array
  rest::BitArray
  
  function Operator(version,typeID,raw::BitArray)
    I = raw[7]
    raw = raw[8:end] # remove version and typeID
    subpackets = BITS[]
    if I == 0
      L = decode(raw[1:15])
      raw = raw[16:end]
      rawNew = copy(raw)
      change = 0
      while  change < L && !isempty(raw) && sum(raw) > 0
        packet, rawNew = parse_packet(raw) 
        push!(subpackets, deepcopy(packet))
        change += (length(rawNew) - length(raw))
        raw = copy(rawNew)
      end

    else
      N = decode(raw[1:11])
      raw = raw[12:end]
      for i in 1:N 
        packet, rawNew = parse_packet(raw) 
        push!(subpackets, packet)
        raw = copy(rawNew)
      end
    end
    new(deepcopy(version), deepcopy(typeID), deepcopy(subpackets), deepcopy(raw))
  end
end

function parse_packet(b::BitArray)
  (v, t) = version_type(b)
  println("Version $v, $t, $(length(b))")

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
example_2 = "620080001611562C8802118E34"

# Sandbox
decode(example_1) |> parse_packet
test, rest = decode(example_2) |> parse_packet


decode([0,1,1,1] .== 1)

BitArray[1, 0, 1, 0]

function find_end_literal(raw::BitArray)
  raw_temp = raw[1:end]                      # shift reading window one to the right (add prefixed zero)
  first_zero= findfirst(.!raw_temp[1:5:end])          # find first zero of first bit
  first_one = findfirst(raw_temp[first_zero+5:end])   # find first one after first bit   
  
  if first_one === nothing                            # End of stream
    last_bit = first_zero + 4  
  else
    last_bit = (cld(first_zero-1 + first_one+5,5)-1)*5                 # last bit of literal
  end 

  if mod(last_bit, 5) == 0                 # check if the found literal is groupable by five
    return last_bit                       # return last bit of literal
  else
    return false
  end
end