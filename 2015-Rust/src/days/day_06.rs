pub fn solve(instructions: &str) {
    println!("--- Day 6: Probably a Fire Hazard ---");
    println!("Part 1: {}", part_1(instructions));
    println!("Part 2: {}", part_2(instructions));
}

fn part_1(instructions: &str) -> u32 {
    let mut index;
    let mut is_toggle;
    let mut words: Vec<&str>;
    const NUM_LIGHTS: usize = 1_000_000;
    let mut grid: [u8; NUM_LIGHTS] = [0; NUM_LIGHTS];
    for instruction in instructions.lines() {
        words = instruction.split(' ').collect();
        is_toggle = words[0] == "toggle";
        let (from, to) = if is_toggle {
            (words[1], words[3])
        } else {
            (words[2], words[4])
        };
        let (from_x, from_y) = parse_range(from);
        let (to_x, to_y) = parse_range(to);
        for x in from_x..=to_x {
            for y in from_y..=to_y {
                index = x + y * 1000;
                grid[index] = match words[1] {
                    "on" => 1,
                    "off" => 0,
                    _ => {
                        if grid[index] == 0 {
                            1
                        } else {
                            0
                        }
                    }
                };
            }
        }
    }
    let num_turned_on_lights: u32 = grid.iter().map(|&i| i as u32).sum();
    num_turned_on_lights
}

fn part_2(instructions: &str) -> u32 {
    let mut index;
    let mut is_toggle;
    let mut words: Vec<&str>;
    const NUM_LIGHTS: usize = 1_000_000;
    let mut grid: [u8; NUM_LIGHTS] = [0; NUM_LIGHTS];
    for instruction in instructions.lines() {
        words = instruction.split(' ').collect();
        is_toggle = words[0] == "toggle";
        let (from, to) = if is_toggle {
            (words[1], words[3])
        } else {
            (words[2], words[4])
        };
        let (from_x, from_y) = parse_range(from);
        let (to_x, to_y) = parse_range(to);
        for x in from_x..=to_x {
            for y in from_y..=to_y {
                index = x + y * 1000;
                grid[index] = match words[1] {
                    "on" => grid[index] + 1,
                    "off" => grid[index] - if grid[index] == 0 { 0 } else { 1 },
                    _ => grid[index] + 2,
                };
            }
        }
    }
    let num_turned_on_lights = grid.iter().map(|&i| i as u32).sum();
    num_turned_on_lights
}

fn parse_range(range: &str) -> (usize, usize) {
    range
        .split_once(',')
        .and_then(|(x, y)| Some((x.parse().unwrap(), y.parse().unwrap())))
        .unwrap()
}
