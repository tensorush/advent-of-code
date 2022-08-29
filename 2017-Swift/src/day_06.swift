import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_06.txt")
    let banks = input.components(separatedBy: "\t").map { Int($0)! }
    print("--- Day 6: Memory Reallocation ---")
    print("Part 1: \(countCycles(banks, true))")
    print("Part 2: \(countCycles(banks, false))")
}

func countCycles(_ banks: [Int], _ isPart1: Bool) -> Int {
    var previousStates = [String]()
    var current = banks
    var cycleCount = 0
    while !previousStates.contains("\(current)") {
        previousStates.append("\(current)")
        let mostBlocks = current.enumerated().max { $0.element < $1.element || $0.offset > $1.offset }!.offset
        current = redistributeBlocks(current, mostBlocks)
        cycleCount += 1
    }
    return (isPart1) ? cycleCount : cycleCount - previousStates.firstIndex(of: "\(current)")!
}

func redistributeBlocks(_ banks: [Int], _ position: Int) -> [Int] {
    var new = banks
    new[position] = 0
    let blocksToRedistribute = banks[position]
    for i in (position + 1)...(position + blocksToRedistribute) {
        new[i % new.count] += 1
    }
    return new
}

solve()
