import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_24.txt")
    let lines = input.components(separatedBy: .newlines)
    let graph = Graph(lines)
    graph.visitAllPossiblePaths(0, Graph(lines: []))
    print("--- Day 24: Electromagnetic Moat ---")
    print("Part 1: \(graph.maxBridgeStrength)")
    print("Part 2: \(graph.maxBridgeStrengthForMaxBridgeLength)")
}

class Graph {
	var maxBridgeStrengthForMaxBridgeLength = 0
	var edgeMap = [Int: Set<Int>]()
	var maxBridgeStrength = 0
	var maxBridgeLength = 0

	init(_ lines: [String]) {
		for line in lines {
			let portPins = line.split(separator: "/").map { Int($0)! }
			addEdge(portPins[0], portPins[1])
		}
	}

	func addEdge(_ n1: Int, _ n2: Int) {
		func connect(from a: Int, to b: Int) {
			if var connections = edgeMap[a] {
				connections.insert(b)
				edgeMap[a] = connections
			} else {
				edgeMap[a] = Set([b])
			}
		}
		connect(from: n1, to: n2)
		connect(from: n2, to: n1)
	}

	func removeEdge(_ n1: Int, _ n2: Int) {
		func disconnect(from a: Int, to b: Int) {
			if var connections = edgeMap[a] {
				connections.remove(b)
				edgeMap[a] = connections
			}
		}
		disconnect(from: n1, to: n2)
		disconnect(from: n2, to: n1)
	}

	func containsEdge(_ n1: Int, _ n2: Int) -> Bool {
		guard let connections = edgeMap[n1] else { return false }
		return connections.contains(n2)
	}

	func edgeCount() -> Int {
		var count = 0
		for (a, connections) in edgeMap {
			for b in connections {
				if a <= b { count += 1 }
			}
		}
		return count
	}

	func strength() -> Int {
		var s = 0
		for (a, connections) in edgeMap {
			for b in connections {
				if a <= b { s += a + b }
			}
		}
		return s
	}

	func visitAllPossiblePaths(_ startingAt a: Int, _ edgesAlreadyTraversed: Graph) {
		var didRecurse = false
		for b in edgeMap[a]! {
			if !edgesAlreadyTraversed.containsEdge(a, b) {
				edgesAlreadyTraversed.addEdge(a, b)
				visitAllPossiblePaths(startingAt: b, edgesAlreadyTraversed: edgesAlreadyTraversed)
				edgesAlreadyTraversed.removeEdge(a, b)
				didRecurse = true
			}
		}
		if !didRecurse {
			let bridgeStrength = edgesAlreadyTraversed.strength()
			maxBridgeStrength = max(maxBridgeStrength, bridgeStrength)
			let bridgeLength = edgesAlreadyTraversed.edgeCount()
			if bridgeLength > maxBridgeLength {
				maxBridgeLength = bridgeLength
				maxBridgeStrengthForMaxBridgeLength = bridgeStrength
			} else if bridgeLength == maxBridgeLength {
				maxBridgeStrengthForMaxBridgeLength = max(maxBridgeStrengthForMaxBridgeLength, bridgeStrength)
			}
		}
	}
}

solve()
