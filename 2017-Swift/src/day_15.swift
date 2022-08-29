import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_15.txt").components(separatedBy: .newlines)
    let valueA = Int(input[0].split(separator: " ").last!)!
    let valueB = Int(input[1].split(separator: " ").last!)!
    print("--- Day 15: Dueling Generators ---")
    print("Part 1: \(findFinalCount(valueA, valueB))")
    print("Part 2: \(findPickyFinalCount(valueA, valueB))")
}

class Generator {
	let pickiness: Int
	let factor: Int
	var value: Int

	init(_ value: Int, _ factor: Int, _ pickiness: Int) {
		self.value = value
		self.factor = factor
		self.pickiness = pickiness
	}

	func generateNext() {
		value = (value * factor) % 2_147_483_647
	}

	func pickyGenerateNext() {
		while true {
			generateNext()
			if value % pickiness == 0 { break }
		}
	}
}

func isMatch(_ a: Generator, _ b: Generator) -> Bool {
	let sixteenOnes = (1 << 16) - 1
	return (a.value & sixteenOnes) == (b.value & sixteenOnes)
}

func findFinalCount(_ valueA: Int, _ valueB: Int) -> Int {
    let generatorA = Generator(valueA, 16_807, 4)
	let generatorB = Generator(valueB, 48_271, 8)
	var finalCount = 0
	for _ in 0 ..< 40_000_000 {
		generatorA.generateNext()
		generatorB.generateNext()
		if isMatch(generatorA, generatorB) { finalCount += 1 }
	}
	return finalCount
}

func findPickyFinalCount(_ valueA: Int, _ valueB: Int) -> Int {
	let generatorA = Generator(valueA, 16_807, 4)
	let generatorB = Generator(valueB, 48_271, 8)
	var finalCount = 0
	for _ in 0 ..< 5_000_000 {
		generatorA.pickyGenerateNext()
		generatorB.pickyGenerateNext()
		if isMatch(generatorA, generatorB) { finalCount += 1 }
	}
	return finalCount
}

solve()
