input <- read.table("data/6_custom_customs/input.txt",
                    comment.char = "", sep = "\n", blank.lines.skip = FALSE)[,1]

answers <- paste(input, collapse = " ")
answers <- strsplit(answers, split = "  ")[[1]]

nQuestions <- sapply(answers, function(x){
  counts <- table(strsplit(x, ""))
  if(" " %in% names(counts)) length(counts) - 1
  else length(counts)
})

print(paste0("Solution 1: ", sum(nQuestions)))


nQuestions <- sapply(answers, function(x){
  counts <- table(strsplit(x, ""))
  nAnswers <- stringr::str_count(x, " ") + 1
  sum(counts == nAnswers)
})

print(paste0("Solution 2: ", sum(nQuestions)))
