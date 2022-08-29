import Foundation

var inputMoves = [String]()
var dancers = [String]()

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_16.txt")
    print("--- Day 16: Permutation Promenade ---")
    print("Part 1: \(findOrder(input))")
    print("Part 2: \(solve2(input))")
}

func findOrder(_ input: String) -> String {
    dancers = Array("abcdefghijklmnop").map({ String($0) })
	inputMoves = input.split(separator: ",").map({ String($0) })
	for move in inputMoves {
		apply(move)
	}
	return dancers.joined()
}

func solve2(_ input: String) -> String {
	let initialDancers = "abcdefghijklmnop"
	dancers = Array(initialDancers).map({ String($0) })
	inputMoves = input.split(separator: ",").map({ String($0) })
	var cycle = -1
	for i in 1 ..< 10_000_000 {
		for move in inputMoves {
            apply(move)
        }
		if dancers.joined() == initialDancers {
			cycle = i
			break
		}
	}
	dancers = Array(initialDancers).map({ String($0) })
	for _ in 0 ..< (1_000_000_000 % cycle) {
		for move in inputMoves {
            apply(move)
        }
	}
	return dancers.joined()
}

func apply(_ move: String) {
	let type = (move as NSString).substring(to: 1) as String
	let parts = ((move as NSString).substring(from: 1) as String).split(separator: "/")
	switch type {
	case "s": spin(Int(parts[0])!)
	case "x":
		let a = Int(parts[0])!
		let b = Int(parts[1])!
		exchange(a, b)
	case "p":
		let a = String(parts[0])
		let b = String(parts[1])
		partner(a, b)
	default: fatalError()
	}
}

func spin(_ num: Int) {
	dancers = Array(dancers[dancers.count - num ..< dancers.count] + dancers[0 ..< dancers.count - num])
}

func exchange(_ position1: Int, _ position2: Int) {
	(dancers[position1], dancers[position2]) = (dancers[position2], dancers[position1])
}

func partner(_ name1: String, _ name2: String) {
	exchange(dancers.firstIndex(of: name1)!, dancers.firstIndex(of: name2)!)
}

solve()
