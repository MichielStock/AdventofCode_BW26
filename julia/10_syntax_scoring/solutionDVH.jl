#=
author: Daan Van Hauwermeiren
AoC: day 10
=#
using Pkg
Pkg.activate(".")
using Pipe

fn = "./input_day10"

# read each line as a string
data = @pipe read(fn, String) |> strip(_) |> split(_, "\n")

"""
start from a vector of strings,
for each string in the vector, remove the matching brackets: "()", "[]", "{}", "<>"
Loop multiple times over the string to remove them all
return a vector of processed strings with the matching brackets removed
"""
function remove_matching_symbols(data::Vector{T})::Vector{T} where T <: AbstractString
    processed = similar(data)
    for (i, a) in enumerate(data)
        # maximum number of iterations is length/2 because that would be perfectly matched
        for _ in 1:length(a)÷2
            for k in ["()", "[]", "{}", "<>"]
                a = replace(a, k=>"")
            end
        end
        processed[i] = a
    end
    return processed
end


processed = remove_matching_symbols(data)

#=
build using https://regex101.com/
it matches three things:
1. things like [), faulty closed parenthesis
2. or ending with [
3. or starting with )
* or similar characters
=#
# rgx = r"[\[|\{|\(|\<][\]|\}|\)|\>]|[\[|\{|\(|\<]\Z|\A[\]|\}|\)|\>]"
# simplified, just checking bad closings
rgx_badclosing = r"[\[|\{|\(|\<][\]|\}|\)|\>]"

points = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
)

# for each string, match regex = find bad closings, get the match and find what character is the wrong 
# one and score, finally sum over all points
solution_1 = @pipe processed .|> match(rgx_badclosing, _) |> filter(x -> x != nothing, _) |> [points[i.match[2]] for i in _] |> sum

@pipe processed .|> match(rgx_badclosing, _) |> filter(x -> .!isnothing(x), _) |> [points[i.match[2]] for i in _] |> sum


# for each string, find incomplete strings
incomplete = processed[@pipe processed .|> match(rgx_badclosing, _) .|> isnothing(_)]

# points for question 2, using the matching character because this is easier
points = Dict(    
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4,
)
function score_string(a::T, points::Dict{Char, Int})::Int where T <: AbstractString
    # init score
    score = 0
    # loop over all characters in reverse
    for char in reverse(a)
        score *= 5
        score += points[char]
    end
    return score
end

# score all strings, sort them and take the median (always uneven Vector length incomplete, so easy)
solution_2 = sort(@pipe incomplete .|> score_string(_, points))[length(incomplete) ÷ 2 + 1]

