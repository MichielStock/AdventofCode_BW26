# --- Day 20: Trench Map --- #
#   Author: Bram De Jaegher  #
# -------------------------- #

function read_data(input)
  raw = split(input, "\n") |> Array .|> x -> split(x, "") .|> (x -> x .== "#")
  return hcat(raw...)
end

mutable struct Image <: AbstractMatrix{Bool}
  data::AbstractMatrix{Bool}
  Image(data::AbstractMatrix{Bool}) = new(data)
end

Base.size(img::Image) = size(img.data)
Base.getindex(img::Image, I, J) = [[all((1,1) .≤ (i,j) .≤ size(img)) ? img.data[i,j] : false for j in J] for i in I] |> x -> hcat(x...)
function Base.getindex(img::Image, i::Number, j::Number) 
  if all((1,1) .≤ (i,j) .≤ size(img)) 
    return img.data[i,j] 
  else 
    return img.data[1,1]
  end
end

Base.firstindex(img::Image) = 1
Base.lastindex(img::Image) = length(S)

Base.setindex!(img::Image, value, i, j) = img.data[i,j] = value

function Base.show(io::IO, ::MIME"text/plain", t::Image)
  for row in eachrow(t)
   println([dot ? "#" : "." for dot in row]...)
  end
  return ""
end

function grow!(img::Image; n=10, value=false)
  N,M = size(img)
  oldData = deepcopy(img.data) 
  img.data = fill(value,N+n, M+n)
  img.data[(n÷2+1):(end-n÷2),(n÷2+1):(end-n÷2)] = oldData
  return img
end


neighbours(img::Image, i, j) = BitArray([img[i-1,j-1], img[i-1,j], img[i-1,j+1], img[i,j-1], img[i,j], img[i,j+1], img[i+1,j-1], img[i+1,j], img[i+1,j+1]])
decode(b::BitArray) = sum([value*2^(i-1) for (i,value) in enumerate(reverse(b))])

function update!(img::Image, algorithm; grow_value=false)
  img = grow!(img;value=grow_value) # grow image
  N,M = size(img) 
  imgNew = Image(deepcopy(img.data))
  for i in 1:N
    for j in 1:M  
     imgNew[i,j] = algorithm[decode(neighbours(img,i,j))+1]
    end
  end
  return imgNew
end


# --- Part 1 ---- #
# Test

algorithm = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#" |> collect .|> x -> x == '#' 
input_test ="""
#..#.
#....
##..#
..#..
..###""" |> read_data |> transpose |> Image

input_test = update!(input_test, algorithm)
input_test = update!(input_test, algorithm)
sum(input_test)

# full
raw = read("./data/20_trench_map/input.txt", String)
algorithm_full = split(raw,"\n\n")[1]  |> collect .|> x -> x == '#'
input_full = split(raw,"\n\n")[2]  |> read_data |> transpose|> Image

for i in 1:2
  println(i)
  input_full = update!(input_full, algorithm_full, grow_value=iseven(i))
end

sum(input_full)


# --- Part 2 --- #
raw = read("./data/20_trench_map/input.txt", String)
algorithm_full = split(raw,"\n\n")[1]  |> collect .|> x -> x == '#'
input_full = split(raw,"\n\n")[2]  |> read_data |> transpose|> Image

for i in 1:50
  println(i)
  input_full = update!(input_full, algorithm_full, grow_value=iseven(i))
end