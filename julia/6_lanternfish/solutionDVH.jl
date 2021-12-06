#=
author: Daan Van Hauwermeiren
AoC: day 6
=#
using Pkg
Pkg.activate(".")

read_data(fn) = parse.(Int, split(strip(read(fn, String)), ','))

mutable struct Fishes
    data::Vector{Int}
end

get_n_fishes(f::Fishes) = length(f.data)

"""
This naive function only works for small number of days, it will blow up for n_days > 200
"""
function next_day!(f::Fishes)
    # remove one day from the timer
    f.data .-= 1
    # new fish for every one whose timer is zero
    n_new_fishes = sum(f.data .< 0)
    # reset timer
    f.data[f.data .< 0] .= 6
    # add new fishes to the end of the vector
    push!(f.data, (8 * ones(eltype(f.data), n_new_fishes))...)
    nothing
end

#= 
    part 1
=#

fn = "input_day6_small"
data = read_data(fn)

f = Fishes(data)
for i in 1:80
    next_day!(f)
    # @show i
    # @show f
end
get_n_fishes(f)

#= 
    part 2
=#

mutable struct FishesAreNotNaive
    n_days::Vector{Int}
    n_fishes::Vector{Int}
    function FishesAreNotNaive(data::Vector{Int})
        n_days = collect(Int64, 0:8)
        n_fishes = zeros(Int64, length(n_days))
        
        for (i, n) in enumerate(n_days)
            n_fishes[i] = sum(data .== n)
        end
        new(n_days, n_fishes)
    end
end

get_n_fishes(f::FishesAreNotNaive) = sum(f.n_fishes)

function next_day!(f::FishesAreNotNaive)
    # remove one day from the timer
    f.n_days .-= 1
    # index of fishes who are spawning
    idx_spawn = f.n_days .< 0
    idx_six = f.n_days .== 6
    # reset timer
    f.n_days[idx_spawn] .= 8
    # number of new fishes to create
    # these need to be added to six (old ones) as well as eight (new spawn)
    # since -1 becomes 8, these just remain at that location, and only the sixes are added
    n_new_fishes = f.n_fishes[idx_spawn]
    f.n_fishes[idx_six] += n_new_fishes
    nothing
end

fn = "input_day6"
data = read_data(fn)
f = FishesAreNotNaive(data)

for i in 1:256
    next_day!(f)
    # @show i
    # @show f
end
get_n_fishes(f)

