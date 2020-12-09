#=
Author: Bram De Jaegher
AoC: day 9

Some people just watch a movie
=#

pairs(a::Array) = Set([el1+el2 for (i,el1) in enumerate(a) for (j,el2) in enumerate(a) if i!==j])


input = read("data/09_day9.txt", String) |> s->split(s, "\n") |> s -> [parse(Int,sᵢ) for sᵢ in s]
preamble = 25

ind_err = findfirst([!in(el, pairs(input[index:index+preamble-1])) for (index,el) in enumerate(input[preamble+1:end])])+preamble
err2 = input[ind_err]
println("Erroneous number is: $err2")

function findset(input,err)
  M = length(input)
  for N in 1:M
    for index in 1:M-N
      set = input[index:index+N]
      theSum = sum(set)
      if theSum == err
        return (minimum(set), maximum(set))
      end
    end
  end
    return (-1, -1)
end


key = sum(findset(input,err2))
println("The encryption key is: $key")

