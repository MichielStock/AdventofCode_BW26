# -*- coding: utf-8 -*-
"""
Created on Thu Mar 10 15:31:17 2016
Last update on Saturday 17 March 2018

@author: michielstock

Kruskal's algorithm for finding the maximum spanning tree
"""

from union_set_forest import USF
import heapq
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

blue = '#264653'
green = '#2a9d8f'
yellow = '#e9c46a'
orange = '#f4a261'
red = '#e76f51'
black = '#50514F'

def add_mst_edges(t, mst_edges, coordinates, ax):
    i, j = mst_edges[t]
    xi1, xi2 = coordinates[i]
    xj1, xj2 = coordinates[j]
    ax.plot([xi1, xj1], [xi2, xj2], color=red, lw=5, zorder=1)

def make_mst_animation(coordinates, edges, mst_edges, fig, ax):
    # plot edges graph
    for w, i, j in edges:
        xi1, xi2 = coordinates[i]
        xj1, xj2 = coordinates[j]
        ax.plot([xi1, xj1], [xi2, xj2], color='grey', alpha=0.7, lw=2, zorder=1)

    # plot points
    for x1, x2 in coordinates:
        ax.scatter(x1, x2, color=green, s=50, zorder=2)

    # make animation
    anim = FuncAnimation(fig, lambda t : add_mst_edges(t, mst_edges,
            coordinates, ax), frames=range(len(mst_edges)), interval=100)
    ax.set_yticks([])
    ax.set_xticks([])
    return anim

def edges_to_adj_list(edges):
    """
    Turns a list of edges in an adjecency list (implemented as a list).
    Edges don't have to be doubled, will automatically be symmetric

    Input:
        - edges : a list of weighted edges (e.g. (0.7, 'A', 'B') for an
                    edge from node A to node B with weigth 0.7)

    Output:
        - adj_list : a dict of a set of weighted edges
    """
    adj_list = {}
    for w, i, j in edges:
        for v in (i, j):
            if v not in adj_list:
                adj_list[v] = set([])
        adj_list[i].add((w, j))
        adj_list[j].add((w, i))
    return adj_list

def adj_list_to_edges(adj_list):
    """
    Turns an adjecency list in a list of edges (implemented as a list).

    Input:
        - adj_list : a dict of a set of weighted edges

    Output:
        - edges : a list of weighted edges (e.g. (0.7, 'A', 'B') for an
                    edge from node A to node B with weigth 0.7)
    """
    edges = []
    for v, adjacent_vertices in adj_list.items():
        for w, u in adjacent_vertices:
            edges.append((w, u, v))
    return edges

def prim(vertices, edges, start, add_weights=False):
    """
    Prim's algorithm for finding a minimum spanning tree.

    Inputs :
        - vertices : a set of the vertices of the Graph
        - edges : a list of weighted edges (e.g. (0.7, 'A', 'B') for an
                    edge from node A to node B with weigth 0.7)
        - start : an edge to start with
        - add_weights : add the weigths to the edges? default: False

    Output:
        - edges : a minumum spanning tree represented as a list of edges
                    (weighted if `add_weights` is set to True)
        - total_cost : total cost of the tree
    """
    adj_list = edges_to_adj_list(edges)
    to_check = [(w, start, v_new) for w, v_new in adj_list[start]]
    heapq.heapify(to_check)
    # for every node connected to the
    #dist_to_mst = {i : (w, start) for w, i in adj_list.pop(start)}
    mst_edges = []
    mst_vertices = set([start])
    total_cost = 0
    while to_check:
        cost, v_in_mst, v_new = heapq.heappop(to_check)
        if v_new not in mst_vertices:
            # add to mst
            if add_weights:
                mst_edges.append((cost, v_in_mst, v_new))
            else:
                mst_edges.append((v_in_mst, v_new))
            mst_vertices.add(v_new)
            total_cost += cost
            for cost, v in adj_list[v_new]:
                heapq.heappush(to_check, (cost, v_new, v))
    return mst_edges, total_cost

