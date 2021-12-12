# solution day 1: Ward Van Belle

test = """
200
213
350
200
450
"""

# question 1

function count_increases(input_num)
    increases = diff(input_num)
    return sum(increases .> 0)
end

# question 2

function window_count_increases(input_num)
    windows = [sum(input_num[i:i+2]) for i in 1:(length(input_num)-2)]
    increases = diff(windows)
    return sum(increases .> 0)
end

day1_input = open(f->read(f, String), "../../Data/1/input.txt")

day1_num = split(day1_input,"\n")
day1_num = day1_num[1:(length(day1_num)-1)]
day1_num = [parse(Int64,i) for i in day1_num]

solution1 = count_increases(day1_num)
println(solution1)

solution2 = window_count_increases(day1_num)
println(solution2)

