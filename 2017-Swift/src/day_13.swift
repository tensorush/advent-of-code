import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_13.txt")
    let layers = input.components(separatedBy: .newlines).map { (line) -> (Int, Int) in
        let parts = line.components(separatedBy: ": ")
        return (Int(parts[0])!, Int(parts[1])!)
    }
    let firewall = Dictionary(uniqueKeysWithValues: layers)
    print("--- Day 13: Packet Scanners ---")
    print("Part 1: \(findSeverity(firewall))")
    print("Part 2: \(findDelay(firewall))")
}

func findSeverity(_ firewall: [Int: Int]) -> Int {
    return penetrate(firewall, 0).severity
}

func findDelay(_ firewall: [Int: Int]) -> Int {
    var delay = -1
    repeat {
        delay += 1
    } while penetrate(firewall, delay).caught
    return delay
}

func penetrate(_ firewall: [Int: Int], _ delay: Int) -> (severity: Int, caught: Bool) {
    var severity = 0
    var caught = false
    for step in 0...firewall.keys.max()! {
        if let range = firewall[step] {
            if wave(step + delay, range-1) == 0 {
                severity += step * range
                caught = true
            }
        }
    }
    return (severity, caught)
}

func wave(_ position: Int, _ max: Int) -> Int {
    return (abs(abs(position % (max * 2) - max) - max));
}

solve()
