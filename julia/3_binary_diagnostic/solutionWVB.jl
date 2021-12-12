# day 3 solution

using DelimitedFiles

input_text = readdlm("../../Data/3/input.txt",String)
binaries = zeros((length(input_text),length(input_text[1])))

# question 1

gamma_rate = zeros(length(input_text[1]))
epsilon_rate = zeros(length(input_text[1]))

for (i,binary) in enumerate(input_text)
    binaries[i,:] = parse.(Int64,split(binary,""))
end

for i in 1:length(binaries[1,:])
    if sum(binaries[:,i])/length(binaries[:,i]) > 0.5
        gamma_rate[i] = 1
        epsilon_rate[i] = 0
    else
        gamma_rate[i] = 0
        epsilon_rate[i] = 1
    end
end

powers = Array(0:(length(epsilon_rate)-1))

epsilon_rate = sum(2 .^ powers[reverse(epsilon_rate) .!= 0])
gamma_rate = sum(2 .^ powers[reverse(gamma_rate) .!= 0])

println(epsilon_rate * gamma_rate)

# question 2

oxygen_options = binaries
CO2_options = binaries

counter = 1

while length(oxygen_options[:,1]) > 1
    most_prevalent = count(==(1),oxygen_options[:,counter]) >= count(==(0),oxygen_options[:,counter]) ? 1 : 0
    global oxygen_options = oxygen_options[oxygen_options[:,counter] .== most_prevalent,:]
    global counter += 1
end

counter = 1

while length(CO2_options[:,1]) > 1
    most_prevalent = count(==(1),CO2_options[:,counter]) >= count(==(0),CO2_options[:,counter]) ? 0 : 1
    global CO2_options = CO2_options[CO2_options[:,counter] .== most_prevalent,:]
    global counter += 1
end

oxygen = sum(2 .^ powers[reverse(oxygen_options[1,:]) .!= 0])
CO2 = sum(2 .^ powers[reverse(CO2_options[1,:]) .!= 0]) 
println(oxygen * CO2)
