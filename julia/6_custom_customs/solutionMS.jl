#=
Author: Michiel Stock
AoC: day 5

Find the number of questions that at least one person said "yes" to
=#

answers = read("data/6_custom_customs/input.txt", String) |> text -> split(text, "\n\n") .|> text -> split(text,"\n")

anyone_yes = answers .|> join .|> Set .|> length |> sum