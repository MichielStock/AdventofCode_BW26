#=
author: Daan Van Hauwermeiren
AoC: day 11
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day11"
data = @pipe read(fn, String) |> strip(_) |> split(_, "\n") |> split.(_, "") |> hcat(_...) |> parse.(Int, _)


# NOTE: everything about the indices, loops and checks is stolen from day 9

# generate Cartesian indices for our data matrix
R = CartesianIndices(data)
# function to check bounds, returns true if input index is a valid index
checkindexbounds(i::CartesianIndex, R::CartesianIndices) = all(first(R).I .<= i.I .<= last(R).I)
# define unit offsets in each dimension
unitOffset_i = CartesianIndex( (1, 0) )
unitOffset_j = CartesianIndex( (0, 1) )
# define all unit offsets in all directions: so 8 in total
unitOffsets = (
    unitOffset_i, -unitOffset_i, unitOffset_j, -unitOffset_j, #right left up down
    unitOffset_i + unitOffset_j, unitOffset_i - unitOffset_j, #diagonally
    -unitOffset_i + unitOffset_j, -unitOffset_i - unitOffset_j, #diagonally
)


# NOTE:
# Don't forget to reload data when doing this multiple times

n_flashes = 0
# for solution 1, iterate 100 times, 
# for solution 2, iterate many times, take 1000 or so, it will break when all is synchronised 
for step in 1:100
    # increase energy levels by one
    data .+= 1
    # get coordinates whose value are above 9
    # make two variables so that I can store one so that no octopus flashes twice
    # using a set so that I can verify uniqueness easily
    flashing_octopi_thisstep = Set(R[data .> 9])
    flashing_octopi = copy(flashing_octopi_thisstep)
    while true
        for i in flashing_octopi
            # get neighbours by looping over current index plus a unit offset in either direction
            # only return the neighbour if that index is inbounds
            neighbours = [i+I for I in unitOffsets if checkindexbounds(i+I, R)]
            # all neighbours get energy increase
            data[neighbours] .+= 1
        end
        # all new flashes: above 9 value but not in the set, get these coordinates
        flashing_octopi = @pipe R[data .> 9] .|> (_ ∉ flashing_octopi_thisstep) |> Set(R[data .> 9][_])
        # break loop if no new flashing flashing octopi are found
        length(flashing_octopi)==0 && break
        # add the ones that are going to flash next to the Set
        union!(flashing_octopi_thisstep, flashing_octopi)
    end
    # finally all above 9, reset to 0
    data[data .> 9] .= 0
    # increase number of flashes with the number of octopi who flashed
    n_flashes += length(flashing_octopi_thisstep)
    # if all synchronised, break!
    all(data .== 0) && (@show step; break)
end
data'
# see note above the loop
solution_1 = n_flashes
solution_2 = step

