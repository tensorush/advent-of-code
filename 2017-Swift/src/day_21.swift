import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_21.txt")
    let lines = input.components(separatedBy: .newlines).map { $0.split(separator: " ") .map { String($0) } }
    let rules = loadRules(lines)
    print("--- Day 21: Fractal Art ---")
    print("Part 1: \(countOnPixels(rules, 5))")
    print("Part 2: \(countOnPixels(rules, 18))")
}

struct Grid: Hashable {
    static let initial = Grid(".#./..#/###")

    var pattern: String { return pixels.map { row in row.map { $0 == 1 ? "#" : "." }.joined() }.joined(separator: "/") }
    var countOfOnPixels: Int { return pixels.flatMap { $0 }.reduce(0, +) }
    var size: Int { return pixels.count }
    var pixels: [[Int]]

    init(_ pixels: [[Int]]) {
        self.pixels = pixels
    }

    init(_ pattern: String) {
        pixels = pattern.split(separator: "/").map { row in row.map { $0 == "#" ? 1 : 0 } }
    }

    init(_ grids: [[Grid]]) {
        pixels = []
        grids.forEach { row in
            for y in 0 ..< row[0].pixels.count {
                let pixelRow = row.map { grid in grid.pixels[y] }.flatMap { $0 }
                pixels.append(pixelRow)
            }
        }
    }

    func flipHorizontally() -> Grid {
        return Grid(pixels.reversed())
    }

    func flipVertically() -> Grid {
        let newPixels = pixels.map { row in Array(row.reversed()) }
        return Grid(newPixels)
    }

    func rotate() -> Grid {
        var result = pixels
        for y in 0 ..< pixels.count {
            var j = pixels.count - 1
            for x in 0 ..< pixels.count {
                result[y][x] = pixels[j][y]
                j -= 1
            }
        }
        return Grid(result)
    }

    func divide() -> [[Grid]] {
        var result: [[Grid]] = []
        if size % 2 == 0 {
            let count = size / 2
            for y in 0 ..< count {
                var row: [Grid] = []
                for x in 0 ..< count {
                    let newPixels = pixels.dropFirst(y * 2).prefix(2).map { row in Array(row.dropFirst(x * 2).prefix(2)) }
                    row.append(Grid(newPixels))
                }
                result.append(row)
            }
        } else {
            assert(size % 3 == 0)
            let count = size / 3
            for y in 0 ..< count {
                var row: [Grid] = []
                for x in 0 ..< count {
                    let newPixels = pixels.dropFirst(y * 3).prefix(3)
                        .map { row in Array(row.dropFirst(x * 3).prefix(3)) }
                    row.append(Grid(newPixels))
                }
                result.append(row)
            }
        }
        return result
    }

    func draw() {
        for (_, row) in pixels.enumerated() {
            for (_, pixel) in row.enumerated() {
                print(pixel == 1 ? "#" : ".", terminator: "")
            }
            print("")
        }
    }
}

func loadRules(_ lines: [[String]]) -> [Grid: Grid] {
    var rules: [Grid: Grid] = [:]
    lines.forEach { line in
            let startGrid = Grid(line[0])
            let resultGrid = Grid(line[2])
            [startGrid, startGrid.flipHorizontally(), startGrid.flipVertically()].forEach { grid in
                rules[grid] = resultGrid
                var rotated = grid.rotate()
                rules[rotated] = resultGrid
                rotated = grid.rotate()
                rules[rotated] = resultGrid
                rotated = grid.rotate()
                rules[rotated] = resultGrid
            }
        }
    return rules
}

func countOnPixels(_ rules: [Grid: Grid], _ num_iters: Int) -> Int {
    var grid = Grid.initial
    for _ in 0 ..< num_iters {
        grid = Grid(grid.divide().map { row in row.map { rules[$0]! } })
    }
    return grid.countOfOnPixels
}

solve()
