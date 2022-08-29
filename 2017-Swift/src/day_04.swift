import Foundation

func solve() {
    let input = try! String(contentsOfFile: "inputs/day_04.txt")
    let phrases = input.components(separatedBy: .newlines)
    print("--- Day 4: High-Entropy Passphrases ---")
    print("Part 1: \(validPassphrases(phrases).count)")
    print("Part 2: \(validPassphrases(phrases).filter{ !containsAnagram($0) }.count)")
}

func validPassphrases(_ phrases: [String]) -> [String] {
    return phrases.filter { check($0) }
}

func containsAnagram(_ passphrase: String) -> Bool {
    let sortedByCharacters = passphrase.components(separatedBy: " ").map { String($0.sorted()) }
    return !check(sortedByCharacters.joined(separator: " "))
}

func check(_ passphrase: String) -> Bool {
    let words = passphrase.components(separatedBy: " ")
    let setOfWords = Set(words)
    return words.count > 1 && words.count == setOfWords.count
}

solve()
