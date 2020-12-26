#%%
import re
import time
import sys
t0 = time.time()

#%%
fn = sys.argv[1] #"./data/day7.txt"
with open(fn, mode="r") as f:
    data = f.readlines()
# %%
data
entry = data[0]
# remove eof and dot
entry = entry.rstrip()[:-1]
# %%
matryoshka_big, matryoshka_small = entry.split(" bags contain ")
matryoshka_big, matryoshka_small
re.split('(, bags| bags|, bag|, bag)', matryoshka_small)
# %%
def process_entry(entry):
    entry = entry.rstrip()[:-1]
    matryoshka_big, matryoshka_small = entry.split(" bags contain ")
    matryoshka_big, matryoshka_small
    if matryoshka_small.startswith("no other"):
        return {matryoshka_big: set()}
    matryoshka_small_parts = re.split('( bags, | bags| bag, | bag)', matryoshka_small)
    #print(matryoshka_small_parts)
    matryoshka_small_parts.pop(-1)
    matryoshka_small_parts = matryoshka_small_parts[::2]
    #print(matryoshka_small_parts)
    matryoshka_small_parts = [re.split('([0-9]{1,} )', string)[1:] for string in matryoshka_small_parts]
    matryoshka_small_vals = [int(i[0][:-1]) for i in matryoshka_small_parts]
    matryoshka_small_types = [i[1] for i in matryoshka_small_parts]
    #print(matryoshka_small_vals)
    #print(matryoshka_small_types)
    matryoshka_small_tup = set(zip(matryoshka_small_vals, matryoshka_small_types))
    return {matryoshka_big: matryoshka_small_tup}
    
# %%
process_entry(entry)
# %%
graph = {}
[graph.update(process_entry(entry)) for entry in data];
graph
# %%
# %%
from minimumspanningtrees import edges_to_adj_list, adj_list_to_edges
# %%
edges = adj_list_to_edges(graph)
# %%
# these are of the form (number of bags, tiny bag, large bag)
#edges[0]
# %%
mybag = "shiny gold"
# %%
def get_larger_bags(bag, edges):
    return set([edge[2] for edge in edges if edge[1]==bag])
# %%
def find_larger_bags(bag_init, edges):
    larger_bags = get_larger_bags(bag_init, edges)
    # just to init
    diff = 1
    n_iter = 0
    while (diff > 0) and (n_iter < 1000):
        n_larger_bags = len(larger_bags)
        larger_bags.update(*[get_larger_bags(bag, edges) for bag in larger_bags])
        diff = len(larger_bags) - n_larger_bags
        n_iter += 1
    return larger_bags

# %%
larger_bags = find_larger_bags(mybag, edges)
# part 1
print(len(larger_bags))
print(time.time() - t0)
# %%

# %%
[(n, bag) for (n, bag) in graph[mybag]]
# %%
graph["dull white"]
# %%
len(graph["pale yellow"])


# %%
def get_smaller_bags(large_bag, verbose=False):
    # end point
    if len(graph[large_bag]) == 0:
        if verbose:
            print("terminating at: ", large_bag)
        return 0
    else:
        if verbose:
            print("digging deeper from ", large_bag, " into these bags: ", [bag for (n, bag) in graph[large_bag]])
        total_n_bags = sum([n+n*get_smaller_bags(small_bag) for (n, small_bag) in graph[large_bag]])
        if verbose:
            print("found ", total_n_bags, " bags in ", large_bag)
        return total_n_bags
    

# %%
print(get_smaller_bags(mybag))

te = time.time()
print(te-t0)
# %%
