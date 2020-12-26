#=
author: Daan Van Hauwermeiren
AoC: day 5
=#

using Pkg
Pkg.activate(".")

using DelimitedFiles
fn = "./data/day5.txt"

data = readdlm(fn, String)

# make a structure that has the seat range
mutable struct SeatInterval
    min::Int
    max::Int
end

#=
function to split the range based on a character
will take the first of the second half of the range
=#
function split_range(seatinterval::SeatInterval, how::Char)
    mean = (seatinterval.min + seatinterval.max)/2;
    # left and right seem logical characters to process
    if how=='l'
        seatinterval.max = Int(floor(mean));
    elseif how=='r'
        seatinterval.min = Int(ceil(mean));
    end   
end

# process a ticket by repeatably applying the split_range on the interval
# and returning the result
function process_sieve(seatinterval::SeatInterval, steps::String)
    map(x -> split_range(seatinterval, x), collect(steps))
    return seatinterval.min
end

# row or column start with a different size
process_row(steps::String) = process_sieve(SeatInterval(0,127), steps)
process_col(steps::String) = process_sieve(SeatInterval(0,7), steps)

function seatid(row, col)
    return row*8 + col
end

# process a data entry: replace the letters, split it and return the row, column tuple
function process_entry(ticket::String)
    patterns = Dict('F'=>'l', 'B'=>'r', 'L'=>'l', 'R'=>'r')
    for pattern in patterns
        ticket = replace(ticket, pattern)
    end
    rowcode, colcode = ticket[1:end-3], ticket[end-2:end]
    row = process_row(rowcode)
    col = process_col(colcode)
    return seatid(row, col)
end

process_entry(data[1])

ids_data = vcat(map(process_entry, data)...)
sort!(ids_data)

# part 1
max(ids_data...)



# I do not need to compute this because there are 8 seats in a row
# and the id is rownumber*8+col, so all ids are 0:(128*8-1)
#allids = sort!(vcat([seatid(row, col) for (row, col) in product(0:127, 0:7)]...))
#allids = 0:(128*8-1)

# in the whole seat range possibilities, find the seat that is not in the data 
# extra brackets at the end for a broadcast trick
allids = collect(min(ids_data...):max(ids_data...))
res = allids .∉ [ids_data]
# find the index and get the id
allids[findall(isone, res)[1]]
