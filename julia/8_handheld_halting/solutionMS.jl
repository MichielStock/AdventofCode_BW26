#=
Author: Michiel Stock
AoC: day 8

Find at which point the code enters a loop
=#


example = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

parse_input(input) = split(rstrip(input), "\n") .|> (s->split(s, " ")) .|> (s -> (s[1], parse(Int, s[2])))

function run_instructions(instructions)
    n = length(instructions)
    visited = zeros(Bool, n)
    pos = 1
    acc = 0
    while pos != n+1
        if visited[pos]
            return false, acc
        else
            visited[pos] = true
        end
        instr, val = instructions[pos]
        if instr == "nop"  # skip
            pos += 1
        elseif instr == "acc"  # accumulate
            acc += val
            pos += 1
        elseif instr == "jmp"
            pos += val
        else
            throw(ErrorException)
        end
    end
    return true, acc
end

swap_instr(instr) = instr == "nop" ? "jmp" : "nop"

function modify_instructions(instructions)
    instructions = copy(instructions)
    n = length(instructions)
    for i in 1:n
        instr, val = instructions[i]
        instr == "acc" && continue
        # change
        instructions[i] = (swap_instr(instr), val)
        find_loop(instructions)[1] && return instructions
        # change back
        instructions[i] = (instr, val)
    end
end

#instructions = parse_input(example)

instructions = read("data/8_handheld_halting/input.txt", String) |> parse_input

term, acc_end = run_instructions(instructions)

new_instructions = modify_instructions(instructions)

term, acc_new = run_instructions(new_instructions)