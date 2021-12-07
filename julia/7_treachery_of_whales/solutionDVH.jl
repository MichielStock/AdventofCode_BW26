#=
author: Daan Van Hauwermeiren
AoC: day 7
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day7"
read_data(fn) = @pipe read(fn, String) |> strip(_) |> split(_, ",") |> parse.(Int, _)

data = read_data(fn)

#=
    part 1
=#

fuel_consumption(data::Vector{Int}, loc::Int) = sum(abs.(data .- loc))

locations = 1:1000

fuel = @pipe locations .|> fuel_consumption(data, _)
loc = first(locations[fuel .== minimum(fuel)])
loc, fuel_consumption(data, loc)


#=
    part 2
=#

function fuel_consumptionv2(data::Vector{Int}, loc::Int)
    distance = abs.(data .- loc)
    # sum of first N natural numbers
    return sum(distance .* (distance .+ 1) .÷ 2)
end

locations = 1:1000

fuel = @pipe locations .|> fuel_consumptionv2(data, _)
loc = first(locations[fuel .== minimum(fuel)])
loc, fuel_consumptionv2(data, loc)
