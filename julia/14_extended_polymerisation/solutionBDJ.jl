# --- Day 14: Extended Polymerisation --- #
#     author: Bram De Jaegher             #
# --- ------------------------------- --- #

function parse_input(str)
  lines = split(str,"\n")
  chain = lines[1] |> collect
  polymer = Dict{String,Int}()
  rules = Dict{String,Tuple}()
  elements = Set{Char}()
  
  for i in 1:length(chain)-1 
    pair = chain[i]*chain[i+1]
    if !haskey(polymer, pair)
      polymer[pair] = 1
    else
      polymer[pair] += 1
    end
  end

  for line in lines[3:end]
    pair = split(line," -> ")[1] |> collect
    elements = union(elements, Set(pair))
    insertion = split(line," -> ")[2] |> only
    result = (pair[1]*insertion, insertion*pair[2], insertion)
    rules[prod(pair)] = result
  end
  return polymer, rules, Dict([el => count(x -> x .== el, chain) for el in elements])
end

function step!(polymer, rules, tracker)
  new_polymer = copy(polymer)
  for (pair,num_of_insertions) in polymer
    if haskey(rules, pair) && (num_of_insertions > 0)
      new_pairs = rules[pair][1:2]
      println(pair)
      println(new_pairs)
      insertion = rules[pair][end]
      tracker[insertion] += num_of_insertions
      new_polymer[pair] -= num_of_insertions 
      
      for new_pair in new_pairs
        if haskey(new_polymer, new_pair)
          new_polymer[new_pair] += num_of_insertions
        else
          new_polymer[new_pair] = num_of_insertions
        end
      end
    end
  end 
  polymer = copy(new_polymer) 
  return polymer, tracker
end

function step!(polymer, rules, tracker, N)
  for i in 1:N
    polymer, tracker = step!(polymer, rules, tracker)
  end
  return polymer,tracker
end


example= """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"""


# --- Part 1 --- #
# Test
polymer, rules, tracker = parse_input(example)
polymer, tracker = step!(polymer, rules, tracker, 10)
values(tracker) |> collect |> sort |> x->x[end]-x[1]

# Full
raw_input = read("./data/14_extended_polymerisation/input.txt", String) 
polymer, rules, tracker = parse_input(raw_input)
polymer, tracker = step!(polymer, rules, tracker, 10)
values(tracker) |> collect |> sort |> x->x[end]-x[1]


# --- Part 2 --- #
# Test
polymer, rules, tracker = parse_input(example)
polymer, tracker = step!(polymer, rules, tracker, 40)
values(tracker) |> collect |> sort |> x->x[end]-x[1]

# Full
raw_input = read("./data/14_extended_polymerisation/input.txt", String) 
polymer, rules, tracker = parse_input(raw_input)
polymer, tracker = step!(polymer, rules, tracker, 40)
values(tracker) |> collect |> sort |> x->x[end]-x[1]


