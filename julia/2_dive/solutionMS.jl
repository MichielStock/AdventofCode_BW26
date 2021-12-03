#=
Created on 02/12/2021 09:42:48
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Where are we?
=#

toy_input = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

towords(s) = split(s, " ")
parseint(s) = parse(Int, s)
mapdir(dir) = dir=="forward" ? (1, 0) : (dir=="up" ? (0, -1) : (0, 1))

instructions_toy = split(rstrip(toy_input), "\n") .|> towords .|> Tuple
instructions = split(rstrip(read("data/2/input.txt", String)), "\n") .|> towords .|> Tuple

# ----- QUESTION 1 ----- #

function compute_location(instructions)
    
    loc = (0, 0)
    for (dir, incr) in instructions
        loc = loc .+ mapdir(dir) .* parseint(incr)
    end
    return loc
end



#compute_location(instructions_toy)

solution1 = ≈ |> prod


# ----- QUESTION 2 ----- #

function compute_location2(instructions)
    loc = (0, 0, 0)
    for (dir, incr) in instructions
        if dir == "down"
            loc = loc .+ (0, 0, parseint(incr))
        elseif dir == "up"
            loc = loc .- (0, 0, parseint(incr))
        elseif dir == "forward"
            aim = loc[3]
            loc = loc .+ (parseint(incr), parseint(incr) * aim, 0)
        end
    end
    return loc
end

compute_location2(instructions_toy)

postion2 = compute_location2(instructions)

solution2 = postion2[1] * postion2[2]