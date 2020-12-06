#=
Author: Bram De Jaegher
AoC: day 6

That excalated quickly! Nothing to declare.
=#

parse_input(s::String) = split(s, "\n\n") |> s-> [split(sᵢ, "\n") for sᵢ in s]

fn = "data/06_day6_customCustoms.txt"
input = read(fn, String) |> parse_input

uniqueList = [unique(reduce(*, group))  for group in input]
output1 = sum(length.(uniqueList))

output2 = sum(length.([reduce(intersect, Set.(group)) for group in input]))

println("number of answers with any yes: $output1")
println("number of answers with all yes: $output2")
