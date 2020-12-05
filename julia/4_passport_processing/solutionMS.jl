#=
Author: Michiel Stock
AoC: day 4

Check whether passwords are valid.
=#

fn = "data/4_passport_processing/input.txt"

function parse_input(data)
    # split in records
    records_raw = split(data, "\n\n")
    # regex to match the data
    pattern = r"(\S+):(\S+)"
    records = Dict{String,String}[]
    for r in records_raw
        record = Dict{String,String}()
        for m in eachmatch(pattern, r)
            field, val = m[1], m[2]
            record[field] = val
        end
        push!(records, record)
    end
    return records
end

passports = read(fn, String) |> parse_input

required_fields = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

isvalidpassport(record) = issubset(required_fields, keys(record))

function isvalidpassport2(record)
    !isvalidpassport(record) && return false
    !(1920 ≤ parse(Int, record["byr"]) ≤ 2002) && return false
    !(2010 ≤ parse(Int, record["iyr"]) ≤ 2020) && return false
    !(2020 ≤ parse(Int, record["eyr"]) ≤ 2030) && return false
    !(occursin("cm", record["hgt"]) || occursin("in", record["hgt"])) && return false
    heigth = parse(Int, record["hgt"][1:end-2])
    occursin("cm", record["hgt"]) && !(150 ≤ heigth ≤ 193) && return false
    occursin("in", record["hgt"]) && !(59 ≤ heigth ≤ 76) && return false
    (match(r"#[0-9a-f]{6}", record["hcl"])) === nothing && return false
    record["ecl"] ∉ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] && return false
    (length(record["pid"]) !=9 || (match(r"[0-9]{9}", record["pid"])) === nothing) && return false
    return true
end

invalid_passports = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
""" |> parse_input

valid_passports = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
""" |> parse_input

number_valid_passports = count(isvalidpassport, passports)
number_valid_passports2 = count(isvalidpassport2, passports)

println("The first solution is: $number_valid_passports")
println("The second solution is: $number_valid_passports2")