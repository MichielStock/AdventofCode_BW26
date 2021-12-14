### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 4bd31be8-5bfc-11ec-1ba9-cded82716a94
toy_data = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

# ╔═╡ 714dbb04-339f-4021-a2be-09af5ac61273
data = """
mx-IQ
mx-HO
xq-start
start-HO
IE-qc
HO-end
oz-xq
HO-ni
ni-oz
ni-MU
sa-IE
IE-ni
end-sa
oz-sa
MU-start
MU-sa
oz-IE
HO-xq
MU-xq
IE-end
MU-mx
"""

# ╔═╡ 3722a96d-d75b-47ef-a97b-ca23e7aa6bdb
data2edges(input) = split(rstrip(data), "\n") .|> s -> split(s, "-")

# ╔═╡ 84c74639-3879-4cf0-90a7-d08fbdddcd8c
edges = data2edges(data)

# ╔═╡ bc8dcaee-00fb-415d-8c25-800681648ff7
function edges2adjlist(edges)
	adjlist = Dict{String,Vector{String}}()
	for (u, v) in edges
		if haskey(adjlist, u)
			push!(adjlist[u], v)
		else
			adjlist[u] = [v]
		end
		if haskey(adjlist, v)
			push!(adjlist[v], u)
		else
			adjlist[v] = [u]
		end
	end
	return adjlist
end

# ╔═╡ b69f88e0-c5c5-4bd1-9c3e-d291c4a3399b
adjlist = edges2adjlist(edges)

# ╔═╡ d1bc54d3-0fb6-4e4d-b9ab-309a09d82fa2
function explore_caves(adjlist)
	open = [["start"]]
	closed = Vector{String}[]
	while !isempty(open)
		path = pop!(open)
		for n in adjlist[last(path)]
			if n == "end"
				push!(closed, push!(copy(path), n))
			elseif isuppercase(first(n)) || n ∉ path
				# big cave, explore!
				push!(open, push!(copy(path), n))
			end 
		end	
	end
	return closed
end

# ╔═╡ 7c77a2bc-19b3-499f-a768-a38c84fed0b4
paths = explore_caves(adjlist)

# ╔═╡ 0de0e14c-b91d-465d-ad7e-eb9904c1cea7
solution1 = length(paths)

# ╔═╡ a7f40a47-2bef-419e-96f5-acc3618088d3
function explore_caves2(adjlist)
	open = [["start"]]
	closed = Vector{String}[]
	duplicates = Set{UInt64}()  # hash to check duplicates
	while !isempty(open)
		path = pop!(open)
		h = hash(path)
		for n in adjlist[last(path)]
			n == "start" && continue
			if n == "end"
				push!(closed, push!(copy(path), n))
			elseif isuppercase(first(n))
				# big cave, explore!
				push!(open, push!(copy(path), n))
				h ∈ duplicates && push!(duplicates, hash(last(open)))
			elseif  n ∉ path
				# small cave, unvisited
				push!(open, push!(copy(path), n))
				h ∈ duplicates && push!(duplicates, hash(last(open)))
			elseif h ∉ duplicates
				push!(open, push!(copy(path), n))
				push!(duplicates, hash(last(open)))
			end
		end	
	end
	return closed
end

# ╔═╡ 048255ea-70b7-482d-8dde-9c3c52955361
paths2 = explore_caves2(adjlist)

# ╔═╡ 1ab89da5-a570-4094-ab7f-8b61a63a4185
hash(first(paths2)) |> eltype

# ╔═╡ 198a49cd-9795-44c7-af2a-817e193ad3d3
solution2 = length(paths2)

# ╔═╡ Cell order:
# ╠═4bd31be8-5bfc-11ec-1ba9-cded82716a94
# ╠═714dbb04-339f-4021-a2be-09af5ac61273
# ╠═3722a96d-d75b-47ef-a97b-ca23e7aa6bdb
# ╠═84c74639-3879-4cf0-90a7-d08fbdddcd8c
# ╠═bc8dcaee-00fb-415d-8c25-800681648ff7
# ╠═b69f88e0-c5c5-4bd1-9c3e-d291c4a3399b
# ╠═d1bc54d3-0fb6-4e4d-b9ab-309a09d82fa2
# ╠═7c77a2bc-19b3-499f-a768-a38c84fed0b4
# ╠═0de0e14c-b91d-465d-ad7e-eb9904c1cea7
# ╠═a7f40a47-2bef-419e-96f5-acc3618088d3
# ╠═048255ea-70b7-482d-8dde-9c3c52955361
# ╠═1ab89da5-a570-4094-ab7f-8b61a63a4185
# ╠═198a49cd-9795-44c7-af2a-817e193ad3d3
