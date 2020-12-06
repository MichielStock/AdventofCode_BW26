function readin(file)
    a = split(read(file, String), "\n\n")
    data = Dict{String, String}[]
    for i in a
        pp = Dict{String, String}()
        for j in split(i, r" |\n")
            tmp = split(j, ":")
            if length(tmp) == 2
                pp[tmp[1]] = tmp[2]
            end
        end
        push!(data, pp)
    end
    return data
end

function part1(i)
    if issubset(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"], keys(i))
        return true
    end
    return false
end

function part2(i)
    if part1(i)
        if (parse(Int, i["byr"]) < 1920 || parse(Int, i["byr"]) > 2002)
            return false
        end
        if (parse(Int, i["iyr"]) < 2010 || parse(Int, i["iyr"]) > 2020)
            return false
        end
        if (parse(Int, i["eyr"]) < 2020 || parse(Int, i["eyr"]) > 2030)
            return false
        end
        if occursin("in", i["hgt"])
            if (parse(Int, i["hgt"][1:end-2]) < 59 || parse(Int, i["hgt"][1:end-2]) > 76)
                return false
            end
        elseif occursin("cm", i["hgt"])
            if (parse(Int, i["hgt"][1:end-2]) < 150 || parse(Int, i["hgt"][1:end-2]) > 193)
                return false
            end
        else
            return false
        end
        if (match(r"#([0-9]|[a-f]){6}", i["hcl"]) == nothing)
            return false
        end
        if !(i["ecl"] in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
            return false
        end
        if (match(r"[0-9]{9}", i["pid"]) == nothing || length(i["pid"]) > 9)
            return false
        end
        return true
    end
    return false
end

function valid_counts(data, f)
    c = []
    for i in data
        push!(c, f(i))
    end
    return sum(c)
end

data = readin("data/4_passport_processing/inputST.txt")
println(valid_counts(data, part1))
println(valid_counts(data, part2))