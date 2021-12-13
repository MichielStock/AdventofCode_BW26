#=
author: Daan Van Hauwermeiren
AoC: day 13
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day13"
data = readlines(fn)
# THIS IS FUCKING CRAPPY CODING
idx_empty = collect(1:length(data))[data .== ""][1]
# coordinates into matrix of ints
coordinates = @pipe data[1:idx_empty-1] .|> split(_, ",") .|> parse.(Int, _) |> hcat(_...)'
dimstransformer = Dict('x'=>1, 'y'=>2)
# folds details in Vector of tuples, where the tuples are the dimension and the coordinate of the fold
folds = @pipe data[idx_empty+1:end] .|> split(_, "=") .|> (dimstransformer[_[1][end]], parse(Int, _[2]))
# loop over all folds
for (i, (dim, val)) in enumerate(folds)
    # find the coordinate values along the specific axis which will be out of bounds after a fold
    idx_outofbounds = coordinates[:,dim] .> val
    # change coordinates: the new value is minus twice the distance between the coordinate and the fold, and the current value.
    coordinates[idx_outofbounds,dim] = 2*val .- coordinates[idx_outofbounds,dim]
    # solution 1: all unique coordinates after one fold.
    i == 1 && (@show length(Set(eachrow(coordinates))))
end
# visualise the coordinates and find the letters
xmax, ymax = maximum(coordinates, dims=1)
paper = zeros(Bool, (xmax, ymax) .+ 1)
@pipe eachrow(coordinates .+ 1) .|> (paper[_...] = 1)
@pipe eachrow(paper') .|> println([dot ? "#" : "." for dot in _]...) # solution 2