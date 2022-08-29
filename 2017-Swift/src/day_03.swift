import Foundation

func solve() {
    print("--- Day 3: Spiral Memory ---")
    print("Part 1: \(GridPart1().populateUntilAnswer())")
    print("Part 2: \(GridPart2().populateUntilAnswer())")
}

class Grid {
	let radius = 512
    let input = 368_078
	var cells = [[Int]]()

	init() {
		let gridWidth = 2 * radius + 1
		for _ in 0..<gridWidth {
			let row = Array<Int>(repeating: 0, count: gridWidth)
			cells.append(row)
		}
		self[0, 0] = 1
	}

	subscript(_ x: Int, _ y: Int) -> Int {
		get { return cells[y + radius][x + radius] }
		set { cells[y + radius][x + radius] = newValue }
	}

	func populateLoop(_ loopNumber: Int) -> (x: Int, y: Int, value: Int)? {
		var x = loopNumber
		var y = 1 - loopNumber
		for dy in 0..<2 * loopNumber {
			let value = populateCell(x, y + dy)
			if isDesiredValue(value) { return (x, y + dy, value) }
		}
		x -= 1
		y += 2 * loopNumber - 1
		for dx in 0..<2 * loopNumber {
			let value = populateCell(x - dx, y)
			if isDesiredValue(value) { return (x - dx, y, value) }
		}
		x -= 2 * loopNumber - 1
		y -= 1
		for dy in 0..<2 * loopNumber {
			let value = populateCell(x, y - dy)
			if isDesiredValue(value) { return (x, y - dy, value) }
		}
		x += 1
		y -= 2 * loopNumber - 1
		for dx in 0..<2 * loopNumber {
			let value = populateCell(x + dx, y)
			if isDesiredValue(value) { return (x + dx, y, value) }
		}
		return nil
	}

	func populateUntilAnswer() -> Int {
		let answer = -1;
        for loopNumber in 1...radius {
			if let (x, y, value) = populateLoop(loopNumber) { return printAnswer(x, y, value) }
		}
        return answer
	}

	func populateCell(_ x: Int, _ y: Int) -> Int {
		fatalError("populateCell() is not implemented")
	}

	func isDesiredValue(_ value: Int) -> Bool {
		fatalError("isDesiredValue() is not implemented")
	}

	func printAnswer(_ x: Int, _ y: Int, _ value: Int) -> Int {
		fatalError("printAnswer() is not implemented")
	}
}

class GridPart1: Grid {
	private var numCellsFilled = 1

	override func populateCell(_ x: Int, _ y: Int) -> Int {
		numCellsFilled += 1
		self[x, y] = numCellsFilled
		return numCellsFilled
	}

	override func isDesiredValue(_ value: Int) -> Bool {
		return value == input
	}

	override func printAnswer(_ x: Int, _ y: Int, _ value: Int) -> Int {
		return abs(x) + abs(y)
	}
}

class GridPart2: Grid {
	override func populateCell(_ x: Int, _ y: Int) -> Int {
		var value = 0
		for dx in -1...1 {
			for dy in -1...1 {
				if (dx, dy) == (0, 0) { continue }
				value += self[x + dx, y + dy]
			}
		}
		self[x, y] = value
		return value
	}

	override func isDesiredValue(_ value: Int) -> Bool {
		return value > input
	}

	override func printAnswer(_ x: Int, _ y: Int, _ value: Int) -> Int {
		return value
	}
}

solve()
