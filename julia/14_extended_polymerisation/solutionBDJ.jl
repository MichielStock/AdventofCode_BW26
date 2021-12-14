# --- Day 14: Extended Polymerisation --- #
#     author: Bram De Jaegher             #
# --- ------------------------------- --- #

function parse_input(str)
  lines = split(str,"\n")
  chain = lines[1]
  rules = Dict([split(line," -> ")[1] => split(line," -> ")[2]|> only for line in lines[3:end]])
  return collect(chain), rules
end

function find_and_insert!(chain, rules; N=1)
  for step in 1:N
    new_chain = copy(chain)
    count = 0
    for i in 1:length(chain)-1
      if chain[i]*chain[i+1] in keys(rules)
        insert!(new_chain, i+count+1,rules[chain[i]*chain[i+1]])
        #println("Inserting $(rules[chain[i]*chain[i+1]]) at $(i+count+1)")
        #println(new_chain)
        count += 1
      end
    end
    chain = new_chain
  end
  return chain
end

function output(chain)
  histo = [sum(el .== chain) for el in unique(chain) |> collect] |> sort
  histo[end]-histo[1]
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
chain, rules = parse_input(example)
chain = find_and_insert!(chain, rules; N=10) |> output

# Full
raw_input = read("./data/14_extended_polymerisation/input.txt", String) 
chain, rules = parse_input(raw_input)
chain = find_and_insert!(chain, rules; N=10) |> output

raw_input = read("./data/14_extended_polymerisation/input.txt", String) 
chain, rules = parse_input(raw_input)
chain = find_and_insert!(chain, rules; N=40) |> output


function polymerise!(chain; max_iter = 1000)
  changed = true
  iter = 0
  while changed & (iter < max_iter)
    old_chain = copy(chain)
    chain = find_and_insert!(chain)
    changed = length(old_chain) != length(chain)
    println()
    iter += 1
    old_chain = chain
  end
  return chain
end

rules = Dict(
  "CH" => 'B',
  "HH" => 'N',
  "CB" => 'H',
  "NH" => 'C',
  "HB" => 'C',
  "HC" => 'B',
  "HN" => 'C',
  "NN" => 'C',
  "BH" => 'H',
  "NC" => 'B',
  "NB" => 'B',
  "BN" => 'B',
  "BB" => 'N',
  "BC" => 'B',
  "CC" => 'N',
  "CN" => 'C'
)