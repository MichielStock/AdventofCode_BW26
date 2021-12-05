#=
author: Daan Van Hauwermeiren
AoC: day 3
=#
using Pkg
Pkg.activate(".")
using Pipe
using OffsetArrays
using SparseArrays


"""
based on two coordinates x1, x2 get generator of coordinates in that dimension
if x1==x2, just cycle through the value
else create a range
"""
function get_range(x1, x2)
    if x1 == x2
        return Base.Iterators.cycle(x1)
    else
        xstep = x1 < x2 ? 1 : -1
        return x1:xstep:x2
    end
end

function get_vent_coords(a)
    xrange = get_range(a[1], a[3])
    yrange = get_range(a[2], a[4])
    # note: zip will stop when any of the inputs terminates,
    # that why an infinite cycle is used in `get_range`
    return collect(zip(xrange, yrange))
end


fn = "input_day5"
raw = read(fn, String)

# split raw string on the linebreak, also ignore last empty line
splitted = split(raw, "\n")[1:end-1]
# split each entry on " -> ", then on ",", concatenate so we get a Vector of Vectors of strings
# then parse strings to integers. result is a Vector{Vector{Int64}}
# then pipe the whole thing into vcat to get a Nx4 matrix, the columns are [x1 y1 x2 y2]
coordinates = @pipe splitted .|> split(_, " -> ") .|> split.(_, ",") .|> vcat(_...) .|> parse.(Int, _) |> hcat(_...)'

xmin, xmax = minimum(coordinates[1:end, [1,3]]), maximum(coordinates[1:end, [1,3]])
ymin, ymax = minimum(coordinates[1:end, [2,4]]), maximum(coordinates[1:end, [2,4]])

# use an offsetarray to get a matrix with the size of the oceanfloor,
# a rectangular between the corners (xmin, ymin) and (xmax, ymax)
# indices are offset by these mins and maxes so that indexing is pretty straightforward
# use sparse matrix to lower the memory stuffs
oceanfloor = OffsetArray(
    spzeros(xmax - xmin +1, ymax - ymin +1),
    CartesianIndex(xmin, ymin):CartesianIndex(xmax, ymax)
)

#=
    question 1
=# 
for row in eachrow(coordinates)
    # For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.
    (row[1] == row[3]) | (row[2] == row[4]) ? nothing : continue
    for coord in get_vent_coords(row)
        oceanfloor[coord...] += 1
    end
end

# for checking the test output visually
#oceanfloor'

solution_1 = sum(oceanfloor .≥ 2)

#=
    question 2
=# 
# new ocean
oceanfloor = OffsetArray(
    zeros(Int64, (xmax - xmin +1, ymax - ymin +1)),
    CartesianIndex(xmin, ymin):CartesianIndex(xmax, ymax)
)

for row in eachrow(coordinates)
    for coord in get_vent_coords(row)
        oceanfloor[coord...] += 1
    end
end

# for checking the test output visually
#oceanfloor'

solution_2 = sum(oceanfloor .≥ 2)

