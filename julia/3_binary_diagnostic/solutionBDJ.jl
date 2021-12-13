#= --- Day 3: Binary diagnostic ---
  author:  Bram De Jaegher
=#

test_input = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"""

toInt(x) = parse.(Int,x)
toLines(x) = split(x) .|> x -> replace(x, "\n"=>"") .|> x -> split(x,"")
bin2dec(x) = sum([el*2^(num-1) for (num,el) in enumerate(reverse(x))])

most_common(lines) = sum(lines,dims=1).≥size(lines)[1]/2
least_common(lines) = sum(lines,dims=1).<size(lines)[1]/2

function power(lines)
  γ = most_common(lines) |> bin2dec
  ϵ = least_common(lines) |> bin2dec
  return ϵ*γ   
end


function oxygen_rating(lines)
  lines_temp = copy(lines)
  
  pos = 1
  while size(lines_temp)[1] > 1
    most_common_lines = most_common(lines_temp)
    lines_temp = lines_temp[lines_temp[:,pos].==most_common_lines[pos],:]
    pos += 1
  end
  return lines_temp
end

function CO2_rating(lines)
  lines_temp = copy(lines)
  
  pos = 1
  while size(lines_temp)[1] > 1
    least_common_lines = least_common(lines_temp)
    lines_temp = lines_temp[lines_temp[:,pos].==least_common_lines[pos],:]
    pos += 1
  end
  return lines_temp
end

# --- Part one ---
# test
lines = toLines(test_input) .|> toInt |> (x -> hcat(x...)') 
power(lines)

# full
lines = read("./data/3_binary_diagnostic/input.txt", String) |> toLines .|> toInt |> (x -> hcat(x...)')
power(lines)

# --- Part two ---
# test
lines = toLines(test_input) .|> toInt |> (x -> hcat(x...)') 
(oxygen_rating(lines) |> bin2dec) * CO2_rating(lines) |> bin2dec

# full