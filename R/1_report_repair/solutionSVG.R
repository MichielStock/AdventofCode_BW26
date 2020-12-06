input <- read.table("data/1_report_repair/input.txt")[,1]

solutions <- list()
for(i in seq_len(length(input))[-1]){
  shifted <- input[c(i:length(input),1:(i-1))]
  id <- which(input + shifted == 2020)
  if(length(id) > 0)
    solutions[[length(solutions) + 1]] <- c(a = input[id], b = shifted[id])
}

print(paste0("Solution 1: ", prod(solutions[[1]])))


solutions <- list()
for(i in seq_len(length(input))[-1]){
  shifted <- input[c(i:length(input),1:(i-1))]
  for(j in seq_len(length(input))[-1]){
    shifted2 <- input[c(j:length(input),1:(j-1))]
    id <- which(input + shifted + shifted2 == 2020)
    if(length(id) > 0)
      solutions[[length(solutions) + 1]] <- c(a = input[id],
                                              b = shifted[id],
                                              c = shifted2[id])
  }
}

print(paste0("Solution 2: ", prod(solutions[[1]])))
