#=
author: Daan Van Hauwermeiren
AoC: day 14
=#
using Pkg
Pkg.activate(".")
using Pipe
using StatsBase
using DataStructures

#=
ABCS
split into / loop over
AB BC CS

then check all rules and make the insertions
AXB BXC CXS

then remove too many lettes?
or just store AX BX CX etx?

make something to count the letters
=#

fn = "./input_day14"
polymer_template, pair_insertions_raw = @pipe readlines(fn) |> (_[1], _[3:end])
# this is a dict of String => String
# it replaces a current pair with the first two letters of a new triplet
# XY generates a new character Z
# so that it would become XZY
# I only keep XZ here because that makes it easier to generate the complete polymer string
pair_insertions = @pipe pair_insertions_raw .|> split(_, " -> ") .|> [_[1], _[1][1]*_[2]] |> hcat(_...) |> Dict(_[1,:] .=> _[2,:])

function get_next_polymer(polymer, pair_insertions)
    polymer_new = ""
    for i in 1:length(polymer)-1
        polymer_new *= pair_insertions[polymer[i:i+1]]
    end
    return polymer_new * polymer[end]
end

polymer = polymer_template
n_steps = 10
for i in 1:n_steps
    polymer = get_next_polymer(polymer, pair_insertions)
end
cm = countmap(polymer)
k, v = collect.([keys(cm), values(cm)])
# naive solution 1
maximum(v) - minimum(v)

# this obviously blows up after 40 iterations, so something better is needed






# a better solution

fn = "./input_day14"
polymer_template  = readlines(fn)[1]
#=
read the rules, split each line on " -> ", convert to Vector of a String, Char pair 
(note the [1] on the second element to convert a String to Char),
concatenate the vectors and pipe to a Dict
Maybe, there is a better way to do these last two steps
=#
rules = @pipe readlines(fn)[3:end] .|> split(_, " -> ") .|> [_[1], _[2][1]] |> hcat(_...) |> Dict(_[1,:] .=> _[2,:])

#=
create accumulator objects from DataStructures
this can probably also be done with plain Dicts, but the application of the inc! function
on the Accumulator looked so elegant in this case.
=#
d_doubles = Dict{String, Int}()
for d in @pipe zip(polymer_template, polymer_template[2:end]) .|> prod(_)
    haskey(d_doubles, d) ? (d_doubles[d] += 1) : (d_doubles[d] = 1)
end
doubles = Accumulator(d_doubles)

d_chars = Dict{Char, Int}()
for c in @pipe split(polymer_template, "") .|> _[1]
    haskey(d_chars, c) ? (d_chars[c] += 1) : (d_chars[c] = 1)
end
chars = Accumulator(d_chars)


#=
The difference with the previous naive approach is that instead of explictly generating the 
polymer string, we actually only need to know:
- what kind of doubles exist now and how many of them are there, as is "XY" => N pairs
- what new characters it creates, by usage of the rules "XY" => Z
- generate new doubles from this, and add N to the number of doubles, "XY" => "XZ", "ZY"
- remove previous doubles, doubles["XY] -= N
regarding characters: you count them at the beginning and only count the newly generated
characters chars["Z"] += N
=#
# loop a number of times = polymerisation steps
for i in 1:40
    # loop over all doubles
    for (k, v) in counter(doubles)
        new_char = rules[k]
        # remove doubles that are reacted away
        inc!(doubles, k, -v)
        # count newly generated doubles
        inc!(doubles, k[1]*new_char, v)
        inc!(doubles, new_char*k[2], v)
        # add to number of characters
        inc!(chars, new_char, v)
    end
    i == 10 && ("solution 1", @show maximum(values(chars)) - minimum(values(chars)))
    i == 40 && ("solution 2", @show maximum(values(chars)) - minimum(values(chars)))
end
