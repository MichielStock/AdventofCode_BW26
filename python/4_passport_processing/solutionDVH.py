#%%
fn = "./data/day4.txt"
with open(fn, "r") as f:
    data = f.readlines()

# %%
# data is separated by a blank line, if all lines are joined, then 
# the blank lines will show up as two consecutive line delimiters 
massive_string = ''.join(data)
# %%
passport_entries = massive_string.split("\n\n")
# %%
def process_passport_entry(passport_entry):
    # split without arguments spits on all the whitespace
    # this results in a nested list of the form [[k1, v1], ...]
    split = [i.split(':') for i in passport_entry.split()]
    # optional to generate a dictionary from this list
    #dict(split)
    k = [i[0] for i in split]
    #v = [i[1] for i in split]

    # rule: should have all 8 fields
    """if len(k) == 8:
        print(k)
        return True
    else:
        return False"""
    # rule: should have at least 7 fields, cid is optional
    # just check if all fields are in the list
    expected_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    #"cid"
    if all([field in k for field in expected_fields]):
        return True
    else:
        return False

# %%
# check all passports and take the sum to count how many are a-ok.
sum([process_passport_entry(i) for i in passport_entries])
# %%

# %%
def check_byr(byr, verbose=False):
    # byr (Birth Year) - four digits; at least 1920 and at most 2002.
    try: 
        byr_int = int(byr)
        res = (1920 <= byr_int <= 2002)
        print(byr_int, res) if verbose else None
        return res
    except:
        print(byr, False) if verbose else None
        return False

def check_iyr(iyr, verbose=False):
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    try: 
        iyr_int = int(iyr)
        res = (2010 <= iyr_int <= 2020)
        print(iyr_int, res) if verbose else None
        return res
    except:
        print(iyr, False) if verbose else None
        return False

def check_eyr(eyr, verbose=False):
    # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    try: 
        eyr_int = int(eyr)
        res = (2020 <= eyr_int <= 2030)
        print(eyr_int, res) if verbose else None
        return res
    except:
        print(eyr, False) if verbose else None
        return False

import re

def check_hgt(hgt, verbose=False):
    # hgt (Height) - a number followed by either cm or in:
    #    If cm, the number must be at least 150 and at most 193.
    #    If in, the number must be at least 59 and at most 76.
    
    # check the pattern first
    # total of 2 or three numbers
    # first number cannot be zero
    # second or third can be zero
    # match either cm or in at the end
    if not bool(re.match(r"^[1-9]{1}[0-9]{1,2}(cm|in)$", hgt)):
        print(hgt, False) if verbose else None
        return False

    try:
        val = int(hgt[:-2])
        unit = hgt[-2:]
        if unit == "cm":
            res = (150 <= val <= 193)
            print(val, unit, res) if verbose else None
            return res
        elif unit == "in":
            res = (59 <= val <= 76)
            print(val, unit, res) if verbose else None
            return res
        else:
            print(hgt, False) if verbose else None
            return False
    except:
        print(hgt, False) if verbose else None
        return False

def check_hcl(hcl, verbose=False):
    #hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    
    res = bool(re.match(r"^#[0-9a-f]{6}$", hcl))
    print(hcl, res) if verbose else None
    return res
    
def check_ecl(ecl, verbose=False):
    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    #colours = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    res = bool(re.match("^(amb|blu|brn|gry|grn|hzl|oth)$", ecl))
    print(ecl, res) if verbose else None
    return res

def check_pid(pid, verbose=False):
    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    res = bool(re.match(r"^[0-9]{9}$", pid))
    print(pid, res) if verbose else None
    return res

def process_passport_entry(passport_entry, verbose=False):
    print("\n\n", passport_entry) if verbose else None
    # split without arguments spits on all the whitespace
    # this results in a nested list of the form [[k1, v1], ...]
    split = [i.split(':') for i in passport_entry.split()]
    # generate a dictionary from this list
    p = dict(split)
    k = [i[0] for i in split]
    
    # just check if all fields are in the list, else just return False
    expected_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    fields_check = [field in k for field in expected_fields]
    if not all(fields_check):
        print([field for (field, valid) in zip(expected_fields, fields_check) if not valid], "not found") if verbose else None
        return False
    # actual checking
    # no need to do safe check like passport.get("byr", False)
    # because all keys will be there
    thecheck = (
        check_byr(p["byr"], verbose) &
        check_iyr(p["iyr"], verbose) &
        check_eyr(p["eyr"], verbose) &
        check_hgt(p["hgt"], verbose) &
        check_hcl(p["hcl"], verbose) &
        check_ecl(p["ecl"], verbose) &
        check_pid(p["pid"], verbose)
        #cid (Country ID) - ignored, missing or not.
    )
    if thecheck:
        print("passport OK") if verbose else None
        return True
    else:
        print("passport NOT OK") if verbose else None
        return False

# %%
sum([process_passport_entry(i, False) for i in passport_entries])
#[process_passport_entry(i, False) for i in passport_entries]
# %%
process_passport_entry(passport_entries[13-1], True)
# %%
#passport_entry
# %%
test_ok = [
    "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f",
    "eyr:2029 ecl:blu cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm",
    "hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022",
    "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
]

test_nok = [
    "eyr:1972 cid:100 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926",
    "iyr:2019 hcl:#602927 eyr:1967 hgt:170cm ecl:grn pid:012533040 byr:1946",
    "hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277",
    "hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007"
]
# %%
[process_passport_entry(i, False) for i in test_ok]
# %%
[process_passport_entry(i, False) for i in test_nok]
# %%
