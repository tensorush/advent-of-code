import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_07.txt").components(separatedBy: .newlines)
    var towersByName = [String: Tower]()
    for disc in input {
        let disc = [",", "(", ")", "-> "].reduce(disc, { $0.replacingOccurrences(of: $1, with: "") })
        let parts = disc.split(separator: " ").map({ String($0) })
        let tower = towerWithName(&towersByName, parts[0])
        tower.weight = Int(parts[1])!
        for i in 2..<parts.count {
            let child = towerWithName(&towersByName, parts[i])
            tower.children.append(child)
            child.parent = tower
        }
    }
    let root = towersByName.values.first(where: { $0.parent == nil })!
    root.updateTreeWeight()
    print("--- Day 7: Recursive Circus ---")
    print("Part 1: \(findBottomProgramName(root))")
    print("Part 2: \(findWeight(towersByName))")
}


class Tower {
	var depth: Int { return parent == nil ? 0 : parent!.depth + 1 }
	var normalTreeWeight = -1
	var children = [Tower]()
	var name = "NAME_HERE"
	var treeWeight = -1
	var parent: Tower?
	var weight = -1

	func updateTreeWeight() {
		for child in children {
            child.updateTreeWeight()
        }
		treeWeight = weight + children.reduce(0, { $0 + $1.treeWeight })
	}
}

func towerWithName(_ towersByName: inout [String: Tower], _ name: String) -> Tower {
    if let tower = towersByName[name] {
		return tower
	} else {
		let tower = Tower()
		tower.name = name
		towersByName[name] = tower
		return tower
	}
}

func findBottomProgramName(_ root: Tower) -> String {
	return root.name
}

func findWeight(_ towersByName: [String: Tower]) -> Int {
	var candidates = [Tower]()
	for t in towersByName.values {
		if let oddball = findOddball(t.children) { candidates.append(oddball) }
	}
	let deepest = candidates.max(by: { $0.depth < $1.depth })!
	return deepest.weight + (deepest.normalTreeWeight - deepest.treeWeight)
}

func findOddball(_ nodes: [Tower]) -> Tower? {
    if nodes.count < 3 { return nil }
    let normalTreeWeight: Int
    if nodes[0].treeWeight == nodes[1].treeWeight {
        normalTreeWeight = nodes[0].treeWeight
    } else {
        normalTreeWeight = nodes[2].treeWeight
    }
    if let oddball = nodes.first(where: { $0.treeWeight != normalTreeWeight }) {
        oddball.normalTreeWeight = normalTreeWeight
        return oddball
    }
    return nil
}

solve()
