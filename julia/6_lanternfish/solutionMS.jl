#=
Created on 06/12/2021 09:38:22
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Fishes
=#

states = [3,4,3,1,2]
states = [2,5,5,3,2,2,5,1,4,5,2,1,5,5,1,2,3,3,4,1,4,1,4,4,2,1,5,5,3,5,4,3,4,1,5,4,1,5,5,5,4,3,1,2,1,5,1,4,4,1,4,1,3,1,1,1,3,1,1,2,1,3,1,1,1,2,3,5,5,3,2,3,3,2,2,1,3,1,3,1,5,5,1,2,3,2,1,1,2,1,2,1,2,2,1,3,5,4,3,3,2,2,3,1,4,2,2,1,3,4,5,4,2,5,4,1,2,1,3,5,3,3,5,4,1,1,5,2,4,4,1,2,2,5,5,3,1,2,4,3,3,1,4,2,5,1,5,1,2,1,1,1,1,3,5,5,1,5,5,1,2,2,1,2,1,2,1,2,1,4,5,1,2,4,3,3,3,1,5,3,2,2,1,4,2,4,2,3,2,5,1,5,1,1,1,3,1,1,3,5,4,2,5,3,2,2,1,4,5,1,3,2,5,1,2,1,4,1,5,5,1,2,2,1,2,4,5,3,3,1,4,4,3,1,4,2,4,4,3,4,1,4,5,3,1,4,2,2,3,4,4,4,1,4,3,1,3,4,5,1,5,4,4,4,5,5,5,2,1,3,4,3,2,5,3,1,3,2,2,3,1,4,5,3,5,5,3,2,3,1,2,5,2,1,3,1,1,1,5,1]

function update!(states)
    n = length(states)
    for i in 1:n
        s = states[i]
        states[i] = s == 0 ? 6 : s - 1
        s == 0 && push!(states, 8)
    end
    states
end

function update!(states, n_steps)
    for t in 1:n_steps
        update!(states)
    end
    return states
end

# ---- QUESTION 1 ----- #

solution1 = update!(copy(states), 80) |> length

# ---- QUESTION 2 ------ #

function smart_counter(states, n_steps)
    states = [count(isequal(i), states) for i in 0:8]
    new_states = similar(states)
    for t in 1:n_steps
        new_states[end] = states[1]
        for i in 1:8
            new_states[i] = states[i+1]
        end
        new_states[7] += states[1]
    states, new_states = new_states, states
    end
    return states
end

solution1 = smart_counter(states, 80) |> sum
solution2 = smart_counter(states, 256) |> sum