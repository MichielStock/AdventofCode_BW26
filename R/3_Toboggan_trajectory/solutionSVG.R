input <- read.table("data/3_Tobbogan_trajectory/input.txt", sep = "", comment.char = "")[,1]
input <- strsplit(input, split = "")

x_coor <- seq(1, by = 3, length.out = length(input))
x_coor <- x_coor %% length(input[[1]])
x_coor[x_coor == 0] <- length(input[[1]])

count <- 0
for(i in seq_along(input)){
  char <- input[[i]][x_coor[i]]
  if(char == "#")
    count <- count + 1
}


print(paste0("Solution 1: ", count))

paths <- list(list(x = 1, y = 1),
              list(x = 3, y = 1),
              list(x = 5, y = 1),
              list(x = 7, y = 1),
              list(x = 1, y = 2))
counts <- sapply(paths, function(path){
  x_coor <- seq(1, by = path$x, length.out = length(input)/path$y)
  x_coor <- x_coor %% length(input[[1]])
  x_coor[x_coor == 0] <- length(input[[1]])
  count <- 0
  y <- 1
  for(i in seq_along(x_coor)){
    char <- input[[y]][x_coor[i]]
    if(char == "#")
      count <- count + 1
    y <- y + path$y
  }
  count
})
print(paste0("Solution 2: ", prod(counts)))
