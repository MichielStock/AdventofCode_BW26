function run_prog(data)
    next = 1
    accumulator = 0
    already = []
    while true
        push!(already, next)
        if data[next][1:3] != "nop"
            num = parse(Int, match(r"(\+|-)\d+", data[next]).match)
        else 
            next += 1
            continue
        end
        if data[next][1:3] == "acc"
            accumulator += num
            next += 1
        elseif data[next][1:3] == "jmp"
            next += num
        end
        if next ∈ already
            break
        elseif next == length(data)+1
            return false, accumulator
            break
        end
    end
    return true, accumulator
end

function change(op)
    if op[1:3] == "jmp"
        return string("nop", op[4:end])
    elseif op[1:3] == "nop"
        return string("jmp", op[4:end])
    end
end

data = split(rstrip(read("data/8_handheld_halting/input.txt", String)), "\n")
loop, res1 = run_prog(data)
println(res1)

data = split(rstrip(read("data/8_handheld_halting/input.txt", String)), "\n")
for i in 1:length(data)
    new_data = copy(data)
    if data[i][1:3] != "acc"
        new_data[i] = change(data[i])
        loop, res = run_prog(new_data)
        if !(loop)
            println(res)
            break
        end
    end
end