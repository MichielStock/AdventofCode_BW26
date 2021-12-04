#=
author: Daan Van Hauwermeiren
AoC: day 3
=#
using Pkg
Pkg.activate(".")
using Pipe

mutable struct BingoBoard{T<:Int}
    board::Matrix{T}
    isdrawn::Matrix{Bool}
    function BingoBoard(mat::Array{T}) where T
        # board needs to be 5x5
        @assert size(mat) == (5,5)
        new{T}(mat, zeros(Bool, (5,5)))
    end
end

function Base.show(io::IO, ::MIME"text/plain", z::BingoBoard)
    println(io, summary(z.board), ":")
    Base.print_matrix(IOContext(io), z.board)
    println(io)
    println(io, summary(z.isdrawn), ":")
    Base.print_matrix(IOContext(io), z.isdrawn)
end

function get_data(fn)
    
    raw = read(fn, String)
    splitted = split(raw, "\n")

    draw_numbers = parse.(Int, split(splitted[1], ","))

    nboards = (length(splitted) - 1 ) ÷ 6
    boards = Vector{BingoBoard}(undef, nboards)

    delta = 6 # 1 row empty + five rows for the board

    for (cntr, i) in enumerate(2:delta:(delta*nboards))
        rawboard = splitted[i+1:i+delta-1]
        rawboard = parse.(Int, # parse strings to int
            hcat( # hcat with ellipsis to convert to matrix
                [j[1:2:end] for j in # data is like "["22", " ", "13", " ", "17", " ", "11", "  ", "0"]" so dropping even entries
                    split.( # split on word boundary
                        strip.(rawboard), # strip whitespace at beginning or end
                        r"\b")
                        ]...))

        boards[cntr] = BingoBoard(rawboard)
    end
    return draw_numbers, boards
end

function update_draw!(b::BingoBoard, val::T) where T<:Int
    # find a number on the board
    # do a boolean or to get the drawn numbers and the new one and store that
    b.isdrawn = (b.board .== val) .| b.isdrawn
    return nothing
end

# if any of the rows or columns is filled with true (=numbers are drawn: winner found!)
check_winner(b::BingoBoard) = any([sum(b.isdrawn, dims=1)[:] sum(b.isdrawn, dims=2)[:]] .== 5) ? true : false


function find_winning_board(draw_numbers::Vector{T}, boards::Vector{BingoBoard}) where T<:Int
    for draw_number in draw_numbers
        for board in boards
            update_draw!(board, draw_number)
            check_winner(board) ? (return board, draw_number) : continue
        end
    end
end

function get_winning_score(draw_numbers::Vector{T}, boards::Vector{BingoBoard}) where T<:Int
    winner, draw_number = find_winning_board(draw_numbers, boards)
    return sum(winner.board[.!winner.isdrawn]) * draw_number
end

draw_numbers, boards = get_data("./input_day4")
# solution 1
get_winning_score(draw_numbers, boards)



function get_losing_board(draw_numbers::Vector{T}, boards::Vector{BingoBoard}) where T<:Int
    for draw_number in draw_numbers
        # update all boards
        @pipe boards .|> update_draw!(_, draw_number)
        # check if there is only one board remaining and it has just one
        (length(boards) == 1 && check_winner(boards[1])) ? (return boards[1], draw_number) : nothing
        # removing all winning boards
        boards = boards[.!(check_winner.(boards))]
    end
end
draw_numbers, boards = get_data("./input_day4")
loser, draw_number = get_losing_board(draw_numbers, boards)
# solution 2
sum(loser.board[.!loser.isdrawn]) * draw_number