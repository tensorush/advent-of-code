function solve()
    lines = readlines("inputs/day_03.txt")
    claims = parseClaim.(lines)
    max_dims = reduce((a, b) -> max.(a, b), claims)
    fabric = zeros(Int, max_dims[2] + max_dims[4], max_dims[3] + max_dims[5])
    for claim in claims
        fabric[claim[2]+1:claim[2]+claim[4], claim[3]+1:claim[3]+claim[5]] .+= 1
    end
    println("--- Day 3: No Matter How You Slice It ---")
    println("Part 1: $(countFabricWithinTwoOrMoreClaims(fabric))")
    println("Part 2: $(findNonOverlappingClaimId(claims, fabric))")
end

function parseClaim(line)
    parse.((Int, Int, Int, Int, Int), Tuple(match(r"#(\d*) @ (\d*),(\d*): (\d*)x(\d*)", line).captures))
end

function countFabricWithinTwoOrMoreClaims(fabric)
    sum(fabric .> 1)
end

function findNonOverlappingClaimId(claims, fabric)
    for claim in claims
        all(fabric[claim[2]+1:claim[2]+claim[4], claim[3]+1:claim[3]+claim[5]] .== 1) && return claim[1]
    end
end

solve()
