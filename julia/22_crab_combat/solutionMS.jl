#=
Author: Michiel Stock
AoC: day 22

Play a card game against a crab!
=#

using DataStructures: Deque

function parse_input(input)
    cards1, cards2 = split(rstrip(input), "\n\n")
    p(cards) = parse.(Int, split(cards, "\n")[2:end])
    return p(cards1), p(cards2)
end

function playcombat(cards1, cards2)
    cards1 = push!(Deque{Int}(), cards1...)
    cards2 = push!(Deque{Int}(), cards2...)
    nrounds = 0
    while length(cards1) > 0 && length(cards2) > 0
        nrounds += 1
        c1 = popfirst!(cards1)
        c2 = popfirst!(cards2)
        c1 > c2 && push!(cards1, c1, c2)
        c1 < c2 && push!(cards2, c2, c1)
    end
    cards = length(cards1) > 0 ? cards1 : cards2
    n = length(cards)
    score = (n:-1:1) .* (cards) |> sum
    return score, nrounds
end

input = read("data/22_crab_combat/input.txt", String)
cards1, cards2 = parse_input(input)
score, nrounds = playcombat(cards1, cards2)
