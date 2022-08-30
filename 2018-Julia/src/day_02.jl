function solve()
    candidates = readlines("inputs/day_02.txt")
    println("--- Day 2: Inventory Management System ---")
    println("Part 1: $(findChecksum(candidates))")
    println("Part 2: $(findCommonLetters(candidates))")
end

function findChecksum(candidates)
    hasReps(values, numReps) = any(map(value -> sum(collect(values) .== value) == numReps, collect(values)))
    sum(hasReps.(candidates, 2)) * sum(hasReps.(candidates, 3))
end

function findCommonLetters(candidates)
    for candidate1 in candidates, candidate2 in candidates
        letters1 = collect(candidate1)
        letters2 = collect(candidate2)
        sum(letters1 .!= letters2) == 1 && return String(letters1[letters1.==letters2])
    end
end

solve()
