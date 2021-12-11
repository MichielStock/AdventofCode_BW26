# solution day 2: Ward Van Belle
using DelimitedFiles

test = [
"forward" 3;
"down" 3;
"up" 2
]

gps_info = readdlm("input.txt")

# question 1

solution1 = sum(gps_info[gps_info[:,1] .== "forward",2]) * (sum(gps_info[gps_info[:,1] .== "down",2]) - sum(gps_info[gps_info[:,1] .== "up",2]))
println(solution1)

# question 2

aim = 0
depth = 0
forward_pos = 0

for (i,command) in enumerate(gps_info[:,1])
    if command == "forward"
        global forward_pos += gps_info[i,2]
        global depth += aim * gps_info[i,2]
    else
        global aim += (command == "up" ? -(gps_info[i,2]) : gps_info[i,2])
    end
end

solution2 = depth * forward_pos
println(solution2)