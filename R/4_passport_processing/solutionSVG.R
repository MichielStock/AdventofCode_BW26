input <- read.table("data/4_passport_processing/input.txt",
                    comment.char = "", sep = "\n", blank.lines.skip = FALSE)[,1]

passports <- paste(input, collapse = " ")
passports <- strsplit(passports, split = "  ")[[1]]

required <- c("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")

checks <- sapply(required, function(field) grep(field, passports))
counts <- table(table(unlist(checks)))
print(paste0("Solution 1: ", counts["7"]))

required <- c("byr" = function(x) {as.numeric(x) >= 1920 & as.numeric(x) <= 2002},
              "iyr" = function(x) {as.numeric(x) >= 2010 & as.numeric(x) <= 2020},
              "eyr" = function(x) {as.numeric(x) >= 2020 & as.numeric(x) <= 2030},
              "hgt" = function(x) {
                value = as.numeric(gsub("([0-9]*)(.*)", "\\1", x))
                unit = gsub("([0-9]*)(.*)", "\\2", x)
                if(unit == "cm"){
                  value >= 150 & value <= 193
                } else if (unit == "in") {
                  value >= 59 & value <=76
                } else {
                  FALSE
                }},
              "hcl" = function(x) {length(grep("^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$",
                                               x)) == 1},
              "ecl" = function(x) {x %in% c("amb", "blu", "brn", "gry",
                                            "grn", "hzl", "oth")},
              "pid" = function(x) {nchar(x) == 9 & length(grep("^[0-9]*$", x) == 1)})

checks <- sapply(passports, function(passport){
  checks <- sapply(names(required), function(field){
    if(length(grep(field, passport)) > 0){
      value <- gsub(paste0(".*",field,":([^ ]*).*"), "\\1", passport)
      required[[field]](value)
    } else {
        FALSE
    }
  })
  checks #all(checks)
})

print(paste0("Solution 2: ", sum(apply(checks, 2, all))))

