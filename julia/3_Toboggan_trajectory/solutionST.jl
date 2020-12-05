using DelimitedFiles

function trees(data, r, d)
    c = 0
    x = 1
    rep = length(data[1])
    for y in 1:d:length(data)
        if data[y][x] == '#'
            c += 1
        end
    
        if x+r > rep
            x = (x+r)-rep
        else
            x += r
        end
    end
    return c
end

function check(data, trajs)
    encountered = []
    for i in trajs
        push!(encountered, trees(data, i[1], i[2]))
    end
    return prod(encountered)
end

println(trees(data, 3, 1))
println(check(data, [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]))