# --- Day 19: Beacon Scanner --- #
#   Author: Bram De Jaegher      #
# --- ---------------------- --- #

"""
Scanner object that consists of an ID, the center of the scanner and the beacons in range
"""
mutable struct Scanner
  id::Int
  X₀::Array         # position (-Inf, -Inf, -Inf) if unpositioned
  beacons::Vector    

  function Scanner(id, beacons::Vector)
    new(id, [0, 0, 0], beacons)
  end
end

function read_scanner(str)
  lines = split(str, "\n")
  id = parse(Int,match(r".*scanner ([0-9]*)",popfirst!(lines))[1])
  beacons = split.(lines,",") .|> x -> parse.(Int,x)
  return Scanner(id, beacons)
end

"""
Matches two scanner objects and returns the overlapping beacons if the number...
  of overlapping beacons > 12

  For a scanner the distances from one beacon to all other beacons in that scanner are computed and compared to the same for the other scanner.
  If the distances of 12 beacons overlap for both scanners, the coordinates of these common beacons are returned in two lists. The each list index corresponds to the same...
  beacon but the coordinate system is different. 
"""
function Base.match(s₁::Scanner, s₂::Scanner)
  N_match = 0
  for b₂ in s₂.beacons
    for b₁ in s₁.beacons
      d₁ = distance(s₁.beacons, b₁) 
      d₂ = distance(s₂.beacons, b₂) 
      overlap = intersect(d₁, d₂)
      if length(overlap) ≥ 12
        common1 = s₁.beacons[[d ∈ overlap for d in d₁]]
        common2 = s₂.beacons[[d ∈ overlap for d in d₂]]
        common1 = sort(collect(zip(common1, d₁[[d ∈ overlap for d in d₁]])); by=last) .|> first
        common2 = sort(collect(zip(common2, d₂[[d ∈ overlap for d in d₂]])); by=last) .|> first
        return common1, common2
        #return sort(common1; by=x->distance(d₁,x)), sort(common2; by=x->distance(d₂,x))
      end
    end
  end
  return false, false
end

# Defining a list of coordinate transformations

"""
  Do nothing
"""
function noswap(s::Vector) 
  sNew = copy(s)
  return(sNew)
end

"""
  Swap XY
"""
function swapxy(s::Vector)
  sNew = copy(s)
  for index in 1:length(s)
    sNew[index] = [s[index][2], s[index][1], s[index][3]]
  end  
  return sNew
end

"""
  Swap XZ
"""
function swapxz(s::Vector)
  sNew = copy(s)
  for index in 1:length(s)
    sNew[index] = [s[index][3], s[index][2], s[index][1]]
  end  
  return sNew
end

"""
  Swap YZ
"""
function swapyz(s::Vector)
  sNew = copy(s)
  for index in 1:length(s)
    sNew[index] = [s[index][1], s[index][3], s[index][2]]
  end  
  return sNew
end

# And so on...
function swapxyz1(s::Vector)
  sNew = copy(s)
  for index in 1:length(s)
    sNew[index] = [s[index][3], s[index][1], s[index][2]]
  end  
  return sNew
end

function swapxyz2(s::Vector)
  sNew = copy(s)
  for index in 1:length(s)
    sNew[index] = [s[index][2], s[index][3], s[index][1]]
  end  
  return sNew
end


distance(s::Vector, beacon::Vector) = [sum((beacon2 .- beacon).^2) for beacon2 in s]

""" Iteratively changes the rotation of a list of beacons (beacons2) and compares with a second list of beacons.
If both lists of beacons refer to the same beacons, at some point a translation is found that is the same for all couple of beacons...
this means we found the correct rotation of the first list of beacons. 
"""
function reorient(beacons2, beacons1)
  for swap in [noswap, swapxy, swapxz, swapyz, swapxyz1, swapxyz2]
    for orientation in Iterators.product((-1,1),(-1,1),(-1,1))
      beaconsTemp = swap(beacons2)
      beaconsTemp = [beacon.*orientation for beacon in beaconsTemp] 
      distances = [beacon1.-beacon2 for (beacon1, beacon2) in zip(beacons1, beaconsTemp)]
      if length(unique(distances)) == 1   # check for translation
        return distances[1], orientation, swap
      end
    end
  end
end

"""
  Transform the beacons in range of the scanner according to a swap function and orientation function 
"""
function recenter!(s::Scanner, X, swap, orientation)
  s.beacons = swap(s.beacons) 
  s.beacons = [beacon.*orientation.+X for beacon in s.beacons]
  return s 
end


"""
  Loop over the list of scanner and find overlapping swarms of beacons. This procedure stops when no more additional beacons are found.
"""
function count_beacons(scanners)
  scanner0 = scanners[1]
  nBeacons = length(scanner0.beacons)

  while true
    for scanner in scanners[2:end]  
      c1, c2 = match(scanner0, scanner)
      if c1 !== false
        X, orientation, swap  = reorient(c2, c1)
        if sum(abs.(X)) > 0
          scanner.X₀ = X
        end
        scanner = recenter!(scanner, X, swap, orientation)
        scanner0.beacons = append!(scanner0.beacons,scanner.beacons)
        scanner0.beacons = unique(scanner0.beacons)
      end
    end
      
    if length(scanner0.beacons) == nBeacons
      break
    else
      nBeacons = length(scanner0.beacons)
    end
  end
  return nBeacons
end

function max_distance(scanners)
  manhattan_max = 0
  for (scanner1,scanner2) in Iterators.product(scanners,scanners)
    manhattan_dist = sum(abs.(scanner1.X₀ .- scanner2.X₀))
    if manhattan_dist > manhattan_max 
      manhattan_max = manhattan_dist
    end 
  end
  return manhattan_max
end

# --- Part 1 --- #
# Test
scanners_test = """
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14 """ |> x -> split(x,"\n\n") .|> read_scanner 

count_beacons(scanners_test)
max_distance(scanners_test)

# Full
scanners_full = read("./data/18_beacon_scanner/input.txt", String) |> x -> split(x,"\n\n") .|> read_scanner 

count_beacons(scanners_full)
max_distance(scanners_full)

