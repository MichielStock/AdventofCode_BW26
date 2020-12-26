#=
author: Daan Van Hauwermeiren
AoC: day 10
=#
using Pkg
Pkg.activate(".")
using StatsBase

parse_int(s) = parse(Int, s)
parse_input(input) = split(rstrip(input), "\n") .|> parse_int

numbers = read("./data/day10.txt", String) |> parse_input

diffs = diff(vcat([0], sort(numbers), [maximum(numbers) + 3]))

solution_1 = sum(diffs .== 1) * sum(diffs .== 3)

#=
Return the run-length encoding of a vector as a tuple. The first element of the tuple is a vector of values of the input and the second is the number of consecutive occurrences of each element.

julia>rle([1,1,2,3,3,1])
([1, 2, 3, 1], [2, 1, 2, 1])

Because two times 1, one time 2, two times 3, one time 1
=#

runs = rle(diffs)

#=
for elements equal to '1', get where they are repeated twice
(runs[1] .== 1) .& (runs[2] .== 2)

Why do we need the exponentiation ?
=#
solution_2 = 
    2 ^ sum((runs[1] .== 1) .& (runs[2] .== 2)) * 
    4 ^ sum((runs[1] .== 1) .& (runs[2] .== 3)) * 
    7 ^ sum((runs[1] .== 1) .& (runs[2] .== 4))
