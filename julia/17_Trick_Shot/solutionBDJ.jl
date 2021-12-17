# --- Day 17: Trick Shot --- #
#     Author: BDJ            #
# --- ------------------ --- #

struct Target
  p₁::Tuple{Int,Int}
  p₂::Tuple{Int,Int}

  function Target(s::String)
    numbers = collect(eachmatch(r"=([-]*[0-9]*)\.\.([-]*[0-9]*)",s))
    return new(parse.(Int,(numbers[1][1],numbers[2][1])),parse.(Int,(numbers[1][2],numbers[2][2])))
  end
end

Base.in(p::Vector{Int64}, t::Target) = (t.p₁[1] ≤ p[1] ≤ t.p₂[1]) && (t.p₁[2] ≤ p[2] ≤ t.p₂[2])
haspassed(p::Vector{Int64}, t::Target) = (p[1] > t.p₂[1]) | (p[2] < t.p₁[2])

function shoot(V, target::Target; p=[0,0], a=[-1,-1])
  maxY = 0
  while !haspassed(p,target)
    p = p .+ V            # update position
    if p ∈ target         # reached target?
      return true, maxY
    end
    V = V .+ a            # update velocity
    if V[1] < 0           # avoid negative x-velocity for drag
      V[1] = 0 
    end
    
    if p[2] > maxY        # track max y-position
      maxY=p[2]
    end 
  end
  return false, -1
end

function optimise(target; search_space=(1:20, 1:20))
  best = [0, [0, 0]]
  for Vᵢ in Iterators.product(search_space...)
    hit, Y = shoot(Vᵢ, target)
    if hit && (Y > best[1])
      best[1] = Y
      best[2] = Vᵢ
    end
  end
  return best
end

function findall(target::Target; search_space = (1:1000, -1000:1000))
  succes = 0
  for Vᵢ in Iterators.product(search_space...)
    hit, _ = shoot(Vᵢ, target)
    if hit 
      succes += 1
    end
  end
  return succes
end

# --- Part 1
# Test 
target1 ="target area: x=20..30, y=-10..-5" |>  Target
shoot((7,2), target1)
shoot((6,3), target1)
shoot((9,0), target1)

optimise(target1)

# Full
target2 ="target area: x=48..70, y=-189..-148" |>  Target
optimise(target2; search_space=(1:100, 0:1000))

# --- Part 2
findall(target1)
findall(target2)