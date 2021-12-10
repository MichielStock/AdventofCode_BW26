#= --- Day 10: Syntax Scoring ---
        Bram De Jaegher
=#

example = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"""  

bracketpairs = Dict(
  ']' => '[', 
  ')' => '(', 
  '>' => '<', 
  '}' => '{'
)

revpairs = Dict(
  '[' => ']',  
  '(' => ')',  
  '<' => '>',  
  '{' => '}',
 ) 

is_opener(b; openers= ['[', '{', '<', '(']) = b in openers
is_closer(b; closers= [']', '}', '>', ')']) = b in closers
Base.match(opener::Char, closer::Char, bracketpairs) = bracketpairs[closer] == opener

score_table1 = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
score_table2 = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

function syntax_checker(line)
  openers = []
  chars = collect(line)
  for bracket in chars
    if is_opener(bracket)
      push!(openers, bracket)
    elseif !isempty(openers)
      opener = pop!(openers)
      if match(opener,bracket, bracketpairs)
        continue
      else
        return false, bracket
      end
    else
      return true, bracket
    end
  end
  return true, 'e'
end

function autocomplete(line)
  openers = []
  closers = []
  chars = collect(line)
  for bracket in chars
    if is_opener(bracket)
      push!(openers, bracket)
    else 
      pop!(openers)
    end
  end
  while !isempty(openers)
    opener = pop!(openers)
    push!(closers, revpairs[opener])
  end
  return closers
end


score1(l) = filter(x -> !x[1], l) .|> last .|> (x -> get(score_table1, x, 0)) |> sum

function score2(l)
  score = 0
  for bracket in l
    score *= 5 
    score += score_table2[bracket]
  end
  return score
end

# ---- Part 1 --- #
# Test data
test_input = example |> (x -> split(x,"\n"))
syntax_checker.(test_input) |> score1

# Full data
full_input =  read("./data/10_syntax_scoring/input.txt", String) |> (x -> split(x,"\n"))
syntax_checker.(full_input) |> score1

# --- Part 2 --- #
# Test data
test_incomplete = syntax_checker.(test_input) .|> first |> findall  |> x -> test_input[x]
suggestions = autocomplete.(test_incomplete) .|> score2 |> sort |> x -> x[end÷2+1]

# Full data
full_incomplete = syntax_checker.(full_input) .|> first |> findall  |> x -> full_input[x]
suggestions = autocomplete.(full_incomplete) .|> score2 |> sort |> x -> x[end÷2+1]