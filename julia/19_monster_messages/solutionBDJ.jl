#=
Author: Bram De Jaegher
AoC: day 19

"Help, we found a monster!"
=#

abstract type Rule end

struct RuleAnd <: Rule
  r::Array{String}
end

struct RuleOr <: Rule
  r₁::Array{String}
  r₂::Array{String}
end

struct RuleEnd <: Rule
  r::Char
end

function eval!(s::String, start_rule::String, rDict::Dict)
  valid, L = eval!(s::String, rDict[start_rule], rDict, 0)
  return valid && L==length(s)
end

function eval!(s::String, rule::RuleOr, rDict::Dict, L::Int) 
  v₁, L₁ = eval!(s::String, RuleAnd(rule.r₁), rDict, L)
  v₂, L₂ = eval!(s::String, RuleAnd(rule.r₂), rDict, L)
  return v₁|v₂, L₁
end

function eval!(s::String, rule::RuleAnd, rDict::Dict, L::Int) 
  Lₒ = L
  valid = true
  for sub_rule in rule.r
    vᵢ, Lₒ = eval!(s::String, rDict[sub_rule], rDict, Lₒ)
    valid = valid && vᵢ
  end
  return valid, Lₒ
end

function eval!(s::String, rule::RuleEnd, rDict::Dict, L::Int)
  Lₒ = L + 1
  if Lₒ > length(s)
    return false, Lₒ
  end
  valid = (s[Lₒ] == rule.r)
  return valid, Lₒ
end


function parse_rules(s::String)
  rules = Dict{String, Rule}()
  lines = split(chomp(s),"\n")
  for line in lines
    (key, value) = split(line,": ")
    if value == "\"a\"" 
      rules[key] = RuleEnd('a')
    elseif value == "\"b\"" 
      rules[key] = RuleEnd('b')
    elseif occursin("|", value)
      sRules = replace(string(value), "| " => "") |> split |> s -> string.(s)
      rules[key] = RuleOr(sRules[1:end÷2],sRules[end÷2+1:end])
    else
      sRules = replace(string(value), "| " => "") |> split |> s -> string.(s)
      rules[key] = RuleAnd(sRules)
    end
  end
  return rules
end

function part2(input)
  M_valids = 0
  for line in input
    N_lineparts = length(line) ÷ 8
    c_31 = 0
    c_42 = 0
    N = 1 
  
    while N<=N_lineparts && eval!(line[end-N*8+1:end-(N-1)*8], "31", rulesDict2)
      N += 1
      c_31 += 1
    end
  
    while N<=N_lineparts && eval!(line[end-N*8+1:end-(N-1)*8], "42", rulesDict2) 
      N += 1
      c_42 += 1
    end
  
    if (N-1 == N_lineparts) && (c_42 >= (c_31 + 1)) && c_31 > 0
      M_valids += 1
    end
  end
    return M_valids
  end

rules, input2 = read("data/19_monster_messages/input.txt", String) |> s-> split(s,"\n\n")
rulesDict2 = rules |> string |> parse_rules
input = split(input2) |> s -> string.(s)

# Part 1
sum(eval!.(input, "0", Ref(rulesDict2)))

# Part 2
part2(input)
