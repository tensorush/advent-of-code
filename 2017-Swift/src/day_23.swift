import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_23.txt")
    let lines = input.components(separatedBy: .newlines)
    print("--- Day 23: Coprocessor Conflagration ---")
    print("Part 1: \(countMul(lines))")
    print("Part 2: \(findValueInH(lines))")
}

enum State {
	case waitingToReceive
	case waitingToStart
	case terminated
	case running
}

class Program {
	var state: State = .waitingToStart
	var regValues = [String: Int]()
	var commands = [[String]]()
	var numCommandsExecuted = 0
	let isPart2: Bool
	var mulCount = 0
	var hValue = 0
	var pc = 0

	init(_ lines: [String], _ isPart2: Bool) {
		self.isPart2 = isPart2
		if isPart2 { regValues["a"] = 1 }
		for line in lines {
			let parts = line.split(separator: " ").map({ String($0) })
			commands.append(Array(parts))
		}
	}

	func valueForReg(_ reg: String) -> Int {
		if let value = regValues[reg] {
			return value
		} else {
			regValues[reg] = 0
			return 0
		}
	}

	func valueForParam(_ param: String) -> Int {
		if param == "" { fatalError() }
		if let value = Int(param) {
			return value
		} else {
			return valueForReg(param)
		}
	}

	func run() {
		state = .running
		while state == .running {
			if pc < 0 || pc >= commands.count {
				state = .terminated
				return
			}
			let cmd = commands[pc]
			let instr = cmd[0]
			let x = cmd[1]
			let y = ((cmd.count == 3) ? cmd[2] : "")
			switch instr {
			case "set":
				regValues[x] = valueForParam(y)
				if isPart2 { if x == "h" { print("h = \(valueForParam(y))") } }
			case "sub": regValues[x] = valueForParam(x) - valueForParam(y)
			case "mul":
				regValues[x] = valueForParam(x) * valueForParam(y)
				mulCount += 1
			case "jnz": if valueForParam(x) != 0 { pc += valueForParam(y) - 1 }
			default: fatalError("Unexpected instruction '\(instr)'.")
			}
			numCommandsExecuted += 1
			if isPart2 {
				if x == "h" && valueForParam("h") != hValue {
					hValue = valueForParam("h")
					print("new h value: \(hValue)")
				}
			}
			if state == .running { pc += 1 }
		}
	}
}

func countMul(_ lines: [String]) -> Int {
	let program = Program(lines, false)
	program.run()
	return program.mulCount
}

func findValueInH(_ lines: [String]) -> Int {
	func isPrime(_ n: Int) -> Bool {
		for i in 2...n {
			if n % i == 0 { return false }
			if i * i > n { break }
		}
		return true
	}
	let b = 93 * 100 + 100_000
	let c = b + 17_000
	var h = 0
	for n in stride(from: b, through: c, by: 17) {
		if !isPrime(n) { h = h + 1 }
	}
	return h
}

solve()
