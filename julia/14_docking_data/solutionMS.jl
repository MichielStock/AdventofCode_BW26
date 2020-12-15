#=
Author: Michiel Stock
AoC: day 14

Do weird things with masks.
=#

# m: mask: 1 if bit has to be copied
# d: default value
# x: bit value

using Combinatorics

apply_mask(m, d, x) = (m & x) | (~m & d)

input1 = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""

input2 = """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""



function parse_mask(mask)
    n = length(mask)
    reduce(+, (2^(n-i) for (i, v) in enumerate(mask) if v); init=0)
end

mask = "000000000000000000000000000000X1001X"
m = parse_mask((c=='X' for c in mask))
d = parse_mask((c=='1' for c in mask))

function process1(input)
    lines = split(rstrip(input), "\n")
    mem = Dict{Int,Int}()
    ghost = Dict{Int,Int}()
    m, d = 0, 0
    for l in lines
        if l[2] == 'a' # new mask
            mask = l[end-35:end]
            m = parse_mask((c=='X' for c in mask))
            d = parse_mask((c=='1' for c in mask))
        else
            matches = match(r"\[(\d+)\] = (\d+)", l)
            pos = parse(Int, matches[1])
            x = parse(Int, matches[2])
            mem[pos] = apply_mask(m, d, x)
        end
    end
    return mem
end

function fill_all_positions!(mem, x, m, pos)
    b = bitstring(m)
    vals = [2^i for i in 0:36 if b[end-i]=='1']
    for c in combinations(vals)
        mem[pos+sum(c)] = x
    end
end

function process2(input)
    lines = split(rstrip(input), "\n")
    mem = Dict{Int,Int}()
    m, d = 0, 0
    for l in lines
        if l[2] == 'a' # new mask
            mask = l[end-35:end]
            m = parse_mask((c=='X' for c in mask))
            d = parse_mask((c=='1' for c in mask))
        else
            matches = match(r"\[(\d+)\] = (\d+)", l)
            pos = parse(Int, matches[1])
            x = parse(Int, matches[2])
            pos = ((~d & pos) | d) & ~m
            mem[pos] = x
            fill_all_positions!(mem, x, m, pos)
        end
    end
    return mem
end

    
input = read("data/14_docking_data/input.txt", String)
sol1 = process1(input) |> values |> sum

sol2 = process2(input) |> values |> sum
