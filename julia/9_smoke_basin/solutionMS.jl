#=
Created on 09/12/2021 09:05:21
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Finding lowest points
=#


H = rstrip(read("data/9/input.txt", String)) |> (s-> split(s, "\n")) .|> (l->parse.(Int, split(l,""))) |>
            H->hcat(H...)

function find_lowest_points(H)
    n, m = size(H)
    L = zeros(Bool, size(H))
    @inbounds for i in 1:n
        @inbounds for j in 1:m
            hᵢⱼ = H[i,j]
            hl = i > 1 ? H[i-1,j] : 100
            hr = i < n ? H[i+1,j] : 100
            hb = j > 1 ? H[i,j-1] : 100
            ht = j < m ? H[i,j+1] : 100
            L[i,j] = all(hᵢⱼ .< (hl, hr, ht, hb))
        end
    end
    return L
end

L = find_lowest_points(H)
solution1 = sum(H .* L) + sum(L)

function find_basins(H, L)
    n, m = size(H)
    B = zero(H)
    n_basins = sum(L)
    B[L] .= 1:n_basins
    @inbounds for _ in 1:10
        @inbounds for i in 1:n
            for j in 1:m
                H[i,j] == 9 && continue
                B[i,j] > 0 && continue
                bl = i > 1 ? B[i-1,j] : 0
                br = i < n ? B[i+1,j] : 0
                bb = j > 1 ? B[i,j-1] : 0
                bt = j < m ? B[i,j+1] : 0
                B[i,j] = max(bl, br, bt, bb)
            end
        end
    end
    return B
end

B = find_basins(H, L)

solution2 = sort!([count(isequal(i), B) for i in 1:maximum(B)], rev=true) |> v->v[1]*v[2]*v[3]

