#= --- Day 4: Giant Squid game ---
        Bram De Jaegher
=#

mutable struct BingoBoard{T} <: AbstractMatrix{T}
  layout::AbstractMatrix
  rowMarks::Vector
  colMarks::Vector
	marked::Set{Any}
	bingo::Bool

  function BingoBoard(layout::AbstractMatrix{T}) where T
		N, M = size(layout)
		return new{T}(layout, zeros(T,N), zeros(T,M), Set{T}(), false)
	end
end

Base.size(B::BingoBoard) = size(B.layout)
Base.getindex(B::BingoBoard, i, j) = B.layout[i,j]
Base.setindex!(B::BingoBoard, value, i, j) = B.layout[i,j] = value
unmarked(B::BingoBoard) = setdiff!(Set(B.layout), B.marked)

check(B::BingoBoard, value) = findfirst(B .== value)
function mark!(B::BingoBoard, indices)
	B.rowMarks[indices[1]] += 1
	B.colMarks[indices[2]] += 1
	if !B.bingo 
		B.marked = union(B.marked, B[indices])
	end
	if maximum([B.rowMarks; B.colMarks]) > 4 && !B.bingo
		B.bingo = true
		return B
	else
		return false
	end
end

function update!(B::BingoBoard, value)
	indices = check(B, value)
	if indices != nothing
		return mark!(B, indices)
	else
		return false 
	end
end

function update!(G::Vector, value)
	tracker = false
	for B in G 
		bingo = update!(B, value)
		if bingo != false
			tracker = bingo
		end
	end
	return tracker
end

function firstBingo(boards::Vector, draws)
	for draw in draws
		bingo = update!(boards, draw)
		if bingo != false
			return bingo, draw
		end
	end
end

function lastBingo(boards::Vector, draws)
	tracker = (false, false)
	for draw in draws
		bingo = update!(boards, draw)
		if bingo != false
			tracker=(bingo, draw)
		end
	end
	return tracker
end

parse_data(str) = split(str,"\n") .|> split  .|> (l->parse.(Int, l)) |> H->hcat(H...)


# --- Part 1 --- #

# Test input
input_test = """
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
 2  0 12  3  7"""


draws = split(input_test,"\n\n")[1] |> (x -> split(x,",")) .|> x -> parse(Int, x)
boards_raw = split(input_test,"\n\n")[2:end]

boards = [BingoBoard(board_raw |> parse_data) for board_raw in boards_raw]

winner, draw = firstBingo(boards, draws)
winner |> unmarked |> sum |> x -> x*draw

# Full input
draws = read("./data/4_giant_squid/input.txt", String) |> (x -> split(x,"\n\n")[1]) |> (x -> split(x,",")) .|> x -> parse(Int, x)
boards_raw = read("./data/4_giant_squid/input.txt", String) |>  x -> split(x,"\n\n")[2:end]

boards = [BingoBoard(board_raw |> parse_data) for board_raw in boards_raw]

winner, draw = firstBingo(boards, draws)
winner |> unmarked |> sum |> x -> x*draw

# --- Part 2 ---
# Test
draws = split(input_test,"\n\n")[1] |> (x -> split(x,",")) .|> x -> parse(Int, x)
boards_raw = split(input_test,"\n\n")[2:end]

boards = [BingoBoard(board_raw |> parse_data) for board_raw in boards_raw]

last_winner, draw = lastBingo(boards, draws)
last_winner |> unmarked  

|> sum |> x -> x*draw


# Full
draws = read("./data/4_giant_squid/input.txt", String) |> (x -> split(x,"\n\n")[1]) |> (x -> split(x,",")) .|> x -> parse(Int, x)
boards_raw = read("./data/4_giant_squid/input.txt", String) |>  x -> split(x,"\n\n")[2:end]

boards = [BingoBoard(board_raw |> parse_data) for board_raw in boards_raw]

winner, draw = lastBingo(boards, draws)
winner |> unmarked |> sum |> x -> x*draw