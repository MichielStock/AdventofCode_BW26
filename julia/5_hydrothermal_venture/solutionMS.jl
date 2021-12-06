#=
Created on 05/12/2021 12:13:44
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Watch out for these vent!
=#

toy_input = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

pi(s) = parse(Int, s)

parse_input(input) = split(rstrip(input), "\n") .|> 
                    (l->match(r"(\d+),(\d+)\W->\W(\d+),(\d+)", l)) .|>
                    (m -> ((pi(m[1]), pi(m[2])), ((pi(m[3]), pi(m[4])))))

#vents = parse_input(toy_input)
vents = parse_input(read("data/5/input.txt", String))

get_size(vents) = maximum(c->maximum(first.(c)), vents) + 1, maximum(c->maximum(last.(c)), vents) + 1

# ---- QUESTION 1 ---- #

function make_map(vents, size)
    M = zeros(Int, size...)
    for ((x₁, y₁), (x₂, y₂)) in vents
        # only check horizontal or vertical lines
        x₁, x₂ = minmax(x₁, x₂)
        y₁, y₂ = minmax(y₁, y₂)
        if x₁ == x₂
            M[x₁+1,(y₁+1):(y₂+1)] .+= 1
        elseif y₁ == y₂
            M[(x₁+1):(x₂+1),y₁+1] .+= 1
        end
    end
    return M
end

make_map(vents) = make_map(vents, get_size(vents))

M = make_map(vents)

solution1 = count(>(1), M)


# ---- QUESTION 2 ---- #

function make_map2(vents, size=get_size(vents))
    M = zeros(Int, size...)
    for ((x₁, y₁), (x₂, y₂)) in vents
        # check horizontal or vertical lines
        if x₁ == x₂
            y₁, y₂ = minmax(y₁, y₂)
            M[x₁+1,(y₁+1):(y₂+1)] .+= 1
        elseif y₁ == y₂
            x₁, x₂ = minmax(x₁, x₂)
            M[(x₁+1):(x₂+1),y₁+1] .+= 1
        end
        if abs(x₂ - x₁) == abs(y₂ - y₁)
            for (x, y) in zip(x₁:sign(x₂ - x₁):x₂, y₁:sign(y₂ - y₁):y₂) 
                M[x+1,y+1] += 1
            end
        end
    end
    return M
end


M2 = make_map2(vents)

solution2 = count(>(1), M2)