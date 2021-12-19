# --- Day 16: Packet Decoder --- #
#   Author: Bram De Jaegher      #
# --- ---------------------- --- #

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


function read_packet(bs_in, value::Int64; pos_in=1)
  global value
  bitString = deepcopy(bs_in)
  pos = deepcopy(pos_in)
  
  V,T = version_type(bitString[pos:end])
  pos += 6
  value += V

  if T == 4
    lastBit = findfirst(.!bitString[pos:5:end])*5  # find first zero
    println("Literal found of length: $(lastBit+1)")
    pos += lastBit
  elseif sum(bitString) > 0                                         # not a literal but also not a trailing zero                                                
    I = bitString[pos]
    pos += 1
    if I == 0                                                       # next bits are the length of subpacket
      L = decode(bitString[pos:pos+14])
      pos += 15
      goal = pos + L
      while pos < goal
        value, pos = read_packet(bitString, value; pos_in = pos)
      end
      #pos += L
    else                                                            # number of subpackets provided
      N = decode(bitString[pos:pos+10])
      pos += 11
      for i in 1:N
        value, pos = read_packet(bitString, value; pos_in = pos)
      end
    end
  end
  return value, pos
end

function read_packet(bs_in, operators::Dict{Int64,Function}; pos_in=1)
  global value
  bitString = deepcopy(bs_in)
  pos = deepcopy(pos_in)
  
  V,T = version_type(bitString[pos:end])
  pos += 6
  
  
  if T == 4
    lastBit = findfirst(.!bitString[pos:5:end])*5  # find first zero
    posTemp = pos
    number = BitArray([])
    while true
      if bitString[posTemp] == 1                                    # end of literal reached
        fiver = BitArray([bitString[posTemp + i] for i in 0:4])
        posTemp += 5
        number = vcat(number, fiver[2:end]) 
      else 
        fiver = BitArray([bitString[posTemp + i] for i in 0:4])
        number = vcat(number, fiver[2:end]) 
        posTemp += 5
        break
      end
    end
    value = decode(number)
    pos += lastBit
  elseif sum(bitString) > 0                                         # not a literal but also not a trailing zero                                                  
    subvalues = []
    I = bitString[pos]
    pos += 1
    if I == 0                                                       # next bits are the length of subpacket
      L = decode(bitString[pos:pos+14])
      pos += 15
      goal = pos + L
      while pos < goal
        valueTemp, pos = read_packet(bitString, operators; pos_in = pos)
        push!(subvalues, valueTemp)
      end
      #pos += L
    else                                                            # number of subpackets provided
      N = decode(bitString[pos:pos+10])
      pos += 11
      for i in 1:N
        valueTemp, pos = read_packet(bitString, operators; pos_in = pos)
        push!(subvalues, valueTemp)
      end
    end
    value = operators[T](subvalues)
  end
  return value, pos
end


# --- Part 1 --- #
# Test
example_1 = "D2FE28" |> decode
example_2 = "38006F45291200" |> decode
example_3 = "EE00D40C823060" |> decode
example_4 = "8A004A801A8002F478" |> decode
example_5 = "620080001611562C8802118E34" |> decode
example_6 = "A0016C880162017C3686B18A3D4780" |> decode

global value = 0
read_packet(example_1, value)

global value = 0
read_packet(example_2, value)

global value = 0
read_packet(example_3, value)

global value = 0
read_packet(example_4, value)

global value = 0
read_packet(example_5, value)

global value = 0
read_packet(example_6, value)

# Full
example_full = read("./data/16_packet_decoder/input.txt", String) |> decode

global value = 0
read_packet(example_full, value)

# --- Part 2
operators = Dict(
  0 => sum,
  1 => prod,
  2 => minimum,
  3 => maximum,
  5 => x -> (x[1] > x[2])*1,
  6 => x -> (x[1] < x[2])*1,
  7 => x -> (x[1] == x[2])*1,
)

example_1 = "C200B40A82" |> decode
read_packet(example_1, operators)

example_2 = "9C0141080250320F1802104A08" |> decode
read_packet(example_2, operators)


# Test
read_packet(example_full, operators)
