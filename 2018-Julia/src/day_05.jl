function solve()
    line = readline("inputs/day_05.txt")
    polymer = collect(line)
    println("--- Day 5: Alchemical Reduction ---")
    println("Part 1: $(countRemainingUnits(polymer, true))")
    println("Part 2: $(countRemainingUnits(polymer, false))")
end

function countRemainingUnits(polymer, is_part1)
    if is_part1
        react(polymer)
    else
        minimum(react.((polymer,), 'A':'Z'))
    end
end

function react(polymer, skip=nothing)
    stack = Char[]
    for unit in polymer
        uppercase(unit) == skip && continue
        if !isempty(stack) && abs(stack[end] - unit) == 32
            pop!(stack)
        else
            push!(stack, unit)
        end
    end
    length(stack)
end

solve()
