data = split(rstrip(read("data/7_handy_haversacks/inputST.txt", String)), "\n")

valid_bags = ["shiny gold bag"]
l = 0
while length(valid_bags) != l
    l = length(valid_bags)
    for i in data
        to_add = []
        for j in valid_bags
            if occursin(j, i)
                m = match(r"\w+ \w+ bags contain", i)
                push!(to_add, m.match[1:end-9])
            end
        end
        union!(valid_bags, to_add)
    end
end
println(length(valid_bags)-1)

function get_bags(data) 
    next_bags = ["shiny gold bag"]
    bags_within_bags = Dict{String, Vector{Tuple}}()
    crit = 0
    while crit == 0
        new_bags = []
        for i in data
            for j in next_bags
                re = string(j, "s contain")
                if occursin(re, i)
                    to_add = []
                    for k in eachmatch(r"(?P<n>\d+) (?P<bag>\w+ \w+ bag)", i)
                        push!(new_bags, k[:bag])
                        push!(to_add, (k[:bag], k[:n]))
                    end
                    push!(bags_within_bags, j => to_add)
                end
            end
        end
        if length(new_bags) == 0
            crit = 1
        end
        next_bags = new_bags
    end
    return bags_within_bags
end

function get_bags(data) 
    next_bags = ["shiny gold bag"]
    bags_within_bags = Dict{String, Vector{Tuple}}()
    while length(next_bags) != 0
        new_bags = []
        for i in data
            for j in next_bags
                re = string(j, "s contain")
                if occursin(re, i)
                    to_add = []
                    for k in eachmatch(r"(?P<n>\d+) (?P<bag>\w+ \w+ bag)", i)
                        push!(new_bags, k[:bag])
                        push!(to_add, (k[:bag], parse(Int, k[:n])))
                    end
                    push!(bags_within_bags, j => to_add)
                end
            end
        end
        next_bags = new_bags
    end
    return bags_within_bags
end

bags = get_bags(data)
next_bags = copy(bags["shiny gold bag"])
tot = 0
while length(next_bags) != 0
    bag, n = pop!(next_bags)
    tot += n
    for (nb, nn) in bags[bag]
        push!(next_bags, (nb, n * nn))
    end
end
println(tot)