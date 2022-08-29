import Foundation

func solve() {
    let input = "nbysizxe"
    let squares = parseDisk(input)
    print("--- Day 14: Disk Defragmentation ---")
    print("Part 1: \(squares.count)")
    print("Part 2: \(countRegions(squares))")
}

func countRegions(_ squares: [Square]) -> Int {
    var regions = Set<Set<Square>>()
    var allSquares = Set(squares)
    repeat {
        let region = findRegion(allSquares.first!, allSquares)
        for square in region {
            allSquares.remove(square)
        }
        regions.insert(region)
    } while !allSquares.isEmpty
    return regions.count
}

extension String {
    func padLeft (_ totalWidth: Int, _ with: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }

    func knotHash() -> [Int] {
        let lengths = self
            .map { Int($0.unicodeScalars.filter({ $0.isASCII }).first!.value) } + [17, 31, 73, 47, 23]
        var list = Array(0...255)
        var skipSize = 0
        var currentPosition = 0
        for _ in 0..<64 {
            for length in lengths {
                var endIndex = currentPosition+length - 1
                for p in currentPosition..<(currentPosition+length / 2) {
                    let t = list[p % list.count]
                    list[p % list.count] = list[endIndex % list.count]
                    list[endIndex % list.count] = t
                    endIndex -= 1
                }
                currentPosition += length + skipSize
                skipSize += 1
            }
        }
        let sparseHash = list
        return (0..<16).map {
            let start = $0 * 16
            let range = sparseHash[start..<start+16]
            return range.reduce(0) { $0 ^ $1 }
        }
    }
}

struct Square {
    var x: Int
    var y: Int
}

func parseDisk(_ key: String) -> [Square] {
    return (0..<128).map { (row) -> [Square] in
        "\(key)-\(row)"
            .knotHash()
            .map { String($0, radix: 2).padLeft(8, "0") }
            .joined()
            .enumerated()
            .filter { $0.element == "1" }
            .map { Square(x: $0.offset, y: row) }
        }
        .flatMap { $0 }
}

extension Square: Equatable, Hashable {
    static func ==(lhs: Square, rhs: Square) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    var neighbours: [Square] {
        return [
            Square(x: x + 1, y: y),
            Square(x: x, y: y + 1),
            Square(x: x - 1, y: y),
            Square(x: x, y: y - 1)
        ]
    }
}

func findRegion(_ square: Square, _ squares: Set<Square>) -> Set<Square> {
    let neighbours = square
        .neighbours
        .filter { squares.contains($0) }
    var remaining = squares
    remaining.remove(square)
    for square in neighbours {
        remaining.remove(square)
    }
    var region = Set<Square>(neighbours)
    region.insert(square)
    neighbours.forEach {
        let neighbourRegion = findRegion($0, remaining)
        for square in neighbourRegion {
            remaining.remove(square)
            region.insert(square)
        }
    }
    return region
}

solve()