import numpy as np
import time, sys

lines = None
with open(sys.argv[1]) as file:
    lines = file.read().splitlines()
    
def translate(char):
    if char == "L":
        return 0
    elif char == "#":
        return 1
    elif char == ".":
        return 99

def build1():
    grid = np.zeros((len(lines), len(lines[0])))
    for i in range(len(lines)):
        for j in range(len(lines[0])):
            grid[i][j] = translate(lines[i][j])
                
    fields = []
    for y in range(grid.shape[0]):
        for x in range(grid.shape[1]):
            if grid[y][x] != 99:
                watch = []
                for i in range(max(0, y-1), min(grid.shape[0], y+2)):
                    for j in range(max(0, x-1), min(grid.shape[1], x+2)):
                        if grid[i][j] != 99 and (y != i or x != j):
                            watch.append((i,j))
                fields.append(((y,x), watch))
    
    return grid, fields

def build2():
    grid = np.zeros((len(lines), len(lines[0])))
    for i in range(len(lines)):
        for j in range(len(lines[0])):
            grid[i][j] = translate(lines[i][j])
    
    link = []
    for y in range(len(lines)):
        for x in range(len(lines[0])):
            if grid[y][x] != 99:
                watch = []
                for i in range(x-1, -1, -1):
                    if grid[y][i] != 99:
                        watch.append((y,i))
                        break
                for i in range(x+1, grid.shape[1]):
                    if grid[y][i] != 99:
                        watch.append((y,i))
                        break
                for i in range(y-1, -1, -1):
                    if grid[i][x] != 99:
                        watch.append((i,x))
                        break
                for i in range(y+1, grid.shape[0]):
                    if grid[i][x] != 99:
                        watch.append((i,x))
                        break

                for i in range(1, min(x+1, y+1)):
                    if grid[y-i][x-i] != 99:
                        watch.append((y-i,x-i))
                        break
                for i in range(1, min(grid.shape[1]-x, y+1)):
                    if grid[y-i][x+i] != 99:
                        watch.append((y-i,x+i))
                        break
                for i in range(1, min(x+1, grid.shape[0]-y)):
                    if grid[y+i][x-i] != 99:
                        watch.append((y+i,x-i))
                        break
                for i in range(1, min(grid.shape[1]-x, grid.shape[0]-y)):
                    if grid[y+i][x+i] != 99:
                        watch.append((y+i,x+i))
                        break
                link.append(((y,x), watch))
                
    return grid, link

def update(current, linked, grid, threshold):
    
    cnt = 0
    for y,x in linked:
        cnt += grid[y][x]
    
    if cnt == 0:
        return 1
    elif cnt >= threshold:
        return 0
    else:
        return current

#
# First exercise
#

a = time.perf_counter()

grid, fields = build1()

changed = True
while changed:
    changed = False
    temp = np.zeros(grid.shape)
    for field in fields:
        i, j = field[0]
        temp[i][j] = update(grid[i][j], field[1], grid, 4)
        changed = (changed or temp[i][j] != grid[i][j])
    grid = temp
    
print("Result 1:", np.sum(grid == 1))

b = time.perf_counter()
print("Runtime:", b-a, "\n\n")

#
# Second exercise
#

a = time.perf_counter()

grid, links = build2()

changed = True
counter = 0
while changed:
    changed = False
    temp = np.zeros(grid.shape)
    for field in links:
        i, j = field[0]
        temp[i][j] = update(grid[i][j], field[1], grid, 5)
        changed = (changed or temp[i][j] != grid[i][j])
    grid = temp
    
print("Result 2:", np.sum(grid == 1))

b = time.perf_counter()
print("Runtime:", b-a)