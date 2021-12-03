#=
Created on 03/12/2021 10:16:18
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Playing with bits
=#

@btime begin
toy_data = """
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
01010
"""

parse_input(input) = split(rstrip(input), "\n") |> lines->[l[i]=='1' for l in lines, i in 1:length(lines[1])]

# --- question 1 --- #

#table = parse_input(toy_data)
table = parse_input(read("data/3/input.txt", String))

bits2num(bits) = sum(((i, bᵢ),)->bᵢ * 2^(length(bits) - i), enumerate(bits))

function get_bits(table)
    b = sum(table, dims=1)[:] .> size(table, 1) / 2
    return b
end

function get_gamma_epsilon(table)
    bits = get_bits(table)
    return bits2num(bits), bits2num(.!bits)
end

γ, ϵ = get_gamma_epsilon(table)

solution1 = γ * ϵ

# --- question 2 --- #

function oxygen(table)
    p = size(table, 2)
    
    for i in 1:p
        r = table[:,i]
        s = sum(r)
        n = length(r)
        m = 2s ≥ n
        table = table[r.==m , :]
       size(table, 1) == 1 && break
    end
    return bits2num(table)
end

function co2(table)
    p = size(table, 2)
    
    for i in 1:p
        r = table[:,i]
        n = length(r)
        s = sum(r)
        m = (2s < n)
       table = table[r.==m , :]
       size(table, 1) == 1 && break
    end
    return bits2num(table)
end
    

solution2 = oxygen(table) * co2(table)
end