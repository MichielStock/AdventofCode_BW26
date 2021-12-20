# --- Day 18: Snailfish      --- #
#   Author: Bram De Jaegher      #
# --- ---------------------- --- #

mutable struct Tracker
  pos::Int
  depth::Int
  changed::Bool

  Tracker() = new(1, 0, false)
end

right!(T::Tracker) = T.pos +=1
in!(T::Tracker) = T.depth +=1
out!(T::Tracker) = T.depth -=1
reset!(T::Tracker) = T.depth, T.pos = 1, 1

struct SnailfishNumber 
  value::String
end

function Base.:+(x₁::SnailfishNumber, x₂::SnailfishNumber)
  num = SnailfishNumber("["*x₁.value*","*x₂.value*"]")
  return reduce(num)
end

Base.getindex(num::SnailfishNumber, T::Tracker) = num.value[T.pos]
Base.length(num::SnailfishNumber) = length(num.value)


function explode(num::SnailfishNumber, T::Tracker)
  
end

function split(num::SnailfishNumber, T::Tracker)

end

function Base.reduce(num::SnailfishNumber;T=Tracker())
  while true
    right!(T)
    T.pos > length(num) && !T.changed && break
    if num[T] == '['
      in!(T)
    elseif num[T] == ']'
      out!(T) 
    elseif num[T] ∈ ([0:9] |> collect .|> Char |> x -> push!(x,'t'))
      if T.depth > 4
        explode(num, T)
      elseif parse(Int, num[T]
        split(num,T)
        reset!(T)
      end
    end
  end


  # Go right
  # if [ increment depth
  # if ] reduce depth
  # if number
    # if depth > 4
      # EXPLODE => explodeYet = true

    # if number > 10 
      # SPLIT => go back to start
end


example = """
[1,2]
[[1,2],3]
[9,[8,7]]
[[1,9],[8,5]]
[[[[1,2],[3,4]],[[5,6],[7,8]]],9]
[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]""" |> x -> split(x,"\n") .|> SnailfishNumber


a = SnailfishNumber("[1,2]")
b = SnailfishNumber("[[3,4],5]")

T = Tracker()

b[T]