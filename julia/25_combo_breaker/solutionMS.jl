#=
Author: Michiel Stock
AoC: day 25

Opening the blasted door!
=#

const prime = 20201227

function compute_public_key(subject_number, loopsize)
    x = 1
    for l in 1:loopsize
        x = (x * subject_number) % prime
    end
    return x
end

function find_loopsize(public_key, subject_number)
    x = 1
    loopsize = 1
    while true
        x = (x * subject_number) % prime
        x == public_key && return loopsize
        loopsize += 1
    end
end

card_pubkey = 10212254
door_pubkey = 12577395

door_loopnumber = find_loopsize(door_pubkey, 7)

encryption_key = compute_public_key(card_pubkey, door_loopnumber)
