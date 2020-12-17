#=
Author: Michiel Stock
AoC: day 16

Parsing a train ticket
=#

input = """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""

validrange(n, r1, r2) = (n ∈ r1) || (n ∈ r2)
validrange(n, (r1, r2)) = validrange(n, r1, r2)
pint(str) = parse(Int, str)

function parse_input(input)
    attrs, myticket, tickets = split(rstrip(input), "\n\n")
    ticket_attr = Dict(m[1] => (pint(m[2]):pint(m[3]), pint(m[4]):pint(m[5]))
                    for m in eachmatch(r"(.+): (\d+)-(\d+) or (\d+)-(\d+)", attrs))
    myticket = [pint(m[1]) for m in eachmatch(r"(\d+)", myticket)]
    tickets = vcat([[pint(m[1]) for m in eachmatch(r"(\d+)", ticket)]' for ticket in split(tickets, "\n")[2:end]]...)
    return ticket_attr, myticket, tickets
end

function count_invalid(attributes, tickets)
    total = 0
    invalid = zeros(Bool, size(tickets)...)
    for (i, v) in enumerate(tickets)
        if !any(validrange.(v, values(attributes)))
            total += v
            invalid[i] = true
        end
    end
    return total, any(invalid, dims=2)[:]
end

objective(M, perm) = sum((M[i,j]) for (i,j) in enumerate(perm))


function find_matching(ticket_attr, myticket, tickets)
    tickets = [myticket'; valid_tickets]
    n, k = size(tickets)
    attr = keys(ticket_attr) |> collect

    possibilites = [all(validrange(tickets[i,j], ticket_attr[a]) for i in 1:n) for a in attr, j in 1:k]
    matches = zeros(Int, k)
    while sum(possibilites) > 0
        i = findfirst(sum(possibilites, dims=2)[:].==1)
        j = findfirst(possibilites[i,:])
        possibilites[:,j] .= false
        matches[i] = j
    end
    return Dict(a => myticket[matches[i]] for (i, a) in enumerate(attr))
end


input2 = """
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"""

input = read("data/16_ticket_translation/input.txt", String);
ticket_attr, myticket, tickets = parse_input(input)

sol1, invalid = count_invalid(ticket_attr, tickets)

tickets = tickets[.~invalid,:]

myticket = find_matching(ticket_attr, myticket, tickets)

sol2 = [v for (k, v) in myticket if !isnothing(match(r"^departure", k))] |> prod
