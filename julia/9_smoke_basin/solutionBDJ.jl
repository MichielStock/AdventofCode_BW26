#= --- Day 9: Smoke Basin ---
        Bram De Jaegher
=#


function read_data(input)
  raw = split(input, "\n") |> Array .|> x -> split(x, "") .|> (x -> parse(Int,x))
  return hcat(raw...)
end

struct Heightmap{T} <: AbstractMatrix{T}
  data::AbstractMatrix{T}
  max::T
  Heightmap(data::AbstractMatrix{T}) where T = new{T}(data, maximum(data), [])
end

Base.size(H::Heightmap) = size(H.data)
Base.getindex(H::Heightmap, i, j) = all((1,1) .≤ (i,j) .≤ size(H)) ? H.data[i,j] : H.max
Base.setindex!(H::Heightmap, value, i, j) = H.data[i,j] = value
neighbours(M, i, j) = (M[i-1,j], M[i,j-1], M[i+1,j], M[i,j+1])

function lowpoints(H::Heightmap) 
  N, M = size(H)
  L = 0 
  R = 0
  lp_map = Heightmap(zeros(Int, (N, M)))
  @inbounds for i in 1:N, j in 1:M
    if all(H[i,j] .< neighbours(H, i, j))
      L += 1
      R += (H[i,j] + 1)
      lp_map[i,j] = L
    end 
  end
  return  lp_map, R, L
end
  
function basinify(H, lp_map; N_iter=20)
  N, M = size(H)
  for i in 1:N_iter
    @inbounds for i in 1:N, j in 1:M
      (lp_map[i,j] != 0 | H[i,j] == 9) && continue
      lp_map[i,j] = maximum(neighbours(lp_map,i,j))
    end
  end
  return lp_map
end

# Test data
input_test = """
2199943210
3987894921
9856789892
8767896789
9899965678"""

heights = read_data(input_test) |> Heightmap
lp_map, R, L = lowpoints(heights)
basins = basinify(heights, lp_map)'
[basins .== i for i in 1:L] .|> count |> sort |> reverse |> x -> prod(x[1:3])


# Full data
 |> read_data |> Heightmap |> lowpoints |> risk_level

heights = read("data/9_smoke_basin/input.txt", String) |> read_data |> Heightmap
lp_map, R, L = lowpoints(heights)
basins = basinify(heights, lp_map)'
[basins .== i for i in 1:L] .|> count |> sort |> reverse |> x -> prod(x[1:3])
