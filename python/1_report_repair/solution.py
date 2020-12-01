"""
Author: Thomas Mortier
"""
import sys
import time
from itertools import product

"""Solution 1: nested iterators
"""
print("Solution 1: nested iterators")
t0 = time.time()
num = list(map(int, open(sys.argv[1],'r')))
s1, s2 = None, None
for x,(y,z) in product(num,product(num,num)):
    if y+z == 2020:
        s1 = y*z
    if x+y+z == 2020:
        s2 = x*y*z
    if s1 != None and s2 != None:
        print("{0} {1}".format(s1,s2))
        break
t1 = time.time()
print("Executed in {0} s".format(t1-t0))
print("")

"""Solution 2: nested for-loops 
"""
print("Solution 2: nested for-loops")
t0 = time.time()
num = list(map(int, open(sys.argv[1],'r')))
s1, s2 = None, None
for i in range(len(num)-2):
    for j in range(i+1,len(num)-1):
        for k in range(j+1,len(num)):
            x, y, z = num[i], num[j], num[k]
            if x+y == 2020:
                s1 = x*y
            if x+y+z == 2020:
                s2 = x*y*z
            if s1 != None and s2 != None:
                break
        if s1 != None and s2 != None:
            break
    if s1 != None and s2 != None:
        break
print("{0} {1}".format(s1,s2))
t1 = time.time()
print("Executed in {0} s".format(t1-t0))
