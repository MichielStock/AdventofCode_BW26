
using Pkg
Pkg.activate(".")

struct CircularArray 
    data
end

circindex(i::Int,N::Int) = 1 + mod(i-1,N)
circindex(I,N::Int) = [circindex(i,N)::Int for i in I]

Base.size(A::CircularArray) = size(A.data)

Base.getindex(A::CircularArray, i::Int) = getindex(A.data, circindex(i,length(A.data)))
Base.getindex(A::CircularArray, I) = getindex(A.data, circindex(I,length(A.data)))

# these are for some dank reason not needed
#Base.setindex!(A::CircularArray, v, i::Int) = setindex!(A.data, v, circindex(i,length(A.data)))
#Base.setindex!(A::CircularArray, v, I) = setindex!(A.data, v, circindex(I,length(A.data)))    

"""
# notes and stuff

c = CircularArray(rand(10))
@assert c[11] == c[1] 
@assert c[-9:0] == c[1:10]

astring = "abcdef"
acircstring = CircularArray(astring)
# does not work
astring[10]
# gives the correct answer 'd'
acircstring[10]
"""


# init array of CircularArrays with len=number of lines in the file
slope = Array{CircularArray, 1}(undef, 323)

import Base.Iterators.enumerate

open("./data/day3.txt") do file
    for (idx, ln) in enumerate(eachline(file))
        slope[idx] = CircularArray(ln)
    end
end

slope

#=
Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
=#
right = 3
down = 1
xvals = 1:right:right*323
yvals = 1:down:323

thingsyoufind = [slope[yval][xval] for (xval, yval) in zip(xvals, yvals)]
sum(thingsyoufind .== '#')

function goingdowntheslope(right, down, slope)
    xvals = 1:right:right*323
    yvals = 1:down:323

    # this could be nicer in some sort of while loop with break statement
    # of leaving the slope, but meh, this works as well
    thingsyoufind = [slope[yval][xval] for (xval, yval) in zip(xvals, yvals)]
    return sum(thingsyoufind .== '#')
end    

goingdowntheslope(1, 2, slope)

slopestyles = (
    (1, 1), 
    (3, 1), 
    (5, 1), 
    (7, 1), 
    (1, 2), 
)

prod([goingdowntheslope(direction..., slope) for direction in slopestyles])