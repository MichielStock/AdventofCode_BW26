#= --- Day 1: Sonar Sweep ---
        Bram De Jaegher
=#

input_test = """
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

depth(x) = x |> split .|> x -> parse(Int, x)
count_increments(d) = diff(d) .|> (x -> x > 0) |> sum

# ------ Part 1 ------ #

# Test data
depth_list_t = input_test |> depth              # Construct depth list
increments = depth_list_t |> count_increments   # Count incrementss

# Full data
depth_list = read("./data/1_sonar_sweep/input.txt", String) |> depth
increments = depth_list |> count_increments

# ------ Part 2 ------ #
construct_window_sum(d) = [sum(d[i:i+2]) for i in 1:length(d)-2]

# Test data
windows_t = construct_window_sum(depth_list_t) |> count_increments

# Full data
windows = construct_window_sum(depth_list) |> count_increments
