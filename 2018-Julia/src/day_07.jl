function solve()
    lines = readlines("inputs/day_07.txt")
    instructions = parseInstruction.(lines)
    println("--- Day 7: The Sum of Its Parts ---")
    println("Part 1: $(findInstructionOrder(instructions, true, 1))")
    println("Part 2: $(findInstructionOrder(instructions, false, 5))")
end

function parseInstruction(line)
    first.(Tuple(match(r"Step (.) must be finished before step (.) can begin.", line).captures))
end

function findInstructionOrder(instructions, is_part1, num_workers)
    orders = Vector{Union{Char,Nothing}}(nothing, num_workers)
    letters = unique(Iterators.flatten(instructions))
    instructions_copy = copy(instructions)
    durations = fill(0, num_workers)
    getBeforeStep(x) = x[2]
    order = Char[]
    while true
        duration = minimum(durations)
        for i in findall(durations .== duration)
            filter!(instruction -> first(instruction) != orders[i], instructions_copy)
            before_steps = unique(getBeforeStep.(instructions_copy))
            independent_letters = setdiff(letters, before_steps)
            if isempty(independent_letters)
                orders[i] = nothing
                durations[i] = minimum(durations[orders.!==nothing])
            else
                orders[i] = minimum(independent_letters)
                push!(order, orders[i])
                durations[i] = duration + 61 + orders[i] - 'A'
                filter!(!isequal(orders[i]), letters)
                isempty(letters) && return is_part1 ? String(order) : maximum(durations)
            end
        end
    end
end

solve()
