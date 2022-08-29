import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_02.txt")
    let rows = input.components(separatedBy: .newlines)
    print("--- Day 2: Corruption Checksum ---")
    print("Part 1: \(findChecksum(rows))")
    print("Part 2: \(computeSum(rows))")
}

func findChecksum(_ rows: [String]) -> Int {
	return rows.map { $0.components(separatedBy: "\t").map { Int($0)! } }
        .map { $0.max()! - $0.min()!}
        .reduce(0, +)
}

func computeSum(_ rows: [String]) -> Int {
    return rows.reduce(0) { (sum, row) in
        let values = row.components(separatedBy: "\t").map { Double($0)! }
        for i in 0..<values.count {
            for j in 0..<values.count {
                if i == j { continue }
                let result = values[i] / values[j]
                if (result.truncatingRemainder(dividingBy: 1.0) == 0.0) { return sum + Int(result) }
            }
        }
        return sum
    }
}

solve()
