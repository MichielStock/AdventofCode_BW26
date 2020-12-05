"""
Author: Thomas Mortier
"""
import re
import sys
import time

t0 = time.time()
fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
psw, cntr = "", 0

def checkField(field):
    valid = False
    if field[0] == "byr":
        valid = (1920<=int(field[1])<=2002)
    elif field[0] == "iyr": 
        valid = (2010<=int(field[1])<=2020)
    elif field[0] == "eyr":
        valid = (2020<=int(field[1])<=2030)
    elif field[0] == "hgt":
        if field[1][-2:] == "cm":
            valid = (150<=int(field[1][:-2])<=193)
        elif field[1][-2:] == "in":
            valid = (59<=int(field[1][:-2])<=76)
    elif field[0] == "hcl":
        valid = bool(re.match('^#[0-9a-f]{6}$',field[1]))
    elif field[0] == "ecl":
        valid = bool(re.match('^(amb|blu|brn|gry|grn|hzl|oth)$',field[1]))
    elif field[0] == "pid":
        valid = bool(re.match('^[0-9]{9}$',field[1]))
    elif field[0] == "cid":
        valid = True
    return valid 

def checkPsw(psw):
    global fields
    idvals = [tuple(t.split(":")) for t in psw.split(" ")]
    valid, found = True, False
    for f in fields:
        found = False
        for fid, fval in idvals:
            if f == fid:
                found = True
            valid = checkField((fid,fval))
            if not valid:
                break
        if not valid or not found:
            break
    return valid and found

for line in open(sys.argv[1],'r'):
    line_str = line.strip()
    if line_str=="":
        cntr += checkPsw(psw[:-1])
        psw = ""
    else:
        psw += line.strip() + ' '
else:
    cntr += checkPsw(psw[:-1])
t1 = time.time()
print(cntr)
print("Executed in {0} s".format(t1-t0))
