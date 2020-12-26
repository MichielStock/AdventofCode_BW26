# -*- coding: utf-8 -*-
"""
Created on Thu Mar 10 13:48:17 2016

@author: michielstock

Implementation of an union-set forest for MST algorithms
"""
        
class USF():
    def __init__(self, nodes):
        # save data with for each node no parent and
        # a rank of 0
        self._parent = {node : node for node in nodes}
        self._rank = {node : 0 for node in nodes}
    
    def find(self, x):
        if self._parent[x] is not x:
            self._parent[x] = self.find(self._parent[x])
        return self._parent[x]
            
    def union(self, x, y):
        xRoot = self.find(x)
        yRoot = self.find(y)
        if xRoot == yRoot:
            return
        if self._rank[xRoot] < self._rank[yRoot]:
            self._parent[xRoot] = yRoot
        elif self._rank[xRoot] > self._rank[yRoot]:
            self._parent[yRoot] = xRoot
        else:
            self._parent[yRoot] = xRoot
            self._rank[xRoot] += 1
            
if __name__ == '__main__':
    a_list = [a for a in range(20)]
    usf = USF(a_list)
    
    # parents of 10 and 5 differ
    print(usf.find(10))
    print(usf.find(5))
    
    # union (10, 5) and (3, 10)
    usf.union(10, 5)
    usf.union(3, 10)
    
    # now 5 and 3 are also in same set
    print(usf.find(5))
    print(usf.find(3))
    
    words = ['aap', 'banaan', 'kaviaar', 'nijlpaard', 'wortel']
    usf_words = USF(words)
    usf_words.union('banaan', 'wortel')
    usf_words.union('banaan', 'kaviaar')
    usf_words.union('aap', 'nijlpaard')
    for w in words:
        print(w, usf_words.find(w))