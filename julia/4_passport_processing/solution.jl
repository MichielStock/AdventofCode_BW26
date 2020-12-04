#=
Author: Bram De Jaegher
AoC: day 4

Hacking passport security
=#

using Test

function validate(passport, requirements::Array)
 sum(occursin.(requirements, passport)) == length(requirements)
end

function validate(passport, requirements::Dict)
  passed = 0
  for (field, func) in requirements
    entry = split(passport, field)
    if length(entry) >= 2  # field is present
      value = split(entry[2], " ")[1]
      passed += func(value)
    end
  end
  return passed == length(requirements)
 end

f_check_hgt = function (s)
  if length(split(s,"cm")) == 2
    hgt = parse(Int,split(s,"cm")[1])
    return 150<=hgt<=193
  elseif length(split(s,"in")) == 2
    hgt = parse(Int,split(s,"in")[1])
    return 59<=hgt<=76
  else
    return false
  end
end

## ---- Part 1 ------- ##
example = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm
\n
iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929
\n
hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm
\n
hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""|> s -> replace(s,r"(\n)"=>" ") |> s -> split(s,"  ") 
requirements1 = ["byr:", "iyr:", "eyr:", "hgt:", "hcl:", "ecl:", "pid:"]

@test sum([validate(passport, requirements1) for passport in example]) == 2


fn = "data/4_passport_processing/input.txt" 
passports = read(fn, String) |> rstrip |> s -> replace(s,"\n"=>" ") |> s -> split(s,"  ") 
@test sum([validate(passport, requirements1) for passport in passports]) == 196

## ---- Part 2 ------- ##
invalid_example = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
\n
iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946
\n
hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
\n
hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
"""|> s -> replace(s,r"(\n)"=>" ") |> s -> split(s,"  ") 

valid_example = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f
\n
eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
\n
hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022
\n
iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
"""|> s -> replace(s,r"(\n)"=>" ") |> s -> split(s,"  ") 

requirements2 = Dict(
  "byr:" => d -> 1920<=parse(Int, d)<=2002 && length(parse(Int, d)) <= 5,
  "iyr:" => d -> 2010<=parse(Int, d)<=2020 && length(parse(Int, d)) <= 5,
  "eyr:" => d -> 2020<=parse(Int, d)<=2030 && length(parse(Int, d)) <= 5,
  "hgt:" => f_check_hgt,
  "hcl:" => s -> match(r"^#([0-9]|[a-f]){6}$", s) !== nothing,
  "ecl:" => s -> match(r"amb|blu|brn|gry|grn|hzl|oth", s) !== nothing,
  "pid:" => s -> match(r"^[0-9][0-9]{7}[0-9]$", s) !== nothing
)

@test sum([validate(passport, requirements2) for passport in invalid_example]) == 0
@test sum([validate(passport, requirements2) for passport in valid_example]) == 4

@test sum([validate(passport, requirements2) for passport in passports]) == 114
