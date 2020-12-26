#=
author: Daan Van Hauwermeiren
AoC: day 8
=#
using Pkg
Pkg.activate(".")

using DelimitedFiles
fn = "./data/day8.txt"
data = readdlm(fn, String)


function parse_instruction(operation::String, argument::String, idx::Int64,
    accumulator::Int64)
    if operation == "nop"
        idx += 1
    elseif operation == "acc"
        idx += 1
        accumulator += parse(Int64, argument)
    elseif operation == "jmp"
        idx += parse(Int64, argument)
    else
        ErrorException("operation not recognised")
    end
    return idx, accumulator
end


function parse_sourcecode_part1(sourcecode::Array{String,2}, verbose::Bool=false)
    # start code at one
    idx = one(Int64)
    # init accumulator
    accumulator = zero(Int64)
    n_instructions = size(sourcecode)[1]
    # array with how much each line of code is executed
    has_been_executed = zeros(Bool, n_instructions)

    while has_been_executed[idx] == false
        has_been_executed[idx] = true
        idx, accumulator = parse_instruction(sourcecode[idx,:]..., idx, accumulator)
        if verbose
            @show idx, accumulator
        end
        if idx > n_instructions
            print("terminated")
            break
        end
    end
    accumulator, has_been_executed
end

parse_sourcecode_part1(data, true)



function parse_sourcecode(sourcecode::Array{String,2}, verbose::Bool=false)
    # start code at one
    idx = one(Int64)
    # init accumulator
    accumulator = zero(Int64)
    n_instructions = size(sourcecode)[1]
    # array with how much each line of code is executed
    has_been_executed = zeros(Bool, n_instructions)

    terminated = false
    while has_been_executed[idx] == false
        has_been_executed[idx] = true
        idx, accumulator = parse_instruction(sourcecode[idx,:]..., idx, accumulator)
        if verbose
            @show idx, accumulator
        end
        if idx == n_instructions
            terminated = true
            break
        end
    end
    #@show terminated
    return terminated, accumulator
end


function parse_sourcecode_fixit(sourcecode::Array{String,2}, verbose::Bool=false)
    parse_sourcecode(sourcecode, verbose)
    
    operation_flipper = Dict("jmp"=>"nop", "nop"=>"jmp")

    for (idx, operation) in enumerate(sourcecode[:,1])
        #@show idx, operation
        if (operation == "jmp") ! (operation == "nop")
            sourcecode_altered = copy(sourcecode)
            new_operation = operation
            for pattern in operation_flipper
                new_operation = replace(new_operation, pattern)
            end
            #@show new_operation
            sourcecode_altered[idx, 1] = new_operation
            terminated, accumulator = parse_sourcecode(sourcecode_altered, verbose)
            if terminated
                return idx, accumulator
            end
        end
    end

end

parse_sourcecode_fixit(data, false)
