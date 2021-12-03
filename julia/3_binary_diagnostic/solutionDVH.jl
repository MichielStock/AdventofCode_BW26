#=
author: Daan Van Hauwermeiren
AoC: day 3
=#
using Pkg
Pkg.activate(".")
using Pipe

parse_input(s) = split(rstrip(raw), "\n")

"""
stolen from: https://discourse.julialang.org/t/parse-an-array-of-bits-bitarray-to-an-integer/42361/3
"""
bitarr_to_int(arr) = sum(arr .* (2 .^ collect(length(arr)-1:-1:0)))

raw = read("input_day3_small", String)
raw = read("input_day3", String)
data = parse_input(raw)

#=
Part 1
=#

processed = @pipe collect.(data) .|> parse.(Int, _)

get_most_common_bit(arr) = sum(arr, dims=1)[1] .> size(arr)[1]//2

gamma = get_most_common_bit(processed)
epsilon = @. !gamma
solution_1 = bitarr_to_int(gamma) * bitarr_to_int(epsilon)

#=
Part 2
=#
# now I want a matrix as data
processed = @pipe collect.(data) .|> parse.(Bool, _) |> hcat(_...)'

"""
compare=≥ for oxygen generator rating
compare=≤ for CO2 scrubber rating

processed is a bitmatrix

returns a decimal
"""
function bit_criteria_v2(data, compare=≥)
    tmp = copy(processed)
    for i in 1:size(processed,2)
        col = tmp[:, i]
        tmp = compare(sum(col), size(tmp,1)//2) ? tmp[col,:] : tmp[.!col ,:]
        if size(tmp, 1) == 1
            break
        end
    end
    return bitarr_to_int(tmp')
end

# oxygen generator rating
ox = bit_criteria_v2(processed, ≥)
# CO2 scrubber rating
# not 100% sure why this is exactly `<`` and not `≤` as I expected, but it works 
co2 = bit_criteria_v2(processed, <)
solution_2 = ox * co2