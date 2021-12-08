#=
author: Daan Van Hauwermeiren
AoC: day 8
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day8"
read_data(fn) = @pipe read(fn, String) |> strip(_) |> split(_, "\n") |> split.(_, " | ")
data = read_data(fn)

#=
    part 1
=#

output_values = vcat((@pipe data .|> _[2] |> split.(_, " "))...)
# get length
lengthof = output_values .|> length

sum([
    sum(lengthof .== 2), # number 1
    sum(lengthof .== 4), # number 4
    sum(lengthof .== 3), # number 7
    sum(lengthof .== 7), # number 8
])

#=
    part 2
=#

function parse_entry(entry)
    before, after = @pipe entry |> split.(_, " ")
    # convert each string into sets
    sets = Set.(before)
    after = Set.(after)

    # the easy stuff, similar to part 1
    # length 7 is number 8
    set_8 = first(sets[length.(sets) .== 7])
    # length 2 is number 1
    set_1 = first(sets[length.(sets) .== 2])
    # length 3 is number 7
    set_7 = first(sets[length.(sets) .== 3])
    # length 4 is number 4
    set_4 = first(sets[length.(sets) .== 4])

    # now we know: X,1,X,X,4,X,X,7,8,X

    #=
     0:
     _
    | |
     .
    | |
     _
    
     6:
     _
    | .
     _
    | |
     _

     9:
     _
    | | 
     _
    . |
     _

    =#
    idx_sixes = length.(sets) .== 6
    # remove all letters from 7
    # do a set difference with number 7
    # numbers 0 and 9 have 3 elements, number 6 has 4 elements
    #=
     0:
     .
    | .
     .
    | .
     _
    
     6:
     .
    | .
     _
    | .
     _

     9:
     .
    | . 
     _
    . .
     _

    =#
    sets_sixninezero = @pipe sets[idx_sixes] .|> setdiff(_, set_7) 
    # retain only the one with 4 elements, this is number 6
    idx_is6 = length.(sets_sixninezero) .== 4
    set_6 = first(sets[idx_sixes][idx_is6])

    # now we know: X,1,X,X,4,X,6,7,8,X
    
    # those with number of elements not equal to 4 are the numbers 0 and 9
    sets_ninezero = sets[idx_sixes][length.(sets_sixninezero) .!= 4]
    # do a set difference with number 4
    # number 9 has 2 elements left
    #=
     0:
     _
    . .
     .
    | .
     _
    
     9:
     _
    . . 
     .
    . . 
     _

    =#
    isnine = @pipe sets_ninezero .|> (length(setdiff(_, set_4)) .== 2)
    set_9 = first(sets_ninezero[isnine])
    set_0 = first(sets_ninezero[.!isnine])
    
    # now we know: 0,1,X,X,4,X,6,7,8,9

    idx_fives = length.(sets) .== 5

    #=
     2:
     _
    . |
     _
    | .
     _
    
     3:
     _
    . |
     _
    . | 
     _

     5:
     _
    | . 
     _
    . |
     _

    =#
    
    # intersect with number 9, number 2 has one element left
    #=
     2:
     .
    . .
     .
    | .
     .
     
     3:
     .
    . .
     .
    . .
     .

     5:
     .
    . .
     .
    . .
     .
    =#
    set_2 = first(sets[idx_fives][@pipe sets[idx_fives] .|> (length(setdiff(_, set_9)) .== 1)])

    # intersect with number 6, number 3 has one element left

    #=  
     3:
     .
    . |
     .
    . . 
     .

     5:
     .
    . . 
     .
    . .
     .

    =#
    isthree = @pipe sets[idx_fives][@pipe sets[idx_fives] .|> (length(setdiff(_, set_9)) .== 0)] .|> (length(setdiff(_, set_6)) .== 1)

    set_3  = first(sets[idx_fives][@pipe sets[idx_fives] .|> (length(setdiff(_, set_9)) .== 0)][isthree])

    set_5  = first(sets[idx_fives][@pipe sets[idx_fives] .|> (length(setdiff(_, set_9)) .== 0)][.!isthree])
    numbers

    # make a translation dict to go from a set to a number
    translation = Dict(
        set_0 => 0,
        set_1 => 1,
        set_2 => 2,
        set_3 => 3,
        set_4 => 4,
        set_5 => 5,
        set_6 => 6,
        set_7 => 7,
        set_8 => 8,
        set_9 => 9,
    )

    # translate the "test" sets to a vector of integers
    # parse each integer to string and concat them into one string
    # convert this 4-number string to an integer and return this
    #return parse(Int, prod(string.(@pipe after .|> translation[_])))
    
    # an easier solution to the one above because it will always be four displays
    return sum((@pipe after .|> translation[_]) .* [1000, 100, 10, 1])
end


all_output = parse_entry.(data)
sum(all_output) #1016804

