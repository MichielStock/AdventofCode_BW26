#=
Author: Michiel Stock
AoC: day 10

Find the chain of adepters
=#


parse_int(s) = parse(Int, s)
parse_input(input) = split(rstrip(input), "\n") .|> parse_int

input = """
16
10
15
5
1
11
7
19
6
12
4
"""

input2 = """
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

function adapter_chain(adapters)
    push!(adapters, 0, maximum(adapters)+3)
    sort!(adapters)
    diffadapters = diff(adapters)
    return count(diffadapters.==1) * count(diffadapters.==3)
end 

function number_adapter_chains(adapters)
    n = length(adapters)
    D = zero(adapters)
    D[1] = 1
    for i in 2:n
        ad = adapters[i]
        i - 1 > 0 && ad - adapters[i-1] ≤ 3 && (D[i] += D[i-1])
        i - 2 > 0 && ad - adapters[i-2] ≤ 3 && (D[i] += D[i-2])
        i - 3 > 0 && ad - adapters[i-3] ≤ 3 && (D[i] += D[i-3])
    end
    return last(D)
end
    
adapters = read("data/10_adapter_array/input.txt", String) |> parse_input
solution1 = adapter_chain(adapters)
n_arrangements = number_adapter_chains(adapters)

