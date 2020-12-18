using DelimitedFiles
using IterTools
data = readdlm("data/9_encoding_error/input.txt", Int)

l_pre = 25
for i in l_pre+1:length(data)
    sums = []
    for i in subsets(data[i-l_pre:i-1], 2)
        push!(sums, sum(i))
    end
    if data[i] ∉ sums
        global inval = data[i]
        break
    end
end
println(inval)

for window in 2:16
    for i in 1:length(data)-window
        if sum(data[i:i+window]) == inval
            println(sum([maximum(data[i:i+window]), minimum(data[i:i+window])]))
        end
    end
end