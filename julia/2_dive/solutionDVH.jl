#=
author: Daan Van Hauwermeiren
AoC: day 2
=#

abstract type Submarine end

mutable struct Submarine_v1 <: Submarine 
    horizontal::Int
    vertical::Int
    Submarine_v1() = new(0,0)
end

function forward(b::Submarine_v1, val)
    b.horizontal += val
end
function down(b::Submarine_v1, val)
    b.vertical += val
end
function up(b::Submarine_v1, val)
    b.vertical -= val
end


mutable struct Submarine_v2 <: Submarine 
    horizontal::Int
    vertical::Int
    aim::Int
    Submarine_v2() = new(0,0,0)
end
function forward(b::Submarine_v2, val)
    b.horizontal += val
    b.vertical += b.aim*val
end
function down(b::Submarine_v2, val)
    b.aim += val
end
function up(b::Submarine_v2, val)
    b.aim -= val
end

#dasboot = Submarine_v1()
#forward(dasboot, 2)

function parse_entry(b::T, e) where T<:Submarine
    # forward down or up
    operation = getfield(Main, Symbol(e[1]))
    val = parse(Int, e[2])
    operation(b, val)
end

function parse_data!(b::T, data) where T <: Submarine
    for e in eachcol(data)
        parse_entry(b, e)
    end
end

#parse_entry(dasboot, ["forward", "10"])

# convert raw file in 2xN matrix of dtype String
parse_input(s) = hcat(split.(split(rstrip(raw), "\n"), " ")...)
raw = read("input_day2", String)
data = parse_input(raw)

dasboot = Submarine_v1()
parse_data!(dasboot, data)
solution_1 = dasboot.horizontal * dasboot.vertical

dasistaucheinboot = Submarine_v2()
parse_data!(dasistaucheinboot, data)
solution_2 = dasistaucheinboot.horizontal * dasistaucheinboot.vertical
