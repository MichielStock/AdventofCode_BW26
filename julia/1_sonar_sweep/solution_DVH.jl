#=
author: Daan Van Hauwermeiren
AoC: day 1
=#
using Pkg
Pkg.activate(".")
using DelimitedFiles

fn = "input_day1"
# read data to vector
data = vec(readdlm(fn, Int64))

# function to get the number of positive values in a vector 
get_n_positive(a::Vector) = a .|> (x -> x>0) |> sum

solution_1 = get_n_positive(diff(data)) 

window_3_sum(x::Vector) = [sum(x[i-2:i]) for i in 3:length(x)]
solution_2 = get_n_positive(diff(window_3_sum(data))) 
