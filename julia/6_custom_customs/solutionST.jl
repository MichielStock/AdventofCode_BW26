c = 0
for i in split(read("data/6_custom_customs/inputST.txt", String), "\n\n")
    group = Vector{Char}()
    for j in split(i, "\n")
        append!(group, j)
    end
    c += length(unique(group))
end
println(c)

c = 0
for i in split(read("data/6_custom_customs/inputST.txt", String), "\n\n")
    group = split(rstrip(i), "\n")
    tmp = group[1]
    for i in 1:length(group)
        tmp = intersect(tmp, group[i])
    end
    c += length(tmp)
end
println(c)