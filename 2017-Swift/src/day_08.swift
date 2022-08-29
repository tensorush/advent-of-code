import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_08.txt")
    let instructions = input.components(separatedBy: .newlines)
    print("--- Day 8: I Heard You Like Registers ---")
    print("Part 1: \(findLargestValue(instructions, true))")
    print("Part 2: \(findLargestValue(instructions, false))")
}

func findLargestValue(_ instructions: [String], _ isPart1: Bool) -> Int {
    var highestValue = 0
    var registers = [String: Int]()
    for instruction in instructions {
        let parts = instruction.components(separatedBy: " ")
        var shouldExecute = false
        switch parts[5] {
        case ">": shouldExecute = (registers[parts[4]] ?? 0) > Int(parts[6])!
        case "<": shouldExecute = (registers[parts[4]] ?? 0) < Int(parts[6])!
        case ">=": shouldExecute = (registers[parts[4]] ?? 0) >= Int(parts[6])!
        case "<=": shouldExecute = (registers[parts[4]] ?? 0) <= Int(parts[6])!
        case "==": shouldExecute = (registers[parts[4]] ?? 0) == Int(parts[6])!
        case "!=": shouldExecute = (registers[parts[4]] ?? 0) != Int(parts[6])!
        default: print("Unknown operator: \(parts[5])")
        }
        if shouldExecute {
            if parts[1] == "inc" {
                registers[parts[0]] = (registers[parts[0]] ?? 0) + Int(parts[2])!
            } else {
                registers[parts[0]] = (registers[parts[0]] ?? 0) - Int(parts[2])!
            }
        }
        highestValue = max(registers.values.map { $0 }.max()!, highestValue)
    }
    return (isPart1) ? registers.values.map { $0 }.max()! : highestValue
}

solve()
