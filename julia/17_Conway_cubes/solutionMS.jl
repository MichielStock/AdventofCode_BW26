#=
Author: Michiel Stock
AoC: day 17

Game of Life...
... in 3D!
=#

input = """
.#.
..#
###
"""

input = """
##..####
.###....
#.###.##
#....#..
...#..#.
#.#...##
..#.#.#.
.##...#.
"""


function parse_input_nd(input, dims)
    lines = split(rstrip(input), "\n")
    A = reshape([c=='#' for l in lines for c in l], :, length(lines))'
    n, m = size(A)
    X = zeros(Bool, dims...)
    dims = div.(dims, 2)
    N1, N2 = dims[1], dims[2]
    N1 -= div(n, 2)
    N2 -= div(m, 2)
    lastdims = dims[3:end]
    for j in 1:m
        for i in 1:n
            X[N1+i,N2+j,lastdims...] = A[i,j]
        end
    end
    return X
end

function update!(Xnew, X)
    fill!(Xnew, false)
    C = CartesianIndices(X)
    I1, Imax = first(C), last(C)
    for I in C
        state = X[I]
        neighbors = 0 - state
        R = max(I-I1,I1):min(I+I1,Imax)
        for In in R
            neighbors += X[In]
        end
        state && (2 ≤ neighbors ≤ 3) && (Xnew[I] = true)
        !state && neighbors == 3 && (Xnew[I] = true)
    end
    return Xnew
end

function update(X, nsteps::Int=1)
    Xnew = similar(X)
    for i in 1:nsteps
        update!(Xnew, X)
        X, Xnew = Xnew, X
    end
    return X
end


X = parse_input_nd(input, (20, 20, 20))
sol1 = update(X, 6) |> sum

X = parse_input_nd(input, (20, 20, 20, 20))
sol2 = update(X, 6) |> sum
