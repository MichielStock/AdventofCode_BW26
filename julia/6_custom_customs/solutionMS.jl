#=
Author: Michiel Stock
AoC: day 6

Find the number of questions that at least one person said "yes" to
=#

answers = read("data/6_custom_customs/input.txt", String) |> (text -> split(text, "\n\n")) .|> rstrip .|> (text -> split(text,"\n"))

anyone_yes = answers .|> join .|> Set .|> length |> sum
all_yes = answers .|> (a -> intersect(a...)) .|> length |> sum

println("number of answers with any yes: $anyone_yes")
println("number of answers with all yes: $all_yes")