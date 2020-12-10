#=
Author: Michiel Stock
AoC: day 7

Find the number of bags.
=#

#=
example1 = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""

example2 = """
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
"""
=#

input = read("data/7_handy_haversacks/input.txt", String)

statements = split(rstrip(input), "\n")

function parse_statments(statements)
    TC = Tuple{Int,String}
    contains = Dict{String,Set{TC}}()
    re_color = r"(\w+\s\w+) bags contain (.+)\."
    re_content = r"(\d)\s(\w+\s\w+)\sbag"
    for statement in statements
        m = match(re_color, statement)
        color, statement_content = m[1], m[2]
        cont = Set{TC}()
        for cm in eachmatch(re_content, statement_content)
            push!(cont, (parse(Int, cm[1]), cm[2]))
        end
        contains[color] = cont
    end
    return contains
end

contains = parse_statments(statements)

function recursive_contents(contains)
    contents = Dict(col => Set(last.(cont)) for (col, cont) in contains)
    changed = true
    for i in 1:length(contains)  # I can find stopping rules if I want to
        changed = false
        for (col, cont) in contents
            for c in cont
                if !issubset(cont, contents[c])
                    union!(cont, contents[c])
                    changed = true
                end
            end
        end
        !changed && break
    end
    return contents
end

function bags_required(contains, color)
    needed = copy(contains[color])
    n_bags = 0
    while !isempty(needed)
        n, col = pop!(needed)
        n_bags += n
        for (n_ss, col_ss) in contains[col]
            push!(needed, (n * n_ss, col_ss))
        end
    end
    return n_bags
end


contents = recursive_contents(contains)

n_bags_shiny_gold = count(v->"shiny gold" ∈ v, values(contents))

n_bags_needed = bags_required(contains, "shiny gold")
