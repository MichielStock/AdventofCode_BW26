#=
Author: Michiel Stock
AoC: day 19

Decode the corrupted messages
=#

input = """
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"""

input2 = """
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
"""

parseint(str) = parse(Int, str)

function parse_input(input)
    rules_str, messages_str = split(rstrip(input), "\n\n")
    rules = Dict{Int,String}()
    for l in split(rules_str, "\n")
        m = match(r"(\d+): (.+)", l)
        r = m[2]
        r[1] == '"' && (r = r[2:2])
        rules[parseint(m[1])] = String(r)
    end
    messages = split(messages_str, "\n")
    return rules, messages
end

function find_messages(rules)
    messages = Dict{Int,Vector{String}}()
    # get all pure strings
    for (i, r) in rules
        m = match(r"[a-z]", r)
        !isnothing(m) && (messages[i] = [r])
    end
    dependencies = Dict(i => parseint.(getindex.(eachmatch(r"(\d+)", r),1)) for (i, r) in rules if !haskey(messages, i))
    # fill all combinations of rules
    while length(messages) < length(rules)
        for (i, dep) in dependencies
            if issubset(dep, keys(messages))
                r = rules[i]
                messages[i] = []
                for comb in eachmatch(r"([^|]+)", r)
                    c = comb[1]
                    mes = [""]
                    for s in eachmatch(r"(\d+)", c)
                        j = parseint(s[1])
                        mes = mes .* reshape(messages[j], 1, :)
                        mes = vec(mes)
                    end
                    append!(messages[i], mes)
                end
                delete!(dependencies, i)
            end
        end
    end
    return messages
end

function match_new(message, messages_rule)
    # assume that length of subparts are the same
    l_ss = messages_rule[42] |> first |> length
    n = length(message)
    n % l_ss != 0 && return false
    n_ss = n ÷ l_ss
    substrings = [message[i:i+l_ss-1] for i in 1:l_ss:n-1]
    match_42 = any(occursin.(reshape(substrings, 1, :), messages_rule[42]), dims=1)[:]
    match_31 = any(occursin.(reshape(substrings, 1, :), messages_rule[31]), dims=1)[:]
    (!match_42[1] || !match_31[end]) && return false
    for i in 1:(n_ss-1)
        i > n_ss - i && all(match_42[1:i]) && all(match_31[(i+1):end]) && return true
    end
    return false
end
    

input = read("data/19_monster_messages/input.txt", String)
rules, messages = parse_input(input)
messages_rule = find_messages(rules)

sol1 = intersect(Set(messages_rule[0]), Set(messages)) |> length

# fix rules
rules[8] = "42 | 42 8"  # any finite repetition of the messages of rule 42
rules[11] = "42 31 | 42 11 31"  # begins with 42 and ends in 31
# these only affect rule zero in turn, so most of it can be recovered, oof!
# so rule 0 is a match of both
# rule[0] = "8 11"

sol2 = count(m->match_new(m, messages_rule), messages)
