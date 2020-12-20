#=
Author: Michiel Stock
AoC: day 20

Solve a jilsaw puzzle
=#

input = 
"""
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
"""

flip(piece) = @view piece[:,size(piece, 1):-1:1]
allconform(piece) = (f(piece) for f in [identity, rotr90, rot180, rotl90,
                                        flip, rotr90 ∘ flip, rot180 ∘ flip, rotl90 ∘ flip])

function parse_input(input)
    pieces_str = split(rstrip(input), "\n\n")
    pieces = Dict{Int,Matrix{Bool}}()
    for piece in pieces_str
        id = parse(Int, match(r"(\d+)", piece)[1])
        p = hcat([replace(split(line, ""), "#"=>true, "."=>false) for line in split(piece, "\n")[2:end]]...)
        pieces[id] = p
    end
    return pieces
end

get_corners(piece) = piece[1,:], piece[:,end], reverse!(piece[end,:]), reverse!(piece[:,1]),  # normal
                        reverse!(piece[1,:]), reverse!(piece[:,end]), piece[end,:], piece[:,1]  # flipped
get_hashed_corners(piece) = get_corners(piece) .|> hash

function connecting(pieces)
    corners = Dict(id=> get_hashed_corners(piece) for (id, piece) in pieces)
    connected = Dict(id => [id2 for (id2, c2) in corners
                        if id!=id2 && !isempty(intersect(c, c2))]
                        for (id, c) in corners)

    return connected
end

function get_outline(pieces, connected)
    # number tiles
    n = length(pieces)
    # number of sizes tiles
    l = n |> sqrt |> Int
    outline = zeros(Int, l, l)
    # add corner piece
    outline[1,1] = findfirst(x->length(x) == 2, connected)
    to_use = Set(keys(pieces))
    delete!(to_use, outline[1,1])
    for i in 2:l
        for id in to_use
            if length(connected[id]) < 4 && outline[i-1,1] ∈ connected[id]
                outline[i,1] = id
                delete!(to_use, id)
                break
            end
        end
    end
    for i in 2:l
        for id in to_use
            if length(connected[id]) < 4 && outline[1,i-1] ∈ connected[id]
                outline[1,i] = id
                delete!(to_use, id)
                break
            end
        end
    end
    for i in 2:l, j in 2:l
        for id in to_use
            if outline[i-1,j] ∈ connected[id] && outline[i,j-1] ∈ connected[id]
                outline[i,j] = id
                delete!(to_use, id)
                break
            end
        end
    end
    return outline
end

function get_image(pieces, connected)
    outline = get_outline(pieces, connected)
    images = 0 #TODO: complete me
end






#input = read("data/20_Jurassic_jigsaw/input.txt", String)
pieces = parse_input(input)

connected = connecting(pieces)

# product of ids at corners
# i.e., just two connecting pieces
sol1 = reduce(*, filter(id->length(connected[id])==2, keys(connected)))