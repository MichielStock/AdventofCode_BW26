#=
Created on 08/12/2021 10:23:56
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

What time is it right now?
=#

segments = Dict(
    0 => [:a, :c, :f, :g, :e, :b],
    1 => [:c, :f],
    2 => [:a, :c, :d, :e, :g],
    3 => [:a, :c, :d, :f, :g],
    4 => [:b, :c, :d, :f],
    5 => [:a, :b, :d, :f, :g],
    6 => [:a, :b, :d, :e, :f, :g],
    7 => [:a, :c, :f],
    8 => [:a, :b, :c, :d, :e, :f, :g],
    9 => [:a, :b, :c, :d, :f, :g]
)
segments = Dict(i=>Set(repr) for (i, repr) in segments)

parts = union(values(segments)...) |> Set
lengths = Dict(i=>length(repr) for (i, repr) in segments)
length_hist = [count(isequal(i), values(lengths)) for i in 1:7]
unique_nums = filter(i->length_hist[lengths[i]]==1, 0:9)
const length_unique = Dict(lengths[i] =>i for i in unique_nums)

intersections = [length(intersect(segments[i], segments[j])) for i in 0:9, j in 0:9]
setdiffs = [length(setdiff(segments[i], segments[j])) for i in 0:9, j in 0:9]

readings = split(rstrip(read("data/8/input.txt", String)), "\n") .|> l->split.(split(l, " | "), ' ')

#codes = split("fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf", " ") .|> (l -> Symbol.(split(l,""))) .|> Set


function decode(codes)
    decoding = Dict(length_unique[length(c)]=>c for c in codes if length(c) ∈ keys(length_unique))
    numbers = Int[]
    for c in codes
        if length(c) ∈ keys(length_unique)
            push!(numbers, length_unique[length(c)])
        elseif length(c) == 5
            # 2, 3, 5
            if issubset(decoding[1], c)
                decoding[3] = c
                push!(numbers, 3)
                continue
            elseif issubset(setdiff(decoding[4], decoding[1]), c)
                decoding[5] = c
                push!(numbers, 5)
                continue
            else
                decoding[2] = c
                push!(numbers, 2)
            end
        elseif (length(c)) == 6
            # 6 9 or 0
            if !issubset(decoding[1], c)
                decoding[6] = c
                push!(numbers,6)
            elseif issubset(decoding[4], c)
                decoding[9] = c
                push!(numbers, 9)
            else
                decoding[0] = c
                push!(numbers, 0)
            end
        end
    end
    return numbers

end


solution1 = count.(r->length(r) ∈ [2, 4, 3, 7], last.(readings)) |> sum

function decode_and_add_outputs(readings)
    total = 0
    for r in readings
        n_outputs = length(last(r))
        decoded = decode(vcat(r[1], r[2]))
        output = decoded[end-n_outputs+1:end]
        total += output[1] * 1000 + output[2] * 100 + output[3] * 10 + output[4]
    end
    return total
end

solution2 = decode_and_add_outputs(readings)

