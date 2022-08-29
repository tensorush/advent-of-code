import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_05.txt")
    let instructions = input.components(separatedBy: .newlines).map { Int($0)! }
    print("--- Day 5: A Maze of Twisty Trampolines, All Alike ---")
    print("Part 1: \(countSteps(instructions, false))")
    print("Part 2: \(countSteps(instructions, true))")
}

func countSteps(_ instructions: [Int], _ isPart2: Bool) -> Int {
    var mutableInstructions = instructions
    var index = 0, steps = 0
    while index >= 0 && index < mutableInstructions.count {
        let jump = mutableInstructions[index]
        if isPart2 && jump >= 3 {
            mutableInstructions[index] -= 1
        } else {
            mutableInstructions[index] += 1
        }
        index += jump
        steps += 1
    }
    return steps
}

solve()
