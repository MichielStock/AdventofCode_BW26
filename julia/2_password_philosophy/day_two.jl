using DelimitedFiles
using StatsBase

function check_number(key, pw, l, u)
    m = countmap([x for x in pw])
    num = 0
    if haskey(m, key)
        num = m[key]
    end
    if (l ≤ num ≤ u)
        return true
    end
    return false
end

function check_index(key, pw, p1, p2)
    l = length(pw)
    if (l < p1 || l < p2)
        return false
    end
    if sum([pw[p1] == key, pw[p2] == key]) == 1
        return true
    end
    return false
end

function count_correct(data, f)
    c = 0
    for i in 1:size(data)[1]
        key = data[i, 2][1]
        m = findall(r"\d+", data[i, 1])
        l = parse(Int, data[i, 1][m[1]])
        u = parse(Int, data[i, 1][m[2]])
        c += f(key, data[i, 3], l, u)
    end 
    return c
end

data = readdlm("data/2_password_philosophy/input_day2.txt", String)
# 1
count_correct(data, check_number)
# 2
count_correct(data, check_index)