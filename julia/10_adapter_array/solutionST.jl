data = [parse(Int, i) for i in split(read("data/10_adapter_array//input.txt", String), "\n")[1:end-1]]

push!(data, maximum(data)+3)
sort!(data)
one_diff = 0
two_diff = 0
three_diff = 0
curr_joltage = 0
while length(data) != 0
    global one_diff
    global two_diff
    global three_diff
    global curr_joltage  
    tmp = popfirst!(data)
    if tmp - curr_joltage == 1
        one_diff += 1
    elseif tmp - curr_joltage == 2
        two_diff += 1
    elseif tmp - curr_joltage == 3
        three_diff += 1
    end
    curr_joltage = tmp
end
println(one_diff*three_diff)