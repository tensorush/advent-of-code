import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_10.txt")
    print("--- Day 10: Knot Hash ---")
    print("Part 1: \(findMultiplicationResult(input))")
    print("Part 2: \(findKnotHash(input))")
}

class Puzzle {
	private(set) var circularList: [Int]
	private let lengths: [Int]
	var skip = 0
	var cur = 0

	init(_ circularListSize: Int, _ lengths: [Int]) {
		self.circularList = Array(0 ..< circularListSize)
		self.lengths = lengths
	}

	func pass(log: Bool = false) {
		for len in lengths {
			if log { printCircList(len: len) }
			var rev = [Int]()
			for i in 0..<len {
				rev.append(circularList[(cur + i) % circularList.count])
			}
			rev.reverse()
			for i in 0..<len {
				circularList[(cur + i) % circularList.count] = rev[i]
			}
			if log { printCircList(len: len) }
			cur = (cur + len + skip) % circularList.count
			skip += 1
		}
		if log { printCircList(len: nil) }
	}

	func printCircList(len: Int?) {
		var string = ""
		for (i, n) in circularList.enumerated() {
			var part = (i == cur ? "[\(n)]" : "\(n)")
			if let len = len {
				if i == cur { part = "(" + part }
				if i == ((cur + len) % circularList.count) - 1 { part += ")" }
			}
			part += " "
			string += part
		}
		print(string)
	}

}

func findLengths(_ line: String) -> [Int] {
	var lengths = [Int]()
	for c in line {
		if c == "," {
			lengths.append(44)
		} else {
			lengths.append(48 + Int(String(c))!)
		}
	}
	return lengths + [17, 31, 73, 47, 23]
}

func denseHash(_ nums: [Int]) -> [Int] {
	var dense = [Int]()
	for blockNum in 0..<16 {
		let block = nums[16*blockNum ..< 16*(blockNum + 1)]
		let reduced = block.reduce(0, { $0 ^ $1 })
		dense.append(reduced)
	}
	return dense
}

func findMultiplicationResult(_ numberList: String) -> Int {
	let puzzle = Puzzle(256, numberList.split(separator: ",").map { Int($0)! })
	puzzle.pass()
	return puzzle.circularList[0] * puzzle.circularList[1]
}

func findKnotHash(_ numberList: String) -> String {
	let lengths = findLengths(numberList)
	let puzzle = Puzzle(256, lengths)
	for _ in 0..<64 {
		puzzle.pass()
	}
	let dense = denseHash(puzzle.circularList)
	var string = ""
	for n in dense {
		string += String(format: "%02x", n)
	}
	return string
}

solve()
