"""
Author: Thomas Mortier
"""
import sys
import time
import numpy as np

t0 = time.time()
slopes = [(1,1),(3,1),(5,1),(7,1),(1,2)]
ind, cntr = [0]*len(slopes), [0]*len(slopes)
l = 0
for i, line in enumerate(open(sys.argv[1],'r')):
    line_str = line.strip()
    if l == 0: l = len(line_str)
    for j, s in enumerate(slopes): 
        if line_str[ind[j]] == '#' and i%s[1]==0: cntr[j] += 1
        if i%s[1]==0: ind[j] = (ind[j]+s[0])%l
t1 = time.time()
print("{0} {1}".format(cntr[1],np.prod(cntr)))
print("Executed in {0} s".format(t1-t0))
