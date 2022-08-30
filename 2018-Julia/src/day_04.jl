function solve()
    lines = readlines("inputs/day_04.txt")
    records = parseRecord.(sort(lines))
    println("--- Day 4: Repose Record ---")
    println("Part 1: $(multiplyGuardIdByMinute(records, true))")
    println("Part 2: $(multiplyGuardIdByMinute(records, false))")
end

function parseRecord(line)
    matched_record = match(r"\[\d*-\d*-\d* \d*:(\d*)\] (.*)", line)
    cur_minute = parse(Int, matched_record.captures[1])
    if (matched_guard_id = match(r"Guard #(\d*) begins shift", matched_record.captures[2])) !== nothing
        guard_id = parse(Int, matched_guard_id.captures[1])
        (sleep_minutes, _, _) -> begin
            haskey(sleep_minutes, guard_id) || (sleep_minutes[guard_id] = zeros(Int, 60))
            (-1, guard_id)
        end
    elseif matched_record.captures[2] == "falls asleep"
        (_, _, guard_id) -> (cur_minute, guard_id)
    else
        (sleep_minutes, sleep_minute, guard_id) -> begin
            sleep_minutes[guard_id][(sleep_minute+1):cur_minute] .+= 1
            (-1, guard_id)
        end
    end
end

function multiplyGuardIdByMinute(records, is_part1)
    sleep_minutes = Dict{Int,Vector{Int}}()
    (sleep_minute, guard_id) = records[1](sleep_minutes, -1, 0)
    for f in records[2:end]
        (sleep_minute, guard_id) = f(sleep_minutes, sleep_minute, guard_id)
    end
    sleep_aggregates = Dict([key => (is_part1 ? sum(value) : maximum(value)) for (key, value) in sleep_minutes])
    chosen_guard_id = argmax(sleep_aggregates)
    chosen_guard_id * (argmax(sleep_minutes[chosen_guard_id]) - 1)
end

solve()
