using DelimitedFiles

function half(V, side)
    if side ∈ ['F', 'L']
        idx =  convert(Int, length(V)/2)
        return V[1:idx]
    elseif side ∈ ['B', 'R']
        idx =  convert(Int, length(V)/2)
        return V[idx+1:end]
    end
end

function find_ID(ticket)
    row = 0:127
    for i in 1:7
        row = half(row, ticket[i])
    end
    row = collect(row)[1]

    col = 0:7
    for i in 8:10
        col = half(col, ticket[i])
    end
    col =  collect(col)[1]
    return row*8 + col
end

data = readdlm("data/5_binary_boarding/inputST.txt", String)
IDs = []
for i in data
    push!(IDs, find_ID(i))
end
println(maximum(IDs))

for i in 1:(maximum(IDs)-1)
    if i ∉ IDs
        if (i-1 ∈ IDs && i+1 ∈ IDs)
            println(i)
        end
    end
end
