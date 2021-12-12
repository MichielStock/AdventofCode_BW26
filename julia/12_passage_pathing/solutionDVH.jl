#=
author: Daan Van Hauwermeiren
AoC: day 12
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day12"
connections = @pipe read(fn, String) |> strip(_) |> split(_, "\n") |> split.(_, "-")

# a dict with start and end caves
# a cave can connect to multiple others, so the values are sets of strings
adjacency = Dict{String,Set{String}}()

for (b, e) in connections
    # if key does not exist: init key,value-pair with empty set
    !haskey(adjacency, b) && (adjacency[b] = Set{String}())
    !haskey(adjacency, e) && (adjacency[e] = Set{String}())
    push!(adjacency[b], e)
    push!(adjacency[e], b)
end
adjacency

# defining islowercase for a string
# might not be 100% correct for all string edgecases, but it'll do in this example
import Unicode.islowercase
islowercase(s::AbstractString) = all([islowercase(c) for c in s])

#=
To tackle this day we need:
- how are cave connected: see adjacency a Dict of String => Set{String}. For a give cave, how is this one connected to the others
- determine which are the small caves: see islowercase function on strings

We need to tranverse from start to end and count how many path are valid, given restrictions:
- start = "start"
- end = "end"
- don't visit small caves more than once
- visit big caves any number of times

The approach is a greedy (not sure if the term is 100% correct), recursive algorithm which build up paths from start to end
from start: get all neighbouring caves, check if it is a small cave, continue exploring until the end is found.
Note that loops are not explicitly forbidden, so ignored it, apparantly was not an issue
The last line of the function is rewinding the path: you start exploring and when you have found an end, you trace back and explore other paths that might lead to the end.
=#
# init number of paths
n_paths = 0
# init the traversed small caves
# 
traversed_small_caves = Set{String}()

function find_all_paths(cave)
    # global because we are changing values recursively
    global n_paths
    # if small cave, add this to the set of traversed small caves
    islowercase(cave) && push!(traversed_small_caves, cave)
    # if we have arrived at the end cave, add one to the number of paths
    cave == "end" && (n_paths += 1)
    # loop over all neighbours in the current cave
    # if the neighbour is not in the traversed small caves, go one recursion deeper
    # because you do not want to visit the small caves twice!
    @pipe adjacency[cave] .|> (_ ∉ traversed_small_caves && find_all_paths(_))
    # finally if the cave is in the tranversed caves, delete it (=path rewinding)
    cave ∈ traversed_small_caves && delete!(traversed_small_caves, cave)
end

find_all_paths("start")
@show "solution 1", n_paths

# init number of paths
n_paths = 0
# init the traversed small caves
traversed_small_caves = Set{String}()
visited_twice = ""

function find_all_pathsv2(cave)
    # global because we are changing values recursively
    global visited_twice
    global n_paths

    # if small cave, add this to the set of traversed small caves
    islowercase(cave) && push!(traversed_small_caves, cave)
    # if we have arrived at the end cave, add one to the number of paths
    cave == "end" && (n_paths += 1)

    # loop over all neighbours of the input cave
    for neighbour in adjacency[cave]
        # if the neighbouring has not been traversed (only check for small caves), go one recursion deeper
        if neighbour ∉ traversed_small_caves
            find_all_pathsv2(neighbour)
        # if the neighbouring cave is not a small cave that has been visited twice
        elseif visited_twice == ""
            # if the neighbour is the start or end cave, skip!
            (neighbour ∈ ["start", "end"]) && continue
            # store which one have been visited, note: this will always be a lowercase cave,
            # because large cave will always be going to the 'if' a few lines above
            visited_twice = neighbour
            # go one recursion deeper
            find_all_pathsv2(neighbour)
        end 
    end

    # if the input cave is in the traversed caves
    #   and has been visited twice: reset visited twice
    #   not visited twice: delete current cave from the traversed caves
    cave ∈ traversed_small_caves && (cave == visited_twice ? (visited_twice = "") : delete!(traversed_small_caves, cave))
end

find_all_pathsv2("start")
@show "solution 2", n_paths

