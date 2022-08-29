import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_22.txt")
    let lines = input.components(separatedBy: .newlines)
    print("--- Day 22: Sporifica Virus ---")
    print("Part 1: \(GridPartOne(lines).run(10_000))")
    print("Part 2: \(GridPartTwo(lines).run(10_000_000))")
}

class Grid {
	let allDirections = [(0, 1), (1, 0), (0, -1), (-1, 0)]
	var uncleanNodeStates = [String: String]()
	var numBurstsThatCausedInfection = 0
	var directionIndex = 0
	var currentX = 0
	var currentY = 0

	init(_ lines: [String]) {
		let inputRadius = lines.count / 2
		for (row, line) in lines.enumerated() {
			let chars = Array(line).map { String($0) }
			for (col, ch) in chars.enumerated() {
				if ch != "." {
					let pointString = p2s(col - inputRadius, inputRadius - row)
					uncleanNodeStates[pointString] = ch
				}
			}
		}
	}

	func run(_ numBursts: Int) -> Int {
		for _ in 1...numBursts {
			self.burst()
		}
		return numBurstsThatCausedInfection
	}

	func moveForward() {
		let (dx, dy) = allDirections[directionIndex]
		currentX += dx
		currentY += dy
	}

	func turnLeft() {
        directionIndex = (directionIndex + 3) % 4
    }

	func turnRight() {
        directionIndex = (directionIndex + 1) % 4
    }

	func reverseDirection() {
        directionIndex = (directionIndex + 2) % 4
    }

	func p2s(_ x: Int, _ y: Int) -> String { return "\(x),\(y)" }

	func burst() { fatalError("burst() is not implemented") }
}

class GridPartOne: Grid {
	override func burst() {
		let pointString = p2s(currentX, currentY)
		if let _ = uncleanNodeStates[pointString] {
			turnRight()
			uncleanNodeStates[pointString] = nil
		} else {
			turnLeft()
			uncleanNodeStates[pointString] = "#"
			numBurstsThatCausedInfection += 1
		}
		moveForward()
	}
}

class GridPartTwo: Grid {
	override func burst() {
		let pointString = p2s(currentX, currentY)
		if let nodeState = uncleanNodeStates[pointString] {
			switch nodeState {
			case "W":
				uncleanNodeStates[pointString] = "#"
				numBurstsThatCausedInfection += 1
			case "#":
				turnRight()
				uncleanNodeStates[pointString] = "F"
			case "F":
				reverseDirection()
				uncleanNodeStates[pointString] = nil
			default: fatalError()
			}
		} else {
			turnLeft()
			uncleanNodeStates[pointString] = "W"
		}
		moveForward()
	}
}

solve()
