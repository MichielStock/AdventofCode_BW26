#=
Author: Michiel Stock
AoC: day 3

Find a direction to minimizes the number of trees encounterd.
=#

using Test

function simulate_path(space, offset, down=1)
    x, y = 1, 1
    n, m = size(space)
    n_trees = 0
    for y in 1:down:n
        n_trees += space[y,x]
        x += offset
        while x > m
            x -= m
        end
    end
    return n_trees
end

function parse_input(input)
    lines = split(input, "\n")
    m = length(first(lines))
    return [l[j]=='#' for l in lines, j in 1:m]
end

example = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#""" |> parse_input

@test simulate_path(example, 3) == 7

product_example = simulate_path(example, 1) * 
                    simulate_path(example, 3) * 
                    simulate_path(example, 5) * 
                    simulate_path(example, 7) * 
                    simulate_path(example, 1, 2)
@test product_example == 336

space = read("data/3_Tobbogan_trajectory/input.txt", String) |> rstrip |> parse_input

tree_step_3 = simulate_path(space, 3)

product_directions = simulate_path(space, 1) * 
                        simulate_path(space, 3) * 
                        simulate_path(space, 5) * 
                        simulate_path(space, 7) * 
                        simulate_path(space, 1, 2)

# for fun, best direction and number of trees

min_trees, best_dir = minimum((simulate_path(space, dir), dir) for dir in 1:size(space,1))