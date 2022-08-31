function solve()
    line = readline("inputs/day_08.txt")
    nodes = parse.(Int, split(line, " "))
    metadata_sum = sumMetadata(nodes, 1)
    println("--- Day 8: Memory Maneuver ---")
    println("Part 1: $(metadata_sum[2])")
    println("Part 2: $(metadata_sum[3])")
end

function sumMetadata(nodes, i)
    metadata_sum = 0
    metadata_index = i + 2
    num_children = nodes[i]
    metadata_size = nodes[i+1]
    metadata_sums = zeros(Int, num_children)
    for child_index in 1:num_children
        (metadata_index, children_metadata_sum, metadata_sums[child_index]) = sumMetadata(nodes, metadata_index)
        metadata_sum += children_metadata_sum
    end
    rest_metadata = nodes[metadata_index:metadata_index+metadata_size-1]
    (metadata_index + metadata_size, metadata_sum + sum(rest_metadata), sum(child_index -> isempty(metadata_sums) ? child_index : checkbounds(Bool, metadata_sums, child_index) ? metadata_sums[child_index] : 0, rest_metadata))
end

solve()
