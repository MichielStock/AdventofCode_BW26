fn = "./data/day6.txt"
data = read(fn, String)



# blank lines between groups, so split on double line breaks
records_raw = split(data, "\n\n")
# records is an array of Sets with element type Char
records = Set{Char}[]
for record_group in records_raw
    # remove the single line breaks between different persons
    # convert the string to a Set of Chars to get the unique answers
    # push to the results
    push!(records, Set(replace(record_group, "\n"=>"")))
end
records
# answer to the first question
sum(length.(records))

"""
a less naive way to do this

read data into a String
split string on the linebreak = double newline
strip linebreak at the end
remove the linebreaks (we still have strings for each entry)
pipe each string to a set
get the length of each set
make the sum
FUCK YEAH oneliner
"""
#
read(fn, String) |> (x -> split(x, "\n\n")) .|> rstrip .|> (x -> replace(x, "\n"=>"")) .|> Set .|> length |> sum


# records is an array of arrays with element type Char
records = Array{Char}[]
for record_group in records_raw
    # applying rstrip first to avoid having issues with the last linebreak at the eof
    # split the records on the line breaks
    # no we have a vector of strings
    # we need to find the chars that occurr in every string
    # So we need to intersect every set with ∩
    # I assume that every string is a set: I guess this will be ok
    # applying the intersect between every list can be done by applying reduce
    push!(records, collect(reduce(∩, split(rstrip(record_group), "\n"))))
end
records
# answer to the second question
sum(length.(records))


"""
a less naive way to do this

read data into a String
split string on the linebreak = double newline
strip linebreak at the end
split each string on the linebreak
reduce the array of strings with intersect to get an array of unique chars
compute length
take the sum
FUCK YEAH oneliner
"""
#
read(fn, String) |> (x -> split(x, "\n\n")) .|> rstrip .|> (x -> split(x, "\n")) .|> (x -> reduce(∩, x)) .|> length |> sum