import Foundation

func solve() {
    print("--- Day 25: The Halting Problem ---")
    print("Final Part: \(findChecksum())")
}

enum State {
    case A
    case B
    case C
    case D
    case E
    case F
}

func findChecksum() -> Int {
    var machine = [Int: Int]()
    let steps = 12_261_543
    var state = State.A
    var cursor = 0
    for _ in 0..<steps {
        switch state {
        case .A:
            if machine[cursor, default: 0] == 0 {
                machine[cursor] = 1
                cursor += 1
                state = .B
            } else {
                machine[cursor] = 0
                cursor -= 1
                state = .C
            }
        case .B:
            if machine[cursor, default: 0] == 0 {
                machine[cursor] = 1
                cursor -= 1
                state = .A
            }
            else {
                machine[cursor] = 1
                cursor += 1
                state = .C
            }
        case .C:
            if machine[cursor, default: 0] == 0 {
                machine[cursor] = 1
                cursor += 1
                state = .A
            }
            else {
                machine[cursor] = 0
                cursor -= 1
                state = .D
            }
        case .D:
            if machine[cursor, default: 0] == 0 {
                machine[cursor] = 1
                cursor -= 1
                state = .E
            }
            else {
                machine[cursor] = 1
                cursor -= 1
                state = .C
            }
        case .E:
            if machine[cursor, default: 0] == 0 {
                machine[cursor] = 1
                cursor += 1
                state = .F
            }
            else {
                machine[cursor] = 1
                cursor += 1
                state = .A
            }
        case .F:
            if machine[cursor, default: 0] == 0 {
                machine[cursor] = 1
                cursor += 1
                state = .A
            }
            else {
                machine[cursor] = 1
                cursor += 1
                state = .E
            }
        }
    }
    return machine.values.reduce(0, +)
}

solve()
