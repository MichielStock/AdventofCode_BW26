#=
Author: Michiel Stock
AoC: day 21

Find allergens in food
=#

input = """
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
"""

function parse_input(input)
    lines = split(rstrip(input), "\n")
    
    foods = Vector{Tuple{Set{String},Set{String}}}()
    for line in lines
        ingredients = [m[1] for m in eachmatch(r"([a-z]+) ", line)][1:end-1] .|> String |> Set
        allergens = split(match(r"\(contains (.+)\)", line)[1], ", ")  .|> String |> Set
        push!(foods, (ingredients, allergens))

    end
    ingredients = union(first.(foods)...)
    allergens = union(last.(foods)...)
    allergen_candidates = Dict(al => Set([ingredients...]) for al in allergens)
    ingr_allergens = Dict(ingr => Set([allergens...]) for ingr in ingredients)
    for (ingrs, allergs) in foods
        for al in allergs
            intersect!(allergen_candidates[al], ingrs)
        end
    end

    return ingredients, allergens, foods, allergen_candidates
end

function solve_first_question(ingredients, allergens, foods, allergen_candidates)
    ingredient_nonalergenic = setdiff(ingredients, values(allergen_candidates)...)
    return count.(ingr->ingr ∈ ingredient_nonalergenic, first.(foods)) |> sum
end

function solve_second_question(allergen_candidates)
    while maximum(length.(values(allergen_candidates))) > 1
        for (al, ingrs) in allergen_candidates
            length(ingrs) > 1 && continue
            for (al2, ingr2) in allergen_candidates
                al != al2 && length(ingr2) > 1 && (setdiff!(ingr2, ingrs))
            end
        end
    end
    all_ingr = [(al, first(ingrs)) for (al, ingrs) in allergen_candidates] |> sort!
    return join(last.(all_ingr), ",")
end




input = read("data/21_allergen_assessment/input.txt", String)

ingredients, allergens, foods, allergen_candidates = parse_input(input)
sol1 = solve_first_question(ingredients, allergens, foods, allergen_candidates)
sol2 = solve_second_question(allergen_candidates)
