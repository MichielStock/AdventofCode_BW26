#=
Author: Michiel Stock
AoC: day 13

Find the earliest bus ride.
=#

using StatsBase: skipmissing

input = """
939
7,13,x,x,59,x,31,19
"""

parseint(str) = str=="x" ? missing : parse(Int, str)

function parse_input(input)
    time, ids = split(rstrip(input), "\n")
    time = parseint(time)
    ids = split(ids, ",") .|> parseint
    return time, ids
end

time_to_wait(id, t) = (div(t, id) + 1) * id - t
best_bus(ids, time) = minimum((time_to_wait(id, time), id) for id in skipmissing(ids))

function inv_mod(N, b)
    for x in 1:b
        (N * x) % b == 1 && return x
    end
end

function chinese_remainder(a, n)
    @assert all(0 .≤ a .≤ n)
    N = lcm(n...)
    Ni = div.(N, n)
    xi = inv_mod.(Ni, n)
    return sum(a .* Ni .* xi) % N
end

function find_order_time(ids)
    a = [i - 1  for (i, id) in enumerate(ids) if !ismissing(id)]
    n = skipmissing(ids) |> collect
    a .= a .* n .- a
    a .%= n
    return chinese_remainder(a, n)
end


input = read("data/13_shuttle_bus/input.txt", String)
time, ids = parse_input(input)

min_time, best_id = best_bus(ids, time) 
sol1 = min_time * best_id

sol2 = find_order_time(ids)