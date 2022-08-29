import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_11.txt")
    print("--- Day 11: Hex Ed ---")
    print("Part 1: \(findSolution(input).end.distance)")
    print("Part 2: \(findSolution(input).max.distance)")
}

struct Coordinate {
    var x = 0
    var y = 0
    var z = 0

    var distance: Int {
        return [abs(x), abs(y), abs(z)].max()!
    }
}

func findSolution(_ path: String) -> (end: Coordinate, max: Coordinate) {
    return path
        .components(separatedBy: ",")
        .reduce((Coordinate(), Coordinate())) {
            var new: Coordinate
            switch $1 {
            case "n": new = Coordinate(x: $0.0.x, y: $0.0.y + 1, z: $0.0.z - 1)
            case "ne": new = Coordinate(x: $0.0.x + 1, y: $0.0.y, z: $0.0.z - 1)
            case "se": new = Coordinate(x: $0.0.x + 1, y: $0.0.y - 1, z: $0.0.z)
            case "s": new = Coordinate(x: $0.0.x, y: $0.0.y - 1, z: $0.0.z + 1)
            case "sw": new = Coordinate(x: $0.0.x - 1, y: $0.0.y, z: $0.0.z + 1)
            case "nw": new = Coordinate(x: $0.0.x - 1, y: $0.0.y + 1, z: $0.0.z)
            default: new = $0.0
            }
            return (new, new.distance > $0.1.distance ? new : $0.1)
    }
}

solve()
