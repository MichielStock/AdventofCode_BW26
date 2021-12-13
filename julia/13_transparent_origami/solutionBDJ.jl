# --- Day 13: Transparent Origami --- #
#     Author: Bram De Jaegher
# --- --------------------------- --- #


mutable struct Transparent <: AbstractMatrix{Bool}
  data::Array{Bool}
  N::Int
  M::Int

  """
  Constructor in case of reading a list of coordinates
  """
  function Transparent(dots::Vector{Vector{Int}})  
    N, M = maximum(last.(dots)), maximum(first.(dots))
    if iseven(N)
       N += 1
    end 
    if iseven(M) 
      M += 1
    end 
    data = zeros(Bool, N, M)
    for dot in dots
      data[reverse(dot)...] = true
    end
    return new(data, N, M)
  end

  """
  Constructor in case of reading in a BitMatrix
  """
  Transparent(data::BitMatrix) = new(data, size(data)...)
end

Base.size(t::Transparent) = (t.N, t.M)
Base.getindex(t::Transparent, i, j) = t.data[i,j]

function Base.show(io::IO, ::MIME"text/plain", t::Transparent)
  for row in eachrow(t)
   println([dot ? "#" : "." for dot in row]...)
  end
  return ""
end

"""
  Vertical middle fold
"""
function fold_y(a)
  fold1 = a[1:end÷2,:]
  fold2 = reverse(a[end÷2+2:end,:], dims=1)

  return Transparent(fold1 + fold2 .> 0)
end

"""
  Horizontal middle fold
"""
function fold_x(a)
  fold1 = a[:, 1:end÷2]
  fold2 = reverse(a[:, end÷2+2:end], dims=2)

  return Transparent(fold1 + fold2 .> 0)
end


read_dots(str) = split(str, "\n") .|> x -> split(x, ",") .|> (x -> parse.(Int, x)) |> x -> x.+[1, 1]

example = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0"""


# --- Part 1 --- #
# Test input
dots = read_dots(example) |> Transparent
dots2 = fold_y(dots);

# Full input
dots_full = read("./data/13_transparent_origami/input.txt", String) |> x -> split(x,"\n\nfold")[1] |> read_dots |> Transparent;
dots2 = fold_x(dots_full);

dots2 |> count

# --- Part 2 --- #
instructions = read("./data/13_transparent_origami/input.txt", String) |> x -> split(x,"fold along ")[2:end] .|> strip 

folded_dots = copy(dots_full);
for instruction in instructions
  dir = instruction[1]
  if dir == 'x'
    folded_dots = fold_x(folded_dots)
    println(size(folded_dots))
  else
    folded_dots = fold_y(folded_dots)
  end
end


