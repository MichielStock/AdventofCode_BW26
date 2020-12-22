#=
Author: Bram De Jaegher
AoC: day 22

Shouldn't we play rock paper scissors?
=#

function play_round!(p₁, p₂)
  c₁ = popfirst!(p₁)
  c₂ = popfirst!(p₂)

  if c₁ > c₂
    push!(p₁, c₁, c₂)
  else
    push!(p₂, c₂, c₁)
  end
end

function play!(p₁, p₂)
  while !isempty(p₁) && !isempty(p₂)
    play_round!(p₁, p₂)
  end
  if isempty(p₁)
    return p₂
  else
    return p₁
  end
end

score(p) = sum([pᵢ*(length(p)+1-i) for (i, pᵢ) in enumerate(p)])

p₁ = [9, 2, 6, 3, 1]
p₂ = [5, 8, 4, 7, 10]
pw = play!(p₁, p₂)
score(pw)

P₁=[40,28,39,7,6,16,1,27,38,8,15,3,26,9,30,5,50,17,20,45,34,10,21,14,43]
P₂=[4,49,35,11,32,12,48,23,47,22,46,13,18,41,24,36,37,44,19,42,33,25,2,29,31]
Pw = play!(P₁, P₂)
score(Pw)

# part 2
function generate_id(p₁, p₂)
  reduce(*, [string(el)*"," for el in p₁]) *";"*
   reduce(*, [string(el)*"," for el in p₂])
end

function play_recursive!(p₁, p₂)
  ids=Set(String[])
  while !isempty(p₁) && !isempty(p₂)
    id = generate_id(p₁, p₂)
    if id in ids
      return [p₁;p₂], []
    else
      push!(ids,id)
      p₁, p₂ = play_round_recursive!(p₁, p₂)
    end
  end
  return p₁, p₂
end

function play_round_recursive!(p₁, p₂)  
  c₁ = popfirst!(p₁)
  c₂ = popfirst!(p₂)

  if c₁ ≤ length(p₁) && c₂ ≤ length(p₂)
    p₁ᵣ, p₂ᵣ =  play_recursive!(copy(p₁[1:c₁]), copy(p₂[1:c₂]))

    if length(p₁ᵣ) > length(p₂ᵣ) 
      push!(p₁, c₁, c₂)
    else
      push!(p₂, c₂, c₁)
    end
  elseif c₁ > c₂
    push!(p₁, c₁, c₂)
  else
    push!(p₂, c₂, c₁)
  end
  return p₁, p₂
end

p₁ = [9, 2, 6, 3, 1] 
p₂ = [5, 8, 4, 7, 10]
pw = play_recursive!(p₁, p₂)
score([pw[1]; pw[2]])

p₁ = [43, 19]
p₂ = [2, 29, 14]
pw = play_recursive!(p₁, p₂)
score([pw[1]; pw[2]])

P₁=[40,28,39,7,6,16,1,27,38,8,15,3,26,9,30,5,50,17,20,45,34,10,21,14,43] 
P₂=[4,49,35,11,32,12,48,23,47,22,46,13,18,41,24,36,37,44,19,42,33,25,2,29,31]
Pw = play_recursive!(P₁, P₂)
score([Pw[1]; Pw[2]])