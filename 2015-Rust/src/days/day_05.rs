pub fn solve(strings: &str) {
    println!("--- Day 5: Doesn't He Have Intern-Elves For This? ---");
    println!("Part 1: {}", part_1(strings));
    println!("Part 2: {}", part_2(strings));
}

fn part_1(strings: &str) -> u32 {
    let mut num_nice_strings = 0;
    for string in strings.lines() {
        let letters: Vec<char> = string.chars().collect();
        let num_vowels = letters
            .iter()
            .filter(|letter| matches!(letter, 'a' | 'e' | 'i' | 'o' | 'u'))
            .count();
        if num_vowels < 3 {
            continue;
        }
        let has_double_consonants = letters.windows(2).any(|window| window[0] == window[1]);
        if !has_double_consonants {
            continue;
        }
        let has_blacklisted_substrings = string.contains("ab")
            || string.contains("cd")
            || string.contains("pq")
            || string.contains("xy");
        if has_blacklisted_substrings {
            continue;
        }
        num_nice_strings += 1;
    }
    num_nice_strings
}

fn part_2(strings: &str) -> u32 {
    let mut num_nice_strings = 0;
    for string in strings.lines() {
        let mut cur_letter;
        let mut next_letter;
        let length = string.len() - 3;
        let mut has_repeated_pair = false;
        let letters: Vec<char> = string.chars().collect();
        for i in 0..length {
            cur_letter = letters[i];
            next_letter = letters[i + 1];
            has_repeated_pair = letters[(i + 2)..]
                .windows(2)
                .any(|window| window[0] == cur_letter && window[1] == next_letter);
            if has_repeated_pair {
                break;
            }
        }
        if !has_repeated_pair {
            continue;
        }
        let has_repeated_with_one_between = letters.windows(3).any(|window| window[0] == window[2]);
        if !has_repeated_with_one_between {
            continue;
        }
        num_nice_strings += 1;
    }
    num_nice_strings
}
