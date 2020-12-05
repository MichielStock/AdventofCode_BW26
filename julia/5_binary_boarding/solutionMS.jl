#=
Author: Michiel Stock
AoC: day 5

Find Santa's boarding pass.
=#

function parse_boarding_pass(bp::Vector{Char})
    row = 0
    for i in 1:7
        bp[i] == 'B' && (row += 2^(7-i))
    end
    column = 0
    for i in 8:10
        bp[i] == 'R' && (column += 2^(3-i+7))
    end
    id = 8 * row + column
    return id, row, column
end

# dispatch baby!
parse_boarding_pass(bp::AbstractString) = parse_boarding_pass([bp...])

fn = "data/5_binary_boarding/input.txt"

bpids = split(rstrip(read(fn, String)), "\n") .|> parse_boarding_pass .|> first

# what is the highest id
highest_id = maximum(bpids)
println("first soluton (highest id): $highest_id")

# your id is the one missing which has one higher and one lower
missing_ids = setdiff(1:1000, bpids)
my_id = filter(id -> ((id-1) ∈ bpids && (id+1) ∈ bpids), missing_ids) |> pop!
println("second soluton (my id): $my_id")