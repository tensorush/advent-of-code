import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_12.txt")
    let pipes = input.components(separatedBy: .newlines)
    print("--- Day 12: Digital Plumber ---")
    print("Part 1: \(countPrograms(pipes))")
    print("Part 2: \(countGroups(pipes))")
}

func countPrograms(_ pipes: [String]) -> Int {
    return addChildPipes(pipes, pipes[0], Set<Int>()).count
}

func countGroups(_ pipes: [String]) -> Int {
    var groups = Set<Set<Int>>()
    for pipe in pipes {
        groups.insert(addChildPipes(pipes, pipe, Set<Int>()))
    }
    return groups.count
}

func addChildPipes(_ pipes: [String], _ pipe: String, _ set: Set<Int>) -> Set<Int> {
    let separators = CharacterSet(charactersIn: " <->,")
    let components = pipe
        .components(separatedBy: separators).filter { !$0.isEmpty }
        .map { Int($0)! }
    var newSet = set
    if !newSet.contains(components.first!) { newSet.insert(components.first!) }
    for program in components.suffix(from: 1) {
        if !newSet.contains(program) { newSet = addChildPipes(pipes, pipes[program], newSet) }
    }
    return newSet
}

solve()
