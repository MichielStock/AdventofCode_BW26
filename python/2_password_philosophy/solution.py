"""
Author: Thomas Mortier
"""
import sys
import time

t0 = time.time()
cntr1, cntr2 = 0, 0
for line in open(sys.argv[1],'r'):
    line_str_spl = line.strip().split(" ")
    line_str_spl_1 = line_str_spl[0].split("-")
    l, h = int(line_str_spl_1[0]), int(line_str_spl_1[1])
    c = line_str_spl[1][:-1]
    psw = line_str_spl[-1] 
    cnt_dict = dict((c,0) for c in set(psw))
    for ci in psw: cnt_dict[ci]+=1
    if c in cnt_dict: cntr1+=int((l<=cnt_dict[c]<=h))
    cntr2+=((psw[l-1]==c)+(psw[h-1]==c)==1)
t1 = time.time()
print("{0} {1}".format(cntr1,cntr2))
print("Executed in {0} s".format(t1-t0))
