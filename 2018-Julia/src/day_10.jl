using Plots

function solve()
    lines = readlines("inputs/day_10.txt")
    points = parsePoint.(lines)
    println("--- Day 10: The Stars Align ---")
    println("Part 1: $(printMessage(points, true))")
    println("Part 2: $(printMessage(points, false))")
end

function parsePoint(line)
    parse.(Float64, Tuple(match(r"position=< *(-?\d*), *(-?\d*)> velocity=< *(-?\d*), *(-?\d*)>", line).captures))
end

function printMessage(points, is_part1)
    positions = getindex.(points, [1 2])
    velocities = getindex.(points, [3 4])
    seconds = round(([-velocities[:, 2] ones(length(points))]\positions[:, 2])[1])
    @. positions += seconds * velocities
    if is_part1
        plot(positions[:, 1], -positions[:, 2], seriestype=:scatter, aspect_ratio=1, legend=false)
        gui()
        return :solution_has_been_plotted
    else
        Int(seconds)
    end
end

solve()
