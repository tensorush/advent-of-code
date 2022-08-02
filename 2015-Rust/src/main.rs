use std::fs;
fn main() {
    let mut day = 1;
    while day < 26 {
        let file_path = format!("inputs/day_{:02}.txt", day);
        let input = fs::read_to_string(file_path).expect("Failed to read input");
        aoc_2016::solve(day)(&input);
        day += 1;
    }
}
