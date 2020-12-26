#=
author: Daan Van Hauwermeiren
AoC: day 11
=#
using Pkg
Pkg.activate(".")
using Pipe
# only is to convert the one letter substring to a char
parse_input(input) = @pipe split(rstrip(input), "\n") .|> split(_, "") .|> only.(_) |> hcat(_...)
seats = read("./data/day11.txt", String) |> parse_input

"""
get the values of each of the neighbours of a point
returns the value for valid neighbours, does not return anything if out of bounds
"""
function get_val_neighbour(seats, idx, neighbour)
    if checkbounds(Bool, seats, idx + neighbour)
        return seats[idx + neighbour]
    end
end

"""
get the values of each of the neighbours of a point
returns the value for valid neighbours, does not return anything if out of bounds
"""
function get_val_neighbour_in_looking_direction(seats, idx, neighbour)
    multiplier = 1
    while true
        if checkbounds(Bool, seats, idx + multiplier * neighbour)
            visible_seat = seats[idx + multiplier * neighbour]
            if visible_seat != '.'
                return visible_seat
            end
        # if out of bounds without finding an empty of occupied seat: this means that
        # we can only see the floor in this direction
        else
            return '.'
        end
        multiplier += 1
    end
end

"""
get all the values of the neighbours in a list, the size of the list depends on the number
of valid neighbours one point has.
filter! in combinations with checking if the value is nothing removes the unwanted values
"""
get_all_neighbours(seats, idx, neighbourhood; get_val_neighbour=get_val_neighbour) = filter!(!isnothing, map(x -> get_val_neighbour(seats, idx, x), neighbourhood))

"""
apply the seating rules depending on the value of the cell and its neighbours
"""
function update_seat(seats, idx, neighbourhood; n_seats_to_leave=4, get_val_neighbour=get_val_neighbour)
    # if this point is the floor ('.'), skip it since it does not change
    if seats[idx] == '.'
        return '.'
    end
    all_neighbours = get_all_neighbours(seats, idx, neighbourhood; get_val_neighbour)
    # If a seat is empty (L) and there are no occupied seats adjacent to it, 
    #the seat becomes occupied.
    if seats[idx] == 'L'
        if '#' ∉ all_neighbours
            return '#'
        else
            return 'L'
        end
    #If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
    # if seats[idx] == '#'
    else
        if count(all_neighbours .== '#') ≥ n_seats_to_leave
            return 'L'
        else
            return '#'
        end
    end
end

"""
loop over all indices and update the seats
"""
function update_all_seats(seats, neighbourhood; n_seats_to_leave=4, get_val_neighbour=get_val_neighbour)
    # the copy is needed because otherwise you are update the current seat plan
    new_seats = copy(seats)
    for idx in CartesianIndices(seats)
        @inbounds new_seats[idx] = update_seat(seats, idx, neighbourhood; n_seats_to_leave, get_val_neighbour)
    end
    return new_seats
end

"""
evolve the seating for different iterations
"""
function evolve_seats(seats; n_seats_to_leave=4, get_val_neighbour=get_val_neighbour)
    # generate a neighbourhood of indices
    neighbourhood = vcat(CartesianIndices((-1:1, -1:1))...)
    # remove the center
    deleteat!(neighbourhood, 5)

    new_seats = update_all_seats(seats, neighbourhood; n_seats_to_leave, get_val_neighbour)
    while !all(isequal.(seats, new_seats))
        seats = new_seats
        new_seats = update_all_seats(seats, neighbourhood; n_seats_to_leave, get_val_neighbour)
    end
    return seats
end

function solution_part1(seats)
    final_seats = evolve_seats(seats)
    count(final_seats .== '#')
end

function solution_part2(seats)
    final_seats = evolve_seats(seats; n_seats_to_leave=5, get_val_neighbour=get_val_neighbour_in_looking_direction)
    count(final_seats .== '#')
end

@show solution_part1(seats)
@show solution_part2(seats)

#using BenchmarkTools
#@btime solution_part1(seats)
#@btime solution_part2(seats)



