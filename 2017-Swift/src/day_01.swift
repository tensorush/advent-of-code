import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_01.txt")
    let digits = input.map { Int(String($0))! }
    print("--- Day 1: Inverse Captcha ---")
    print("Part 1: \(solveCaptcha(digits, 1))")
    print("Part 2: \(solveCaptcha(digits, digits.count / 2))")
}

func solveCaptcha(_ digits: [Int], _ offset: Int) -> Int {
    return digits.enumerated().reduce(0) { $0 + ($1.element == digits[($1.offset + offset) % digits.count] ? $1.element : 0) }
}

solve()
