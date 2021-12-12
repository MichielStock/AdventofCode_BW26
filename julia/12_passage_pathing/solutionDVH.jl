#=
author: Daan Van Hauwermeiren
AoC: day 12
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day12"
connections = @pipe read(fn, String) |> strip(_) |> split(_, "\n") |> split.(_, "-")

# a dict with start and end nodes
# a node can connect to multiple others, so the values are sets of strings
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


# init number of paths
n_paths = 0
# init the traversed nodes
traversed_nodes = Set()

function find_all_paths(node)
    # global because we are changing values recursively
    global n_paths
    # if lowercase node, add this to the set of traversed nodes
    islowercase(node) && push!(traversed_nodes, node)
    # if we have arrived at the end node, add one to the number of paths
    node == "end" && (n_paths += 1)
    # loop over all neighbours in the current node
    # if the neighbour is not in the traversed nodes, go one recursion deeper
    @pipe adjacency[node] .|> (_ ∉ traversed_nodes && find_all_paths(_))
    # finally if the node is in the tranversed nodes, delete it
    node ∈ traversed_nodes && delete!(traversed_nodes, node)
end

find_all_paths("start")
@show "solution 1", n_paths

# init number of paths
n_paths = 0
# init the traversed nodes
traversed_nodes = Set()
visited_twice = ""

function find_all_pathsv2(node)
    # global because we are changing values recursively
    global visited_twice
    global n_paths

    # if lowercase node, add this to the set of traversed nodes
    islowercase(node) && push!(traversed_nodes, node)
    # if we have arrived at the end node, add one to the number of paths
    node == "end" && (n_paths += 1)

    # loop over all neighbours of the input node
    for neighbour in adjacency[node]
        # if the neighbour has not been traversed, go one recursion deeper
        if neighbour ∉ traversed_nodes
            find_all_pathsv2(neighbour)
        # if the neighbour has not been visited twice
        elseif visited_twice == ""
            # if the neighbour is the start or end node, skip!
            (neighbour ∈ ["start", "end"]) && continue
            # store which one have been visited, note: this will always be a lowercase node
            visited_twice = neighbour
            # go one recursion deeper
            find_all_pathsv2(neighbour)
        end 
    end

    # if the input node is in the traversed nodes
    #   and has been visited twice: reset visited twice
    #   not visited twice: delete current node from the traversed nodes
    node ∈ traversed_nodes && (node == visited_twice ? (visited_twice = "") : delete!(traversed_nodes, node))
end

find_all_pathsv2("start")
@show "solution 1", n_paths