def kruskal(vertices, edges, add_weights=False):
    """
    Kruskal's algorithm for finding a minimum spanning tree.

    Inputs :
        - vertices : a set of the vertices of the Graph
        - edges : a list of weighted edges (e.g. (0.7, 'A', 'B') for an
                    edge from node A to node B with weigth 0.7)
        - add_weights : add the weigths to the edges? default: False

    Output:
        - edges : a minumum spanning tree represented as a list of edges
                    (weighted if `add_weights` is set to True)
        - total_cost : total cost of the tree
    """
    union_set_forest = USF(vertices)
    edges = list(edges)  # might be saved in set format...
    edges.sort()
    mst_edges = []
    total_cost = 0
    for cost, v1, v2 in edges:
        if union_set_forest.find(v1) != union_set_forest.find(v2):
            if add_weights:
                mst_edges.append((cost, v1, v2))
            else:
                mst_edges.append((v1, v2))
            union_set_forest.union(v1, v2)
            total_cost += cost
    del union_set_forest
    return mst_edges, total_cost

if __name__ == '__main__':
    """
    words = ['maan', 'laan', 'baan', 'mama', 'saai', 'zaai', 'naai', 'baai',
             'loon', 'boon', 'hoon', 'poon', 'leem', 'neem', 'peen', 'tton',
             'haar', 'haar', 'hoor', 'boor', 'hoer', 'boer', 'loer', 'poer']

    hamming = lambda w1, w2 : sum([ch1 != ch2 for ch1, ch2 in zip(w1, w2)])

    edges = [(hamming(w1, w2), w1, w2) for w1 in words
                for w2 in words if w1 is not w2]

    tree = kruskal(words, edges)
    print(tree)

    import networkx
    g = networkx.Graph()

    g.add_edges_from(tree)
    labels = {n:n for n in g.nodes()}
    networkx.draw(g, networkx.spring_layout(g))

    # draw maze

    import numpy as np

    size = 50

    M = np.random.randn(size, size)
    vertices = [(i, j) for i in range(size) for j in range(size)]
    edges = [(abs(M[i1, j1] - M[i2, j2]), (i1, j1), (i2, j2)) for i1,
             j1 in vertices for i2, j2 in vertices if abs(i1-i2) +
                abs(j1-j2) == 1  if (i1, j1) != (i2, j2)]

    maze_links = kruskal(vertices, edges)

    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(figsize=(10,10))
    ax.set_axis_bgcolor('black')

    for (i1, j1), (i2, j2) in maze_links:
        ax.plot([i1, i2], [j1, j2], c='white', lw=5)
    fig.savefig('maze.pdf')
    """

    import json
    import matplotlib.pyplot as plt

    with open('Data/example_graph.json', 'r') as fp:
        example_graph = json.load(fp)

    coordinates = example_graph['coordinates']
    edges = example_graph['edges']
    vertices = set([i for d, i, j in edges])

    edges_kruskal, cost_kruskal = kruskal(vertices, edges)
    edges = example_graph['edges']
    edges_prim, cost_prim = prim(vertices, edges, 1)

    for d, i, j in edges:
        xi1, xi2 = coordinates[i]
        xj1, xj2 = coordinates[j]
        plt.plot([xi1, xj1], [xi2, xj2], color='grey', alpha=0.7, lw=2, zorder=1)

    for i, j in edges_kruskal:
        xi1, xi2 = coordinates[i]
        xj1, xj2 = coordinates[j]
        plt.plot([xi1, xj1], [xi2, xj2], color=red, lw=5, zorder=2)

    for x1, x2 in coordinates:
        plt.scatter(x1, x2, color=green, s=50, zorder=3)

    plt.xticks([])
    plt.yticks([])

    plt.savefig('Figures/mst_example.png')

    # make animations
    fig, ax = plt.subplots()
    anim = make_mst_animation(coordinates, edges, edges_kruskal, fig, ax)
    anim.save('Figures/kruskal.gif', dpi=80, writer='imagemagick')

    fig, ax = plt.subplots()
    anim = make_mst_animation(coordinates, edges, edges_prim, fig, ax)
    anim.save('Figures/prim.gif', dpi=80, writer='imagemagick')
