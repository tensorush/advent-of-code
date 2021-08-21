fn final_part(message: &str) -> u64 {
    let words: Vec<&str> = message.split(' ').collect();
    let row = words[16][0..(words[16].len() - 1)].parse().unwrap();
    let col = words[18][0..(words[18].len() - 1)].parse().unwrap();
    let mut cur_row: u64 = 1;
    let mut cur_col: u64 = 1;
    let mut cur_code: u64 = 20_151_125;
    while (cur_row, cur_col) != (row, col) {
        if cur_row == 1 {
            cur_row = 1 + cur_col;
            cur_col = 1;
        } else {
            cur_col += 1;
            cur_row -= 1;
        }
        cur_code = (cur_code * 252_533) % 33_554_393;
    }
    cur_code
}

pub fn solve(message: &str) {
    println!("--- Day 25: Let It Snow ---");
    println!("Final Part: {}", final_part(message));
}
