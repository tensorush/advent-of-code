pub fn solve(strings: &str) {
    println!("--- Day 8: Matchsticks ---");
    println!("Part 1: {}", part_1(strings));
    println!("Part 2: {}", part_2(strings));
}

fn part_1(strings: &str) -> usize {
    let mut index;
    let mut length;
    let mut num_code_letters;
    let mut num_memory_letters;
    let mut letters: Vec<char>;
    let mut num_code_minus_memory_letters = 0;
    for string in strings.lines() {
        index = 0;
        num_memory_letters = 0;
        num_code_letters = string.len();
        letters = string[1..num_code_letters - 1].chars().collect();
        length = letters.len();
        while index < length {
            num_memory_letters += 1;
            if letters[index] == '\\' {
                if letters[index + 1] == 'x' {
                    index += 4;
                } else {
                    index += 2;
                }
            } else {
                index += 1;
            }
        }
        num_code_minus_memory_letters += num_code_letters - num_memory_letters;
    }
    num_code_minus_memory_letters
}

fn part_2(strings: &str) -> usize {
    let mut index;
    let mut length;
    let mut num_code_letters;
    let mut num_memory_letters;
    let mut letters: Vec<char>;
    let mut num_code_minus_memory_letters = 0;
    for string in strings.lines() {
        index = 0;
        num_memory_letters = 6;
        num_code_letters = string.len();
        letters = string[1..num_code_letters - 1].chars().collect();
        length = letters.len();
        while index < length {
            num_memory_letters += 1;
            if letters[index] == '\\' {
                if letters[index + 1] == 'x' {
                    num_memory_letters += 4;
                    index += 4;
                } else {
                    num_memory_letters += 3;
                    index += 2;
                }
            } else {
                index += 1;
            }
        }
        num_code_minus_memory_letters += num_memory_letters - num_code_letters;
    }
    num_code_minus_memory_letters
}
