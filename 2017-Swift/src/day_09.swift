import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_09.txt")
    let stream = input.map { String($0) }
    let (totalScores, garbageCount) = findSolution(stream)
    print("--- Day 9: Stream Processing ---")
    print("Part 1: \(totalScores)")
    print("Part 2: \(garbageCount)")
}

class Group {
	var children = [Group]()
	var parent: Group?
	var score = 1

	func updateScore() {
		if let p = parent {
			score = p.score + 1
		} else {
			score = 1
		}
		for child in children {
            child.updateScore()
        }
	}

	func totalScores() -> Int {
		var total = self.score
		for child in children {
			total += child.totalScores()
		}
		return total
	}
}

func findSolution(_ stream: [String]) -> (Int, Int) {
	var root: Group? = nil
	var stack = [Group]()
	var garbageCount = 0
	var garbage = false
	var i = 0
	while true {
		if i >= stream.count { break }
		let c = stream[i]
		if garbage && c != "!" && c != ">" { garbageCount += 1 }
		if c == "!" {
			i += 1
		} else if c == "{" {
			if !garbage {
				let g = Group()
				if let top = stack.last {
					top.children.append(g)
					g.parent = top
				} else {
					root = g
				}
				stack.append(g)
			}
		} else if c == "}" {
			if !garbage { let _ = stack.removeLast() }
		} else if c == "<" {
			garbage = true
		} else if c == ">" {
			garbage = false
		}
		i += 1
	}
	if let root = root {
		root.updateScore()
		return (root.totalScores(), garbageCount)
	} else {
		return (0, garbageCount)
	}
}

solve()
