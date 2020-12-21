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
    n, m = size(outline)
    images = [pieces[outline[i,j]] for i in 1:n, j in 1:m]
    # put top corner piece right
    sec_corners = get_hashed_corners(images[2,1])
    for piece in allconform(first(images))
        if hash(piece[end,:]) in sec_corners
            images[1,1] = piece
            break
        end
    end
    # now the first line
    for i in 2:n
        corner = (images[i-1,1][end,:])
        for piece in allconform(images[i,1])
            if corner == piece[1,:]
                images[i,1] = piece
                break
            end
        end
    end
    # now, all the rest
    for i in 1:n
        for j in 2:n
            corner = (images[i,j-1][:,end])
            for piece in allconform(images[i,j])
                if corner == piece[:,1]
                    images[i,j] = piece
                    break
                end
            end
        end
    end
    # return final image without border
    pixels_piece = (size(images[1], 1) - 2)
    n_pixels = n * pixels_piece
    image = zeros(Bool, n_pixels, n_pixels)
    for (i, p) in zip(1:n, 1:pixels_piece:n_pixels)
        for (j, q) in zip(1:n, 1:pixels_piece:n_pixels)
            image[p:p+pixels_piece-1, q:q+pixels_piece-1] .= images[i,j][2:end-1,2:end-1]
        end
    end
    return image
end



seamonster = """
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
"""

 function parse_seamonster(seamonster)
    seamonster = split(rstrip(seamonster), "\n")
    n, m = length(seamonster), maximum(length.(seamonster))
    B = zeros(Bool, n, m)
    for (i, l) in enumerate(seamonster)
        for (j, c) in enumerate(l)
            c == '#' && (B[i,j] = true)
        end
    end
    return B
end


seamonster = parse_seamonster(seamonster)

function detectobjects(image, seamonster)
    n, m = size(image)
    p, q = size(seamonster)
    n_seamonsters = 0
    C = CartesianIndices(image)
    Q = CartesianIndices(seamonster) |> last
    
    I1, Ilast = first(C), last(C)
    for conformation in allconform(image)
        for I in I1:(Ilast-Q)
            if all(conformation[I:I+Q-I1][seamonster])
                n_seamonsters += 1
            end
        end
    end
    return n_seamonsters
end




input = read("data/20_Jurassic_jigsaw/input.txt", String)
pieces = parse_input(input)

connected = connecting(pieces)

# product of ids at corners
# i.e., just two connecting pieces
sol1 = reduce(*, filter(id->length(connected[id])==2, keys(connected)))

image = get_image(pieces, connected)
n_seamonsters = detectobjects(image, seamonster)
sol2 = sum(image) - n_seamonsters * sum(seamonster)
