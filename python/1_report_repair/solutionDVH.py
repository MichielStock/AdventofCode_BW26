"""
author: Daan Van Hauwermeiren
AoC: day 1
"""
import pandas as pd
import itertools
from operator import mul
from functools import reduce
import sys
import time

print("Solution 1")
t0 = time.time()
#fn = "./data/day1.txt"
fn = sys.argv[1]
with open(fn, mode="r") as f:
    data = f.readlines()
processed = [int(i.strip()) for i in data]

for i, j in itertools.combinations(processed, 2):
    if i+j==2020:
        print(i,j,i*j)
        break
t1 = time.time()
print("Executed in {0} s".format(t1-t0))
print("")

print("Solution 2")
t0 = time.time()
#fn = "./data/day1.txt"
fn = sys.argv[1]
with open(fn, mode="r") as f:
    data = f.readlines()
processed = [int(i.strip()) for i in data]
for vals in itertools.combinations(processed, 3):
    if sum(vals)==2020:
        print(*vals, reduce(mul, vals))
        break
t1 = time.time()
print("Executed in {0} s".format(t1-t0))
