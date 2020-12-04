using DelimitedFiles
using IterTools

function solution(data, k)
    for i in subsets(data, Val{k}())
        if sum(i) == 2020
            return prod(i)
        end
    end
end

data = readdlm("data/1_report_repair/input_day1.txt", Int)
solution(data, 2)
solution(data, 3)