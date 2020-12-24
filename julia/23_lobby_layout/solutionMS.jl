#=
Author: Michiel Stock
AoC: day 24

What, no Penrose tiling?
=#

directions = ["e", "se", "sw", "w", "nw", "ne"]

splitlines = str -> split(str, "\n")

instructions = """
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
""" |> rstrip |> splitlines

instruction = "nwwswee"

function parse_instruction(instruction)
    i = 1
    pos = [0, 0]
    while i ≤ length(instruction)
        c = instruction[i]
        if c=='e'
            pos .+= [1, 0]
            i += 1
        elseif c=='w'
            pos .+= [-1, 0]
            i += 1
        else
            c2 = instruction[i+1]
            if c=='n' && c2=='w'
                pos .+= [0, 1]
            elseif c=='n' && c2=='e'
                pos .+= [1, 1]
            elseif c=='s' && c2=='e'
                pos .+= [0, -1]
            elseif c=='s' && c2=='w'
                pos .+= [-1, -1]
            end    
            i += 2
        end
    end
    return pos
end

function parse_instructions(instructions)
    black = Set{Array{Int}}()
    for instruction in instructions
        pos_tile = parse_instruction(instruction)
        if pos_tile ∈ black
            delete!(black, pos_tile)
        else
            push!(black, pos_tile)
        end
    end
    return black
end

count_neighbors(grid, (i,j)) = 
        grid[i+1, j] +  # e
        grid[i,j-1] + # se
        grid[i-1,j-1] + # sw
        grid[i-1, j] + # w
        grid[i, j+1] + # nw
        grid[i+1, j+1] # ne


function flip_tiles(black; nrounds=1)
    margin = 2nrounds + 11
    xmin, xmax = black .|> first |> extrema
    ymin, ymax = black .|> last |> extrema
    n, m = (xmax - xmin) + margin, (ymax - xmin) + margin
    offset = margin ÷ 2
    grid = zeros(Bool, n, m)
    for (i,j) in black
        grid[i + offset - xmin, j + offset - ymin] = true
    end
    new_grid = copy(grid)
    for round in 1:nrounds
        for j in 2:m-1
            for i in 2:n-1
                state = grid[i,j]
                n_neighb = count_neighbors(grid, (i,j))
                if state
                    new_grid[i,j] = !((n_neighb==0) || n_neighb > 2)
                else
                    new_grid[i,j] = n_neighb==2
                end
            end
        end
        grid, new_grid = new_grid, grid
    end
    return grid
end


instructions = read("data/24_lobby_layout/input.txt", String) |> rstrip |> splitlines

black = parse_instructions(instructions)
sol1 = length(black)

sol2 = flip_tiles(black; nrounds=100) |> sum
