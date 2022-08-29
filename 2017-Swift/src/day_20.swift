import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_20.txt")
    var particles = input.components(separatedBy: .newlines).map { Particle($0) }
    print("--- Day 20: Particle Swarm ---")
    print("Part 1: \(findClosestParticle(particles))")
    print("Part 2: \(countRemainingParticles(&particles))")
}

struct Vector: Equatable, Hashable {
    var x: Int
    var y: Int
    var z: Int

    var distance: Int {
        return abs(x) + abs(y) + abs(z)
    }

    static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

struct Particle {
    var position: Vector
    var velocity: Vector
    var acceleration: Vector

    init(_ string: String) {
        let components = string
            .components(separatedBy: CharacterSet(charactersIn: "pva=<> "))
            .filter { !$0.isEmpty }
            .joined()
            .components(separatedBy: ",")
            .map { Int($0)! }
        position = Vector(x: components[0], y: components[1], z: components[2])
        velocity = Vector(x: components[3], y: components[4], z: components[5])
        acceleration = Vector(x: components[6], y: components[7], z: components[8])
    }

    func displacement(_ v: Int, _ a: Int, _ t: Int) -> Int {
        let vt = v + (a * t)
        return (v + vt + a) * (t) / 2
    }

    func positionAfter(_ t: Int) -> Vector {
        return Vector(x: position.x + displacement(velocity.x, acceleration.x, t),
                      y: position.y + displacement(velocity.y, acceleration.y, t),
                      z: position.z + displacement(velocity.z, acceleration.z, t))
    }
}

func findClosestParticle(_ particles: [Particle]) -> Int {
    let t = 100_000
    let closestParticle = particles
        .enumerated()
        .map { ($0.offset, $0.element.positionAfter(t)) }
        .sorted { $0.1.distance < $1.1.distance }
        .first!
    return closestParticle.0
}

func countRemainingParticles(_ particles: inout [Particle]) -> Int {
    let n = 100
    for i in 0..<n {
        let positions = particles
            .enumerated()
            .map { ($0.offset, $0.element.positionAfter(i)) }
        let counts = positions.reduce(into: [:], { (dict, tuple) in
            dict[tuple.1, default: 0] += 1
        })
        let toRemoveIndexes = positions
            .filter { counts[$0.1]! > 1 }
            .map { $0.0 }
        particles = particles
            .enumerated()
            .filter { !toRemoveIndexes.contains($0.offset) }
            .map { $0.element }
    }
    return particles.count
}

solve()
