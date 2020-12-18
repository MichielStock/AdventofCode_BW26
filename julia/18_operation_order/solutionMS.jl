#=
Author: Michiel Stock
AoC: day 18

Quircky arithmitic
=#


expr = "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"

parseint(str) = parse(Int, str)

function evaluate_expression(expr)
    while occursin("(", expr)
        expr = replace(expr, r"\(([\s\d\+\*]+)\)"=>s->evaluate_expression(s[2:end-1]))
    end
    total = 0
    operator = +
    for element in split(expr, " ")
        if match(r"\d+", element) isa Nothing
            if occursin("+", element)
                operator = +
            else
                operator = *
            end
        else
            n = parseint(element)
            total = operator(total, n)
        end
    end
    return total
end

function parsesum(expr)
    m = match(r"(\d+) \+ (\d+)", expr)
    return parseint(m[1]) + parseint(m[2])
end

function parseprod(expr)
    m = match(r"(\d+) \* (\d+)", expr)
    return parseint(m[1]) * parseint(m[2])
end

function evaluate_expression2(expr)
    while occursin("(", expr)
        expr = replace(expr, r"\(([\s\d\+\*]+)\)"=>s->evaluate_expression2(s[2:end-1]))
    end
    while occursin("+", expr)
        expr = replace(expr, r"(\d+) \+ (\d+)"=>parsesum)
    end
    while occursin("*", expr)
        expr = replace(expr, r"(\d+) \* (\d+)"=>parseprod)
    end
    return parseint(expr)
end

expressions = read("data/18_operation_order/input.txt", String) |> rstrip |> s -> split(s, "\n")

results = evaluate_expression.(expressions)
sol1 = sum(results)

sol2 = evaluate_expression2.(expressions) |> sum