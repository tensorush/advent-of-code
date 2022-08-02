pub fn solve(instructions: &str) {
    println!("--- Day 1: Not Quite Lisp ---");
    println!("Part 1: {}", part_1(instructions));
    println!("Part 2: {}", part_2(instructions));
}

fn part_1(instructions: &str) -> i32 {
    let mut floor = 0;
    for direction in instructions.chars() {
        floor += if direction == '(' { 1 } else { -1 };
    }
    floor
}

fn part_2(instructions: &str) -> usize {
    let mut floor = 0;
    let mut position = 0;
    for (i, direction) in instructions.chars().enumerate() {
        floor += if direction == '(' { 1 } else { -1 };
        if floor == -1 {
            position = i + 1;
            break;
        }
    }
    position
}
