import Foundation

func solve() {
    let input = 363
    print("--- Day 17: Spinlock ---")
    print("Part 1: \(findValue(input))")
    print("Part 2: \(findValueAfterZero(input))")
}

func findValue(_ input: Int) -> Int {
    var currentPosition = 0
    var buffer = [0]
    for i in 1...2017 {
        currentPosition = ((currentPosition + input) % i) + 1
        buffer.insert(i, at: currentPosition)
    }
    let position2017: Int = buffer.firstIndex(of: 2017)!
    return buffer[(position2017 + 1) % buffer.count]
}

func findValueAfterZero(_ input: Int) -> Int {
    var insertPosition = 0
    var valueAfterZero = -1
    for i in 1...50_000_000 {
        insertPosition = (insertPosition + input) % i
        if insertPosition == 0 { valueAfterZero = i }
        insertPosition += 1
    }
    return valueAfterZero
}

solve()
