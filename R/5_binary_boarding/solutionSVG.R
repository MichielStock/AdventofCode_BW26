input <- read.table("data/5_binary_boarding/input.txt")[,1]

decode <- function(code){
  length <- nchar(code)
  char <- substr(code, length, length)
  if(char == "B" | char == "R"){
    val <- 1
  } else {
    val <- 0
  }
  if(length > 1){
    res <- decode(substr(code, 1, length-1))*2 + val
  } else {
    res <- val
  }
  res
}

row <- substr(input, 1, 7)
row <- sapply(row, decode)

col <- substr(input, 8, 10)
col <- sapply(col, decode)

seatID <- row * 8 + col

print(paste0("Solution 1: ", max(seatID)))

seatID <- sort(seatID)
seat_free <- which(diff(seatID)>1)
print(paste0("Solution 2: ", seatID[seat_free]+1))
