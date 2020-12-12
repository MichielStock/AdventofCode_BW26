#=
Author: Michiel Stock
AoC: day 12

Steer a boat.
=#


input = """
F10
N3
F7
R90
F11
"""
splitn = x -> split(x, "\n")
splitinstr = x -> (x[1], parse(Int, x[2:end]))
parse_input(input) = input |> rstrip |> splitn .|> splitinstr

mutable struct Boat{T<:Number}
    x::T
    y::T
    dir::T
end

Boat() = Boat(0,0,0)

coords(boat) = boat.x, boat.y

north!(boat, val) = (boat.y += val)
south!(boat, val) = (boat.y -= val)
east!(boat, val) = (boat.x += val)
west!(boat, val) = (boat.x -= val)
left!(boat, val) = (boat.dir += val)
right!(boat, val) = (boat.dir -= val)
function forward!(boat::Boat{Int}, val)
    θ = boat.dir / 180 * π
    boat.x += convert(Int, val * round(cos(θ)))
    boat.y += convert(Int, val * round(sin(θ)))
end
manhattan(boat) = abs(boat.x) + abs(boat.y)

function move!(boat, instructions)
    for (instr, val) in instructions
        instr == 'N' && north!(boat, val)
        instr == 'S' && south!(boat, val)
        instr == 'E' && east!(boat, val)
        instr == 'W' && west!(boat, val)
        instr == 'L' && left!(boat, val)
        instr == 'R' && right!(boat, val)
        instr == 'F' && forward!(boat, val)
    end
end


function rotate!(waypoint, boat, val)
    x₀, y₀ = coords(boat)
    x, y = coords(waypoint)
    d = sqrt((x)^2 + (y)^2)
    θ = atan(y, x)
    dθ = val / 180 * π
    waypoint.x = round(d * cos(θ + dθ))
    waypoint.y = round(d * sin(θ + dθ))
end

function movetowaypoint(boat, waypoint, val)
    boat.x += val * waypoint.x
    boat.y += val * waypoint.y
end

function move!(boat, waypoint, instructions)
    for (instr, val) in instructions
        instr == 'N' && north!(waypoint, val)
        instr == 'S' && south!(waypoint, val)
        instr == 'E' && east!(waypoint, val)
        instr == 'W' && west!(waypoint, val)
        instr == 'L' && rotate!(waypoint, boat, val)
        instr == 'R' && rotate!(waypoint, boat, -val)
        instr == 'F' && movetowaypoint(boat, waypoint, val)
    end
end

input = read("data/12_rain_risk/input.txt", String)
instructions = parse_input(input)
boat = Boat()
move!(boat, instructions)

dist_origin1 = manhattan(boat)

boat2 = Boat()
waypoint = Boat(10, 1, 0)
move!(boat2, waypoint, instructions)
dist_orgin2 = manhattan(boat2)
