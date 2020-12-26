"""
author: Daan Van Hauwermeiren
AoC: day 2
"""
import sys
import time

print("Solution 1")
t0 = time.time()
#fn = "./data/day2.txt"
fn = sys.argv[1]
with open(fn, mode="r") as f:
    data = f.readlines()

# %%
"""
password requirements are of the form

    a-b c

with a the min, b the max number of repetitions
c a char
"""
# %%
def splitentry(entry, verbose=False):
    rule, pwd = entry.split(':')
    # remove whitespace
    pwd = pwd.strip()
    bound, character = rule.split(' ')
    lb, ub = [int(i) for i in bound.split('-')]
    reps = len([i for i in pwd if i==character])
    if verbose:
        print(lb, ub, character, pwd)
    if (lb <= reps) & (reps <= ub):
        return True
    else:
        return False
# %%
sum([splitentry(i) for i in data])
t1 = time.time()
print("Executed in {0} s".format(t1-t0))
print("")


print("Solution 2")
t0 = time.time()
# %%
def splitentry_part2(entry, verbose=False):
    rule, pwd = entry.split(':')
    # remove whitespace
    pwd = pwd.strip()
    bound, character = rule.split(' ')
    lb, ub = [int(i) for i in bound.split('-')]
    #print(pwd[lb-1], pwd[ub-1])
    if sum((pwd[lb-1]==character, pwd[ub-1]==character)) == 1:
        return True
    else:
        return False

# %%
sum([splitentry_part2(i) for i in data])
# %%
t1 = time.time()
print("Executed in {0} s".format(t1-t0))
