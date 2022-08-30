function solve()
    changes = parse.(Int, readlines("inputs/day_01.txt"))
    println("--- Day 1: Chronal Calibration ---")
    println("Part 1: $(findResultingFrequency(changes))")
    println("Part 2: $(findRepeatingFrequency(changes))")
end

function findResultingFrequency(changes)
    sum(changes)
end

function findRepeatingFrequency(changes)
    frequency = 0
    seen = Set(frequency)
    for change in Iterators.cycle(changes)
        frequency += change
        frequency ∈ seen && return frequency
        push!(seen, frequency)
    end
end

solve()
