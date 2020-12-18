#=
Author: Bram De Jaegher
AoC: day 18

Do not mess with the order of operation
=#

function parse_input(s::String)
  return replace(s, "("=>"( ") |> s->replace(s, ")"=>" )") |> split
end

function shunting(s, op_prec=Dict("("=>0,"*"=>1,"+"=>1))
  outputq = []
  opstack = []

  for tok in s
      if tryparse(Int,tok) !== nothing
          push!(outputq, tok)
      elseif tok == "("
          push!(opstack, tok)
      elseif tok == ")"
          while !isempty(opstack) && (op = pop!(opstack)) != "("
             push!(outputq, op)
          end
      else 
          while !isempty(opstack)
              op = pop!(opstack)
              if op_prec[op] > op_prec[tok] ||
                 (op_prec[op] == op_prec[tok])
                  push!(outputq, op)
              else
                  push!(opstack, op)  
                  break
              end
          end
          push!(opstack, tok)
      end
  end
  while !isempty(opstack)
    op = pop!(opstack)
    push!(outputq, op)
  end
  outputq
end

function evaluate(tokens)
  stack = []
  for tok in tokens
    if tryparse(Int,tok) == nothing
      arg2 = pop!(stack)
      arg1 = pop!(stack)
      result = eval(Meta.parse("$arg1 $tok $arg2"))
      push!(stack,result)
    else
      push!(stack,tok)
    end
  end
  return pop!(stack)
end

compute(exp) = evaluate(shunting(exp))
compute(exp, op_exp) = evaluate(shunting(exp, op_exp))


line1 = "1 + 2 * 3 + 4 * 5 + 6" |> parse_input |> compute
line2 = "1 + (2 * 3) + (4 * (5 + 6))" |> parse_input |> compute
line3 = "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" |> parse_input |> compute
input = read("data/18_operation_order/input.txt",String) |> s-> String.(split(s,"\n")) |> s->[parse_input(sᵢ) for sᵢ in s]

# Part 1
sum(compute.(input))

# Part 2
sum(compute.(input, Ref(Dict("("=>0,"*"=>1,"+"=>2))))


