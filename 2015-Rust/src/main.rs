use std::{fs, io};

fn main() {
    // Enter day
    let mut day: String = String::new();
    println!("Enter day: ");
    io::stdin().read_line(&mut day).expect("Failed to read day");

    // Parse day number
    let day_number: u8 = day.trim().parse().expect("Failed to parse day number");

    // Read respective input
    let filepath: String = format!("../inputs/day_{:02}.txt", day_number);
    let input: String = fs::read_to_string(filepath).expect("Failed to read input");

    // Get respective solution
    advent_of_code::solve(day_number)(&input);
}
