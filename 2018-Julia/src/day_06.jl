using OffsetArrays

function solve()
    lines = readlines("inputs/day_06.txt")
    coordinates = parseCoordinate.(lines)
    (min_x, min_y) = reduce((a, b) -> min.(a, b), coordinates)
    (max_x, max_y) = reduce((a, b) -> max.(a, b), coordinates)
    min_distances = OffsetArray{Int,2}(undef, min_x:max_x, min_y:max_y)
    cartesian_indices = Tuple.(CartesianIndices(min_distances))
    println("--- Day 6: Chronal Coordinates ---")
    println("Part 1: $(findMaxFiniteAreaSize(coordinates, min_distances, cartesian_indices, min_x, min_y, max_x, max_y))")
    println("Part 2: $(findDesiredRegionSize(coordinates, min_distances, cartesian_indices, 10_000))")
end

function parseCoordinate(line)
    parse.((Int, Int), Tuple(match(r"(\d*), (\d*)", line).captures))
end

function findMaxFiniteAreaSize(coordinates, min_distances, cartesian_indices, min_x, min_y, max_x, max_y)
    closest_coordinates = similar(min_distances)
    distances = similar(min_distances)
    min_distances .= typemax(Int)
    for i in eachindex(coordinates)
        coordinate = coordinates[i]
        @. distances = computeManhattanDistance(cartesian_indices, (coordinate,))
        @. closest_coordinates = ifelse(distances < min_distances, i, ifelse(distances == min_distances, -1, closest_coordinates))
        @. min_distances = min(min_distances, distances)
    end
    findAreaSizes(i) = any(closest_coordinates[[min_x, max_x], :] .== i) || any(closest_coordinates[:, [min_y, max_y]] .== i) ? -1 : sum(closest_coordinates .== i)
    maximum(findAreaSizes.(eachindex(coordinates)))
end

function findDesiredRegionSize(coordinates, min_distances, cartesian_indices, total_distance)
    min_distances .= 0
    for coordinate in coordinates
        @. min_distances += computeManhattanDistance(cartesian_indices, (coordinate,))
    end
    sum(min_distances .< total_distance)
end

function computeManhattanDistance(a, b)
    sum(@. abs(a - b))
end

solve()
