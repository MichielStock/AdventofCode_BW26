#= --- Day 6: Lanternfish ---
        Bram De Jaegher
=#


input_test = "3,4,3,1,2"

parse_input(x) = split(x,",") .|> x -> parse(Int,x)
intialise_fish_dict(fishes) = Dict([index => count(x->x==index, fishes) for index in 0:8])


function update!(fishes; n = 1)
	for i in 1:n
		num_spawners = fishes[0] 
		new_fishes = copy(fishes)
		# age fish
		for age in 1:8
			new_fishes[age-1] = fishes[age]
		end
		new_fishes[6] = new_fishes[6] + num_spawners
		new_fishes[8] = num_spawners 
		fishes = new_fishes
	end
	return fishes
end

# ------ Part 1 ------ #
# Test data
fishes = parse_input(input_test) |> intialise_fish_dict
update!(fishes; n=80) |> values |> sum

# Full data
fishes = read("./data/6_lanternfish/input.txt", String) |> parse_input |> intialise_fish_dict
update!(fishes; n=80) |> values |> sum

# ------ Part 2 ------ #
fishes = read("./data/6_lanternfish/input.txt", String) |> parse_input |> intialise_fish_dict
update!(fishes; n=256) |> values |> sum
