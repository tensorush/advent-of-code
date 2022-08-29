import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_19.txt")
    let rows = input.components(separatedBy: .newlines)
    let map = Map(rows)
    let (letters, numSteps) = map.collectLetters()
    print("--- Day 19: A Series of Tubes ---")
    print("Part 1: \(letters)")
    print("Part 2: \(numSteps)")
}

struct Position {
    var x: Int
    var y: Int
    var direction: Direction

    enum Direction: Equatable {
        case up, down, left, right
    }

    var up: Position { return Position(x: x, y: y - 1, direction: .up) }
    var down: Position { return Position(x: x, y: y + 1, direction: .down) }
    var left: Position { return Position(x: x - 1, y: y, direction: .left) }
    var right: Position { return Position(x: x + 1, y: y, direction: .right) }

    mutating func moveNext() {
        switch direction {
        case .up: y -= 1
        case .down: y += 1
        case .left: x -= 1
        case .right: x += 1
        }
    }
}

struct Map {
    let map: [[Character]]

    init(_ rows: [String]) {
        map = rows.map { line in line.map { $0 } }
    }

    func collectLetters() -> (letters: String, steps: Int) {
        var letters = ""
        var position = findStart()
        var steps = 0
        repeat {
            let char = self[position]!
            switch char {
            case " ": return (letters, steps)
            case "|", "-": break
            case "+": changeDirection(&position)
            default: letters += String(char)
            }
            position.moveNext()
            steps += 1
        } while true
    }

    subscript(x: Int, y: Int) -> Character? {
        get {
            guard x >= 0 && y >= 0 && y < map.count && x < map[y].count else { return nil }
            return map[y][x]
        }
    }

    subscript(pos: Position) -> Character? {
        get {
            return self[pos.x, pos.y]
        }
    }

    private func findStart() -> Position {
        let index = map[0].firstIndex(of: "|")!
        return Position(x: index, y: 0, direction: .down)
    }

    private func changeDirection(_ position: inout Position) {
        let neighbors = getNeighbors(position)
        if position.direction == .up || position.direction == .down {
            let left = neighbors.first { $0.direction == .left }
            if let left = left, left.char != " ", left.char != "|" {
                position.direction = .left
            } else {
                position.direction = .right
            }
        } else {
            let up = neighbors.first { $0.direction == .up }
            if let up = up, up.char != " ", up.char != "-" {
                position.direction = .up
            } else {
                position.direction = .down
            }
        }
    }

    private func getNeighbors(_ position: Position) -> [(direction: Position.Direction, char: Character)] {
        return [position.up, position.down, position.left, position.right]
            .compactMap { pos in
                guard let char = self[pos] else { return nil }
                return (pos.direction, char)
            }
    }
}

solve()
