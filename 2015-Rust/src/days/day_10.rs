fn part_1(look_and_say_sequence: &str) -> usize {
    let mut num_digits: u32;
    let mut next_sequence: String;
    const NUM_ITERATIONS: i32 = 40;
    let mut last_digit: Option<char>;
    let mut cur_sequence: String = look_and_say_sequence.to_string().clone();
    for _iteration in 0..NUM_ITERATIONS {
        num_digits = 0;
        last_digit = None;
        next_sequence = String::new();
        for digit in cur_sequence.chars() {
            if last_digit == Some(digit) {
                num_digits += 1;
            } else {
                if let Some(last_digit_value) = last_digit {
                    next_sequence.push_str(&num_digits.to_string());
                    next_sequence.push_str(&last_digit_value.to_string());
                }
                last_digit = Some(digit);
                num_digits = 1;
            }
        }
        next_sequence.push_str(&num_digits.to_string());
        next_sequence.push_str(&last_digit.unwrap_or('0').to_string());
        cur_sequence = next_sequence;
    }
    cur_sequence.len()
}

fn part_2(look_and_say_sequence: &str) -> usize {
    let mut num_digits: u32;
    let mut next_sequence: String;
    const NUM_ITERATIONS: i32 = 50;
    let mut last_digit: Option<char>;
    let mut cur_sequence: String = look_and_say_sequence.to_string().clone();
    for _iteration in 0..NUM_ITERATIONS {
        num_digits = 0;
        last_digit = None;
        next_sequence = String::new();
        for digit in cur_sequence.chars() {
            if last_digit == Some(digit) {
                num_digits += 1;
            } else {
                if let Some(last_digit_value) = last_digit {
                    next_sequence.push_str(&num_digits.to_string());
                    next_sequence.push_str(&last_digit_value.to_string());
                }
                last_digit = Some(digit);
                num_digits = 1;
            }
        }
        next_sequence.push_str(&num_digits.to_string());
        next_sequence.push_str(&last_digit.unwrap_or('0').to_string());
        cur_sequence = next_sequence;
    }
    cur_sequence.len()
}

pub fn solve(look_and_say_sequence: &str) {
    println!("--- Day 10: Elves Look, Elves Say ---");
    println!("Part 1: {}", part_1(look_and_say_sequence));
    println!("Part 2: {}", part_2(look_and_say_sequence));
}
