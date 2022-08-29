import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_18.txt")
    let instructions = input.components(separatedBy: .newlines)
    print("--- Day 18: Duet ---")
    print("Part 1: \(findLastSnd(instructions))")
    print("Part 2: \(countSnd(instructions))")
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
	var pc = 0

	init(_ programId: Int, _ lines: [String]) {
		regValues["p"] = programId
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

	func snd(_ x: String) {
		fatalError("snd() is not implemented")
	}

	func rcv(_ x: String) {
		fatalError("rcv() is not implemented")
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
			case "snd": snd(x)
			case "set": regValues[x] = valueForParam(y)
			case "add": regValues[x] = valueForParam(x) + valueForParam(y)
			case "mul": regValues[x] = valueForParam(x) * valueForParam(y)
			case "mod": regValues[x] = valueForParam(x) % valueForParam(y)
			case "rcv": rcv(x)
			case "jgz":
				if valueForParam(x) > 0 { pc += valueForParam(y) - 1 }
			default: fatalError("Unexpected instruction '\(instr)'.")
			}
			if state == .running { pc += 1 }
		}
	}
}

class Program1: Program {
	var lastSnd = -999

	override func snd(_ x: String) {
		lastSnd = valueForParam(x)
	}

	override func rcv(_ x: String) {
		if valueForParam(x) != 0 { state = .terminated }
	}
}

class Program2: Program {
	var otherProgram: Program2?
	var queue = [Int]()
	var sndCount = 0

	override func snd(_ x: String) {
		otherProgram?.queue.append(valueForParam(x))
		sndCount += 1
	}

	override func rcv(_ x: String) {
		if queue.count == 0 {
			state = .waitingToReceive
		} else {
			regValues[x] = queue.removeFirst()
		}
	}
}

func findLastSnd(_ instructions: [String]) -> Int {
	let t = Program1(0, instructions)
	t.run()
	return t.lastSnd
}

func countSnd(_ instructions: [String]) -> Int {
	let t0 = Program2(0, instructions)
	let t1 = Program2(1, instructions)
	t0.otherProgram = t1
	t1.otherProgram = t0
	var (cur, other) = (t0, t1)
	while true {
		cur.run()
		if other.state == .terminated { break }
		if other.state == .waitingToReceive && other.queue.count == 0 { break }
		(cur, other) = (other, cur)
	}
	return t1.sndCount
}

solve()
