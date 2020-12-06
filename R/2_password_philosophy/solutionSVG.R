input <- read.table("data/2_password_philosophy/input.txt")
colnames(input) <- c("Amount", "Letter", "Password")

input$Letter <- gsub(":", "", input$Letter)
input$Minimum <- as.numeric(gsub("([0-9]*)-([0-9]*)", "\\1", input$Amount))
input$Maximum <- as.numeric(gsub("([0-9]*)-([0-9]*)", "\\2", input$Amount))

input$Correct <- NA
for(i in seq_len(nrow(input))){
  count <- table(strsplit(input$Password[i], ""))[input$Letter[i]]
  if(is.na(count)) count <- 0
  input[i,"Correct"] <- count >= input$Minimum[i] &  count <= input$Maximum[i]
}

print(paste0("Solution 1: ", sum(input$Correct)))


input$Correct2 <- NA
for(i in seq_len(nrow(input))){
  count <- table(strsplit(input$Password[i], "")[[1]][c(input$Minimum[i],input$Maximum[i])])[input$Letter[i]]
  if(is.na(count)) count <- 0
  input[i,"Correct2"] <- count == 1
}
print(paste0("Solution 2: ", sum(input$Correct2)))

