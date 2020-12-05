#=
Author: Michiel Stock
AoC: day 2

Check if a password matches the requirements.
=#

function check_password((l, u, c, str))
    return l ≤ count(x->x==c, str) ≤ u
end

function check_password2((i, j, c, str))
    return (str[i] == c || str[j] == c) && str[i] != str[j]
end


line = "1-3 a: abcde"

function parseline(line)
    numbs, char, str = split(line, " ")
    l, u = parse.(Int, split(numbs, "-"))
    c = char[1]
    return l, u, c, str
end

fn = "data/2_password_philosophy/input.txt"

open(fn, "r") do f
    global pwd_structs = [parseline(rstrip(l)) for l in eachline(f)]
end

number_correct_pwds = count(check_password, pwd_structs)

number_correct_pwds2 = count(check_password2, pwd_structs)
