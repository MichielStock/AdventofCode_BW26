#=
Authors: Michiel Stock

Benchmarking the solutions in Julia code.
=#

using BenchmarkTools, DataFrames, CSV, Suppressor

foldernames = [
    "1_report_repair",
    "2_password_philosophy",
    "3_Toboggan_trajectory",
    "4_passport_processing",
]

# add here the number of the challenge and your
# initials, the order does not matter
solved = [
    (1, "MS"),
    (2, "MS"),
    (3, "MS"),
    (4, "MS"),
    (5, "MS"),
    (6, "MS")
]

# get all participants
participants = solved .|> last |> unique
n_participants = length(participants)
n_challenges = length(foldernames)

benchmarks = DataFrame(Array{Union{Float64,Missing}}(missing,
            n_challenges, n_participants), participants)

function benchmark_sol(filename)
    return @belapsed @suppress include(filename)
end

for (day, initial) in solved
    benchmarks[day, initial] = benchmark_sol(joinpath("julia", foldernames[day], "solution$initial.jl"))
end

CSV.write("benchmarking/reports/julia.csv", benchmarks)