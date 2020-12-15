#=
Author: Michiel Stock
AoC: day 15

Memory game
=#

function play_memory_game(input, turns)
    last_used = Dict(numb => i for (i, numb) in enumerate(input))
    current = 0
    @inbounds for turn in (length(input)+1):turns-1
        if haskey(last_used, current)
            new = turn - last_used[current]
            last_used[current] = turn
            current = new
        else
            last_used[current] = turn
            current = 0 
        end
        
    end
    return current
end

input = (0,5,4,1,10,14,7)
sol1 = play_memory_game(input, 2020)

sol2 = play_memory_game(input, 30_000_000)
