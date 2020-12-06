library(microbenchmark)

solution_files <- list.files("R",
                        recursive = TRUE,
                        full.names = TRUE)

solution_tasks <- basename(dirname(solution_files))
solution_participants <- gsub("solution(.*).R", "\\1", basename(solution_files))

benchmark <- matrix(NA,
                    nrow = length(unique(solution_tasks)),
                    ncol = length(unique(solution_participants)),
                    dimnames = list(unique(solution_tasks),
                                    unique(solution_participants)))

for(i in seq_along(solution_files)){
  timing <- microbenchmark({myEnv <- new.env(); source(solution_files[i], local = myEnv)},
                           times = 10)
  benchmark[solution_tasks[i], solution_participants[i]] <- mean(timing$time) / 1e9
}

write.csv(benchmark,
          "benchmarking/reports/R.csv")
