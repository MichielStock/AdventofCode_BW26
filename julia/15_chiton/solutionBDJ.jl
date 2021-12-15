# ---   Day 15: Chiton Shenanigans    --- #
#       author: Bram De Jaegher           #
# --- ------------------------------- --- #
# NOTES:
# - Quick estimation of brute-force => prod([n+2 for n in 1:100])*100 => impossible

mutable struct Cave <: AbstractMatrix{Int}
  data::Array{Int}
  Nₛ::Int
  Mₛ::Int

  Cave(small_map::Matrix{Int}) = new(small_map, size(small_map)...)
end

Base.size(t::Cave) = (t.Nₛ*5, t.Mₛ*5)

function Base.getindex(t::Cave, i, j) 
  if (0<i≤t.Nₛ) && (0<j≤t.Mₛ)    # if in bounds of original small_map
    return t.data[i,j]
  else
    I, J =  cld(i,t.Nₛ), cld(j,t.Mₛ)       # find block index (Cld == div(x,y,RoundUp))
    iₛ,jₛ = mod1(i,t.Nₛ), mod1(j,t.Mₛ)                          # find local index within block
    return mod1(t.data[iₛ,jₛ] + I + J - 2, 9)                       # set value
  end
end


function neighbour_indices(m, cave)
  N,M = size(cave)
  dirs = [(0, -1), (0, 1), (1, 0)]
  neighbours = [m .+ dir for dir in dirs]
  neighbours = filter(x -> (0<x[1]≤N) && (0<x[2]≤M), neighbours)
  return neighbours
end 

"""
  Dijkstra pathfinding algorithm, expertly "joinked" from Michiel Stock's course notes:
  https://github.com/MichielStock/STMO/blob/master/src/shortestpath.jl


    dijkstra(graph::AdjList{R,T}, source::T, sink::T) where {R<:Real,T}
Dijkstra's shortest path algorithm.
Inputs:
    - Cave with risk values
Outputs:
    - the shortest path
    - the cost of this shortest path
"""
function dijkstra(cave)
  N,M = size(cave)
  source = (N,M)
    # initialize the tentative distances
  distances = [Inf for i in 1:N, j in 1:M] 
  distances[1,1] = 0.0
  previous = Dict{Tuple,Tuple}()
  vertices_to_check = [(0.0, (1,1))]
  while length(vertices_to_check) > 0
    dist, u = heappop!(vertices_to_check)                       # Set current node
    if u == source                                                 # Check if node is end
      return reconstruct_path(previous, source,(1,1)), dist
      #return dist
    end
    for v in neighbour_indices(u,cave)                          # Select neighbours
        dist_u_v = cave[v...]
        new_dist = dist + dist_u_v
        if distances[v...] > new_dist
            distances[v...] = new_dist
            previous[v...] = u
            heappush!(vertices_to_check, (new_dist, v))
        end
    end
  end
end


"""
Reconstruct the path from the output of the Dijkstra algorithm, 
expertly "joinked" from Michiel Stock's course notes:
https://github.com/MichielStock/STMO/blob/master/src/shortestpath.jl
Inputs:
        - previous : a Dict with the previous node in the path
Ouput:
        - the shortest path from source to sink
"""
function reconstruct_path(previous::Dict, sink, source)
    path = [sink]
    current = path[1]
    while current != source
        current = previous[current]
        push!(path, current)
    end
    return reverse!(path)
end


using DataStructures
parse_data(str) =  split(str, "\n")  .|> collect |> (x -> hcat(x...)) .|> x -> parse(Int,x)

test_cave = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581""" |> parse_data |> Cave;
full_cave = read("./data/15_chiton/input.txt",String) |> parse_data |> x -> x' |> Matrix |> Cave

# --- Part 2 --- #
# Test
path, dist = dijkstra(test_cave)


# Full
path, dist = dijkstra(full_cave)

size(full_cave)

