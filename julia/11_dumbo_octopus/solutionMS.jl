### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 6e77bbf0-5c0a-11ec-0ff2-112c7faa170f
data_toy = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

# ╔═╡ c591e179-a568-48ad-b611-6270db6da9c6
data = """
2238518614
4552388553
2562121143
2666685337
7575518784
3572534871
8411718283
7742668385
1235133231
2546165345"""

# ╔═╡ f7a5b5af-55fa-4317-9668-726936abf0fd
M = [parse(Int, l[j]) for l in split(rstrip(data), "\n"), j in 1:10]

# ╔═╡ b43b1169-f8a7-4fb9-bc38-9699010ce384
function update!(M, nsteps, flashtime=false)
	C = CartesianIndices(M)
	Mnew = similar(M)
	I1 = first(C)
	Ifirst, Ilast = first(C), last(C)
	n_flashes = 0
	for t in 1:nsteps
		M .+= 1
		while any(>(9), M)
			for I in C
				if M[I] > 9 
					M[I] = 0
					n_flashes += 1
					for N in max(I1,I-I1):min(Ilast,I+I1)
						if M[N] > 0
							M[N] += 1
						end
					end
				end
			end
		end
		flashtime && all(isequal(0), M) && return M, t
	end
	return M, n_flashes
end

# ╔═╡ 5cf01371-678a-4e58-a11a-795a8239d9d1
_, solution1 = update!(copy(M), 100)

# ╔═╡ 88a9259c-5738-4a53-a50d-32f48aa3b485
_, solution2 = update!(copy(M), 1000000, true)

# ╔═╡ Cell order:
# ╠═6e77bbf0-5c0a-11ec-0ff2-112c7faa170f
# ╠═c591e179-a568-48ad-b611-6270db6da9c6
# ╠═f7a5b5af-55fa-4317-9668-726936abf0fd
# ╠═b43b1169-f8a7-4fb9-bc38-9699010ce384
# ╠═5cf01371-678a-4e58-a11a-795a8239d9d1
# ╠═88a9259c-5738-4a53-a50d-32f48aa3b485
