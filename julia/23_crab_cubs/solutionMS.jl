#=
Author: Michiel Stock
AoC: day 23

One crab, ten cups!
=#


@btime begin
function playcups(cups; nrounds=100)
    n = length(cups)
    cups_dict = Dict(cups[i]=>cups[i+1] for i in 1:n-1)
    cups_dict[cups[n]] = cups[1]
    current = cups[1]
    cups = cups_dict  # convience
    for round in 1:nrounds
        n1 = cups[current]
        n2 = cups[n1]
        n3 = cups[n2]
        n4 = cups[n3]
        destination = current == 1 ? n : current - 1
        while destination ∈ (n1, n2, n3)
            destination -= 1
            destination == 0 && (destination = n)
        end
        after_dest = cups[destination]
        cups[destination] = n1
        cups[n3] = after_dest
        cups[current] = n4
        current = n4
    end
    return cups
end

function representsol(cups)
    current = 1
    solution = 0
    for i in 1:length(cups)-1
        current = cups[current]
        solution = 10solution + current
    end
    return solution
end

        
cups = [3, 8, 9, 1, 2, 5, 4, 6, 7]
cups = [1, 8, 6, 5, 2, 4, 9, 7, 3]

sol1 = playcups(cups, nrounds=100) |> representsol

bigcups = append!(cups, 10:1000_000)

cups_final = playcups(bigcups, nrounds=10_000_000)

sol2 = cups_final[1] * cups_final[cups_final[1]]
end

