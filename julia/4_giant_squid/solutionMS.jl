#=
Created on 04/12/2021 12:04:55
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Wanna play Bingo? 🦑
=#

toy_input = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

function parse_input(input)
    input = rstrip(input)
    parts = split(input, "\n\n")
    numbers = parse.(Int, split(parts[1], ","))
    boards = Array{Int,3}(undef, length(parts)-1, 5, 5)
    for (k, board) in enumerate(parts[2:end])
        for (i, line) in enumerate(split(board, "\n"))
            for (j, num) in enumerate(eachmatch(r"\d+", line))
                boards[k, i, j] = parse(Int, num.match)
            end
        end
    end
    return numbers, boards
end

#numbers, boards = parse_input(toy_input)
numbers, boards = parse_input(read("data/4/input.txt", String))

# ---- QUESTION 1 ---- #

function play_bingo(numbers, boards)
    boards = copy(boards)
    for num in numbers
        replace!(boards, num=>-1)
        # check rows
        row_check = sum(isequal(-1), boards, dims=2) .== 5
        if any(row_check)
            board_id = findfirst(row_check) |> Tuple |> first
            board = boards[board_id,:,:]
            return num * reduce(+, filter(!isequal(-1), board))
        end
        col_check = sum(isequal(-1), boards, dims=3) .== 5
        if any(col_check)
            board_id = findfirst(col_check) |> Tuple |> first
            board = boards[board_id,:,:]
            return num * reduce(+, filter(!isequal(-1), board))
        end
    end
end

play_bingo(numbers, boards)

# ---- QUESTION 2 ---- #


function loose_bingo(numbers, boards)
    boards = copy(boards)
    n_boards = size(boards, 1)
    boards_playing = Set(1:n_boards)

    for num in numbers
        for id in boards_playing
            board = @view(boards[id,:,:])
            replace!(board, num=>-1)
            if any(isequal(5), sum(isequal(-1), board, dims=2)) ||
                any(isequal(5), sum(isequal(-1), board, dims=1))
                delete!(boards_playing, id)
            end
            isempty(boards_playing) && return num * reduce(+, filter(!isequal(-1), board))
        end
    end
end

loose_bingo(numbers, boards)