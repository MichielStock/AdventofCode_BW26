#=
Author: Bram De Jaegher
AoC: day 10

Some adaptation required
=#


function construct_chain!(adapters)
  pushfirst!(adapters,0)
  push!(adapters, maximum(adapters)+3)
  sort!(adapters)
end

function solution1(adapters)
  jolt_jumps = diff(adapters)
  return sum(jolt_jumps.==3) * sum(jolt_jumps.==1)
end

function combinations(l)
  l < 4 && return 2^(l-1)
  l == 4 && return 7
end

function solution2(adapters)
  group_lengths = length.(split(reduce(*,string.(diff(adapters))), "3"))
  return reduce(*,combinations.(filter(x->x!==0,group_lengths)))
end

parse_input(input) = split(rstrip(input), "\n") .|> x-> parse(Int,x)

adapters = read("data/10_adapter_array/input.txt", String) |> parse_input
construct_chain!(adapters) |> solution1
solution2(adapters)





