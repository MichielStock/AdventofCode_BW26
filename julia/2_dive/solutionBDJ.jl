#= --- Day 2: Dive ---
  author:  Bram De Jaegher
=#

split_command(line) = (split(line)[1], parse(Int, split(line)[2]))

function move!(line, posx, posy)
  statement, value = split_command(line)
  if statement == "forward"
    posx += value
  elseif statement == "up"
    posy -= value
  elseif statement == "down"
    posy += value
  end
  return posx, posy
end

function traverse(str, posx, posy)
  while length(str) > 0
    line = pop!(str)
    posx, posy = move!(line, posx, posy)
  end
  return posx, posy
end

function move!(line, posx, posy, aim)
  statement, value = split_command(line)
  if statement == "forward"
    posx += value
    posy += aim*value
  elseif statement == "up"
    aim -= value
  elseif statement == "down"
    aim += value
  end
  return posx, posy, aim
end

function traverse(str, posx, posy, aim)
  println("Im here")
  while length(str) > 0
    line = popfirst!(str)
    posx, posy, aim = move!(line, posx, posy, aim)
  end
  return posx, posy, aim
end

input_test = """
forward 5
down 5
forward 8
up 3
down 8
forward 2"""

# --- Part One ---
# Test input
posx, posy = 0, 0
parsed_in = input_test |> x -> rsplit(x, "\n")
traverse(parsed_in, posx, posy) |> x -> reduce(*, x)

# Full input
posx, posy = 0, 0
parsed_in = read("./data/2_dive/input.txt", String) |> x -> split(x, "\n")
traverse(parsed_in, posx, posy) |> x -> reduce(*, x)

# --- Part Two ---
# Full input
posx, posy, aim = 0, 0, 0
parsed_in = read("./data/2_dive/input.txt", String) |> x -> split(x, "\n")
traverse(parsed_in, posx, posy, aim) |> x -> x[1]*x[2]