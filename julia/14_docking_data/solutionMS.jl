#=
Author: Michiel Stock
AoC: day 13

Do weird things with masks.
=#

# m: mask: 1 if bit has to be copied
# d: default value
# x: bit value

apply_mask(m, d, x) = (m & x) | (~m & d)

input = """
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""

mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
m = parse_mask((c=='X' for c in mask))
d = parse_mask((c=='1' for c in mask))

function parse_mask(mask)
    n = length(mask)
    sum((2^(n-i) for (i, v) in enumerate(mask) if v))
end

function process(input)
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
            mem[pos] = apply_mask(m, d, x)
        end
    end
    return mem
end
    
input = read("data/14_docking_data/input.txt", String)
mem = process(input)

sol1 = sum(values(mem))