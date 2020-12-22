#=
Author: Bram De Jaegher
AoC: day 21

Does this contain gluten?
=#


function all_possible_allergens(s::String) 
  a_dict = Dict{String,Set}()
  dict_ingredients = Dict{String, Int}()
  lines = split(s,"\n")
  for line in lines
    ingredients = split(line, " (")[1] |> x->string.(split(x))  
    allergens = split(replace(replace(line,","=>""), ")"=> ""),"(contains ")[2] |> x->string.(split(x))

    for ingredient in ingredients
      if haskey(dict_ingredients, ingredient)
        dict_ingredients[ingredient] += 1
      else
        dict_ingredients[ingredient] = 1
      end
    end

    for allergen in allergens
      if haskey(a_dict, allergen)
        a_dict[allergen] = intersect(a_dict[allergen], Set(ingredients))
      else
        a_dict[allergen] = Set(ingredients)
      end
    end
  end
    return union(last.(collect(a_dict))...), dict_ingredients, a_dict
end

function translate(allergens, aDict)
  translation = Dict{}()
  while length(translation) < length(allergens)
    eliminated = filter(x->length(x[2])==1, collect(aDict))
    translation[first(eliminated[1])] = collect(last(eliminated[1]))[1]
    for (key, value) in aDict
      aDict[key] = setdiff(aDict[key], intersect(aDict[key], last(eliminated[1])))
    end
  end
  return translation
end

example2 = read("data/21_allergen_Assessment/input.txt", String)
allergens, all, aDict = all_possible_allergens(example2)
allergen_free = setdiff(keys(all),allergens)

# --- Part 1 --- #
sum([all[key] for key in allergen_free])

# --- Part 2 --- #
function part2()
  translation = translate(allergens, aDict)
  sorted_translation = sort(collect(translation), by = first)
  reduce(*, last.(sorted_translation).*",")[1:end-1]
end

part2()
