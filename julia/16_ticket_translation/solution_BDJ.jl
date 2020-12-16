#=
Author: Bram De Jaegher
AoC: day 16
=#

function parse_rules(s::AbstractString)
  rules_dict = Dict{String, Array}()
  rules = split(s,"\n")[1:end-2]
  for rule in rules
    name, interval = split(rule,": ")
    intervals = split(interval, " or ")
    rules_dict[string(name)] = [Tuple(parse.(Int,split(interval,"-"))) for interval in intervals]
  end
  return rules_dict
end

function parse_input(s::String)
  rules, rest = split(s,"your ticket:")
  rules = parse_rules(rules)  

  my_ticket, rest = split(rest,"nearby tickets:")
  my_ticket = replace(my_ticket,"\n"=>"") |> s-> parse.(Int,split(s,","))

  nearby_tickets = split(rest,"\n")[2:end]
  nearby_tickets = [replace(ticket,"\n"=>"") |> s-> parse.(Int,split(s,",")) for ticket in nearby_tickets]
  return rules, my_ticket, nearby_tickets
end

function validate(ticket::Array, rules)
  invalid = Set([])

  for num in ticket
    checks = [(intervals[1][1] ≤ num ≤ intervals[1][2]) || (intervals[2][1] ≤ num ≤ intervals[2][2]) for (field, intervals) in rules]
    if sum(checks) == 0
      push!(invalid,num)
    end
  end
  length(invalid) > 0 &&  return invalid
  return 0
end


rules, my_ticket, nearby_tickets= """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12""" |> parse_input

rules, my_ticket, nearby_tickets= read("data/16_ticket_translation/input.txt", String) |> chomp |> string |> parse_input
sum([sum(collect(validate(ticket, rules))) for ticket in nearby_tickets])


# --- Part 2 --- #
function find_options(rules, tickets, n=20)
  valid_locations=Dict{String,Array}()
  for i in 1:n
    options = []
    for (field, intervals) in rules
      count = 0
      for ticket in tickets
        if (intervals[1][1] ≤ ticket[i] ≤ intervals[1][2]) || (intervals[2][1] ≤ ticket[i] ≤ intervals[2][2])
          count += 1
        end
      end
      if count == length(tickets)
        if haskey(valid_locations, field)
          push!(valid_locations[field], i)
        else
          valid_locations[field] = [i]
        end
      end
    end
  end
  return valid_locations
end

function construct_list(valid_rules)
  lst = []
  for (key,value) in valid_rules
    push!(lst,(key, value))
  end
  return lst
end

function eliminate!(rule_lst; counter=1)
  while true
    for (index, (name, indexes)) in enumerate(rule_lst[counter+1:end])
      a = deleteat!(rule_lst[index+counter][2], indexes.==rule_lst[counter][2][1])
      rule_lst[index+counter] =(name, a)
    end
    if length(rule_lst[counter+1][2]) == 1
      counter += 1
      sort!(rule_lst; by=x->length(x[2]))
      if counter > length(rule_lst)-1
        break
      end
    else
      break
    end
  end
end

function solve2()
  valid_tickets = [ticket for ticket in nearby_tickets if validate(ticket,rules)==0]
  valid_rules = find_options(rules,valid_tickets)
  rule_lst = construct_list(valid_rules)
  rule_lst = sort(rule_lst; by=x->length(x[2]))
  eliminate!(rule_lst)
  return reduce(*,[my_ticket[num][1] for (field, num) in rule_lst if match(r"departure.*",field)!== nothing])
end


solve2()






