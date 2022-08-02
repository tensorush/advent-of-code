use std::collections::HashSet;
use std::str::from_utf8;

pub fn solve(cur_password: &str) {
    println!("--- Day 11: Corporate Policy ---");
    println!("Part 1: {}", part_1(cur_password));
    println!("Part 2: {}", part_2(cur_password));
}

fn part_1(cur_password: &str) -> String {
    let mut cur_bytes = [0; 8];
    let mut return_next_password = true;
    cur_bytes.copy_from_slice(cur_password.as_bytes());
    'outer: loop {
        if is_valid(&cur_bytes) {
            if return_next_password {
                return from_utf8(&cur_bytes).unwrap().to_string();
            } else {
                return_next_password = true;
            }
        }
        if cur_bytes[7] == b'z' {
            for index in (0..=6).rev() {
                if cur_bytes[index] != b'z' {
                    cur_bytes[index] += 1;
                    for byte in cur_bytes.iter_mut().skip(index + 1) {
                        *byte = b'a';
                    }
                    continue 'outer;
                }
            }
        } else {
            cur_bytes[7] += 1;
        }
    }
}

fn part_2(cur_password: &str) -> String {
    let mut cur_bytes = [0; 8];
    let mut return_next_password = false;
    cur_bytes.copy_from_slice(cur_password.as_bytes());
    'outer: loop {
        if is_valid(&cur_bytes) {
            if return_next_password {
                return std::str::from_utf8(&cur_bytes).unwrap().to_string();
            } else {
                return_next_password = true;
            }
        }
        if cur_bytes[7] == b'z' {
            for index in (0..=6).rev() {
                if cur_bytes[index] != b'z' {
                    cur_bytes[index] += 1;
                    for byte in cur_bytes.iter_mut().skip(index + 1) {
                        *byte = b'a';
                    }
                    continue 'outer;
                }
            }
        } else {
            cur_bytes[7] += 1;
        }
    }
}

fn is_valid(password_bytes: &[u8]) -> bool {
    let has_three_increasing_letters = password_bytes
        .windows(3)
        .any(|window| window[1] == window[0] + 1 && window[2] == window[1] + 1);
    if !has_three_increasing_letters {
        return false;
    }
    let has_confusing_letters = password_bytes
        .iter()
        .any(|b| [b'i', b'o', b'l'].contains(b));
    if has_confusing_letters {
        return false;
    }
    let mut double_letters = HashSet::new();
    for window in password_bytes.windows(2) {
        if window[0] == window[1] {
            double_letters.insert(window);
        }
    }
    let has_two_different_double_letters = double_letters.len() > 1;
    has_two_different_double_letters
}
