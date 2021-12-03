#=
Created on 01/12/2021 11:25:13
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Solution for day one of AoC 2021
=#

example_measurements = """
199
200
208
210
200
207
240
269
260
263
"""
parse_int(s) = parse(Int, s)
parse_input(s) = split(rstrip(s), "\n") .|> parse_int

#numbers = parse_input(example_measurements)

# --------- QUESTION 1 --------- #

numbers = parse_input(read("data/1/input.txt", String))

n_dept_incr(numbers) = count(i->numbers[i] > numbers[i-1], 2:length(numbers))

solution1 = n_dept_incr(numbers)

# --------- QUESTION 2 --------- #

n_three_dept_incr(numbers) = count(i->numbers[i] + numbers[i+1] + numbers[i+2] <
                                    numbers[i+1] + numbers[i+2] + numbers[i+3], 1:length(numbers)-3)

solution2 = n_three_dept_incr(numbers)
