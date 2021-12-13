# --- Day 5: Hydrothermal Venture --- #
#       Author: Bram De Jaegher       #
# --- --------------------------- --- #

abstract type Line end

mutable struct HLine <: Line
    X₁::Int
    X₂::Int
    Y₁::Int
    Y₂::Int
    HLine(X₁::Int, X₂::Int, Y₁::Int, Y₂::Int) = new(X₁ + 1, X₂ + 1, Y₁ + 1, Y₂ + 1) 
end

mutable struct VLine <: Line
    X₁::Int
    X₂::Int
    Y₁::Int
    Y₂::Int    
    VLine(X₁::Int, X₂::Int, Y₁::Int, Y₂::Int) = new(X₁ + 1, X₂ + 1, Y₁ + 1, Y₂ + 1) 
end

mutable struct DLine <: Line
    X₁::Int
    X₂::Int
    Y₁::Int
    Y₂::Int  
		dir::Tuple{Int,Int}
    DLine(X₁::Int, X₂::Int, Y₁::Int, Y₂::Int) = new(X₁ + 1, X₂ + 1, Y₁ + 1, Y₂ + 1, sign.((X₂-X₁, Y₂-Y₁))) 
end

maxX(l::Line) = max(l.X₁, l.X₂)+1 
maxY(l::Line) = max(l.Y₁, l.Y₂)+1
boundingbox(lines::Vector{Line}) =  maximum([maxX(line) for line in lines]), maximum([maxY(line) for line in lines])

draw!(line::HLine,grid) = grid[line.Y₁, min(line.X₁,line.X₂):max(line.X₁,line.X₂)] .+= 1 
draw!(line::VLine,grid) = grid[min(line.Y₁,line.Y₂):max(line.Y₁,line.Y₂), line.X₁] .+= 1 

function draw!(line::DLine,grid)
	for (i,j) in zip(line.Y₁:line.dir[2]:line.Y₂, line.X₁:line.dir[1]:line.X₂) 
		grid[i,j] += 1
	end 
end

function read_lines(str) 
    rawlines = split(str,"\n") .|> (x -> split(x, " -> "))
    lines = Line[]

    for line in rawlines
        X₁, Y₁, X₂, Y₂  =  (parse.(Int,split(line[1], ","))..., parse.(Int,split(line[2], ","))...)
        
        if X₁ == X₂ 
            push!(lines,VLine(X₁, X₂, Y₁, Y₂))
        elseif Y₁ == Y₂ 
            push!(lines,HLine(X₁, X₂, Y₁, Y₂))
        else
            push!(lines,DLine(X₁, X₂, Y₁, Y₂))
        end
    end
    return lines
end

example = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""
    
# --- Part 2 --- #
# Test input
lines_test = read_lines(example)
bbox = boundingbox(lines_test)
grid = zeros(bbox...)

grid

for line in lines_test
	draw!(line, grid)
end

grid

count(x -> x > 1, grid) 


# Full input
lines_full = read("./data/5_hydrothermal_venture/input.txt", String) |> read_lines
bbox = boundingbox(lines_full)
grid = zeros(bbox...)

for line in lines_full
    draw!(line, grid)
end

count(x -> x > 1, grid) 
