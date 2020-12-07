#=
Author: Michiel Stock
AoC: day 7

Find the number of bags.
=#

input = """
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

statements = split(rstrip(input), "\n")
statement = first(statements)

function parse_statments(statements)
    TC = Tuple{Int,String}
    contains = Dict{String,Vector{TC}}()
    re_color = r"(\w+\s\w+) bags contain (.+)\."
    re_content = r"(\d)\s(\w+\s\w+)\sbag"
    for statement in statements
        m = match(re_color, statement)
        color, statement_content = m[1], m[2]
        cont = TC[]
        for cm in eachmatch(re_content, statement_content)
            push!(cont, (parse(Int, cm[1]), cm[2]))
        end
        contains[color] = cont
    end
    return contains
end