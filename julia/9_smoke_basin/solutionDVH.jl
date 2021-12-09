#=
author: Daan Van Hauwermeiren
AoC: day 9
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day9"
heatmap = @pipe read(fn, String) |> strip(_) |> split(_, "\n") |> split.(_, "") |> hcat(_...) |> parse.(Int, _)

# generate Cartesian indices for our data matrix
R = CartesianIndices(heatmap)
# define unit offsets in each dimension
unitOffset_i = CartesianIndex( (1, 0) )
unitOffset_j = CartesianIndex( (0, 1) )
# convoluted, because you only have 2 dimensions
# d runs over the neighbors, for each dimension one
# for d in 1:ndims(heatmap)
#     @show CartesianIndex(ntuple(i->i==d ? 1 : 0, ndims(heatmap)))
# end

# define all unit offsets in all directions: so four in total
unitOffsets = unitOffset_i, -unitOffset_i, unitOffset_j, -unitOffset_j

# function to check bounds, returns true if input index is a valid index
checkindexbounds(i::CartesianIndex, R::CartesianIndices) = all(first(R).I .<= i.I .<= last(R).I)

lowpointsmap = zeros(Bool, size(heatmap))
# loop over all indices
for i in R
    # get neighbours by looping over current index plus a unit offset in either direction
    # only return the neighbour if that index is inbounds
    neighbours = [i+I for I in unitOffsets if checkindexbounds(i+I, R)]
    # check if i is a valley: higher value than all neighbours
    if all(heatmap[i] .< heatmap[neighbours])
        lowpointsmap[i] = 1
    end
end

solution_1 = heatmap[lowpointsmap] .+ 1 |> sum

# basin starts at all zeros except for the lowest points
# these are numbers from 1 to the total number of low points
basin = zeros(Int, size(lowpointsmap))
n_lowpoints = sum(lowpointsmap)
basin[lowpointsmap] = 1:n_lowpoints


# the thing in the inner loop is naively looping over all coordinates and checking something
# in the vicinity, it is possible that due to ordering not all points are correctly filled
# in on a first pass, therefore looping multiple times.
# this should always converge, because I exclude the ridges
for _ in 1:20
    # looping over all coordinates, except the lowest points since these do not need alteration,
    # and the ridges (value=9), because by definition this point does not below to a basin
    for i in R[(.!lowpointsmap) .& (heatmap .!= 9)]
        # @show heatmap[i]
        # get neighbours by looping over current index plus a unit offset in either direction
        # only return the neighbour if that index is inbounds
        neighbours = [i+I for I in unitOffsets if checkindexbounds(i+I, R)]
        basin[i] = maximum(basin[neighbours])
    end
end
basin


solution_2 = @pipe 1:n_lowpoints .|> sum(basin .== _) |> sort(_, rev=true)[1:3] |> prod