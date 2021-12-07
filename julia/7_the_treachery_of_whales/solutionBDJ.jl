#= --- Day 7: The Treachery of Whales ---
        Bram De Jaegher
=#

input_test = "16,1,2,0,4,2,7,1,2,14"

parse_input(x) = split(x,",") .|> x -> parse(Int,x)

function optimise(positions, fuel_policy; start=0)
	min_fuel_consumption = 1e8
	setpoint = start
	
	for index in 1:maximum(positions)
		current_fuel_consumption = fuel_policy(positions, setpoint)
		if current_fuel_consumption < min_fuel_consumption
			min_fuel_consumption = current_fuel_consumption
		end
		setpoint += 1
	end
	return min_fuel_consumption
end



# ------ Part 1 ------ #
fuel_policy1(positions,setpoint) = sum(abs.(positions.-setpoint))

# Test data
positions_test = parse_input(input_test)
fuel = optimise(positions_test, fuel_policy1)


# Full data
positions_full = read("./data/7_the_treachery_of_whales/input.txt", String) |> parse_input
fuel = optimise(positions_full, fuel_policy1)

# ------ Part 2 ------ #
function fuel_policy2(positions,setpoint)
	 N = abs.(positions.-setpoint)
	 return sum(N.^2 .+ N) ÷ 2
end

# Test data
positions_test = parse_input(input_test)
fuel = optimise(positions_test, fuel_policy2)


fuel = optimise(positions_full, fuel_policy2)
