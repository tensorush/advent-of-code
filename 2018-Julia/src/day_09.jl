function solve()
    line = readline("inputs/day_09.txt")
    (num_players, last_marble_worth) = parse.(Int, Tuple(match(r"(\d*) players; last marble is worth (\d*) points", line).captures))
    println("--- Day 8: Marble Mania ---")
    println("Part 1: $(findWinningScore(num_players, last_marble_worth, true))")
    println("Part 2: $(findWinningScore(num_players, last_marble_worth, false))")
end

mutable struct Marble
    value::Int
    prev::Marble
    next::Marble

    function Marble(number)
        marble = new(number)
        marble.prev = marble
        marble.next = marble
        marble
    end
end


function findWinningScore(num_players, last_marble_worth, is_part1)
    score = zeros(Int, num_players)
    cur_marble = Marble(0)
    for lowest_marble in Marble.(1:(is_part1 ? last_marble_worth : 100 * last_marble_worth))
        if mod(lowest_marble.value, 23) == 0
            for _ in 1:7
                cur_marble = cur_marble.prev
            end
            score[mod(lowest_marble.value, num_players)+1] += cur_marble.value + lowest_marble.value
            sequenceMarbles(cur_marble.prev, cur_marble.next)
            cur_marble = cur_marble.next
        else
            cur_marble = cur_marble.next
            sequenceMarbles(lowest_marble, cur_marble.next)
            sequenceMarbles(cur_marble, lowest_marble)
            cur_marble = lowest_marble
        end
    end
    maximum(score)
end

function sequenceMarbles(a, b)
    a.next = b
    b.prev = a
end

solve()
