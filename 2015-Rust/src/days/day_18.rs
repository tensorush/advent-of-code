fn part_1(configuration: &str) -> usize {
    const NUM_SIDE_LIGHTS: i32 = 100;
    const NUM_TOTAL_LIGHTS: usize = (NUM_SIDE_LIGHTS * NUM_SIDE_LIGHTS) as usize;
    let mut grid: [bool; NUM_TOTAL_LIGHTS] = [false; NUM_TOTAL_LIGHTS];
    for (y, line) in configuration.lines().enumerate() {
        for (x, light) in line.chars().enumerate() {
            grid[x + y * 100] = light == '#';
        }
    }
    let mut new_x: i32;
    let mut new_y: i32;
    const NUM_STEPS: i32 = 100;
    let mut num_turned_on_neighbours: i32;
    let mut new_grid: [bool; NUM_TOTAL_LIGHTS];
    for _step in 0..NUM_STEPS {
        new_grid = [false; NUM_TOTAL_LIGHTS];
        for x in 0..NUM_SIDE_LIGHTS {
            for y in 0..NUM_SIDE_LIGHTS {
                num_turned_on_neighbours = 0;
                for dx in -1..=1 {
                    for dy in -1..=1 {
                        new_x = x + dx;
                        new_y = y + dy;
                        if !(dx == 0 && dy == 0)
                            && (new_x >= 0 && new_x < 100)
                            && (new_y >= 0 && new_y < 100)
                            && grid[(new_x + new_y * 100) as usize]
                        {
                            num_turned_on_neighbours += 1;
                        }
                    }
                }
                new_grid[(x + y * 100) as usize] =
                    if (x >= 0 && x < 100) && (y >= 0 && y < 100) && grid[(x + y * 100) as usize] {
                        num_turned_on_neighbours == 2 || num_turned_on_neighbours == 3
                    } else {
                        num_turned_on_neighbours == 3
                    };
            }
        }
        grid = new_grid;
    }
    let num_turned_on_lights: usize = grid.iter().filter(|&&light| light).count();
    num_turned_on_lights
}

fn part_2(configuration: &str) -> usize {
    const NUM_SIDE_LIGHTS: i32 = 100;
    const NUM_TOTAL_LIGHTS: usize = (NUM_SIDE_LIGHTS * NUM_SIDE_LIGHTS) as usize;
    let mut grid: [bool; NUM_TOTAL_LIGHTS] = [false; NUM_TOTAL_LIGHTS];
    for (y, line) in configuration.lines().enumerate() {
        for (x, light) in line.chars().enumerate() {
            grid[x + y * 100] = light == '#';
        }
    }
    let mut new_x: i32;
    let mut new_y: i32;
    const NUM_STEPS: i32 = 100;
    let mut num_turned_on_neighbours: i32;
    let mut new_grid: [bool; NUM_TOTAL_LIGHTS];
    for _step in 0..NUM_STEPS {
        new_grid = [false; NUM_TOTAL_LIGHTS];
        for x in 0..NUM_SIDE_LIGHTS {
            for y in 0..NUM_SIDE_LIGHTS {
                num_turned_on_neighbours = 0;
                for dx in -1..=1 {
                    for dy in -1..=1 {
                        new_x = x + dx;
                        new_y = y + dy;
                        if !(dx == 0 && dy == 0)
                            && (((new_x, new_y) == (0, 0)
                                || (new_x, new_y) == (0, 99)
                                || (new_x, new_y) == (99, 0)
                                || (new_x, new_y) == (99, 99))
                                || ((new_x >= 0 && new_x < 100)
                                    && (new_y >= 0 && new_y < 100)
                                    && grid[(new_x + new_y * 100) as usize]))
                        {
                            num_turned_on_neighbours += 1;
                        }
                    }
                }
                new_grid[(x + y * 100) as usize] = if (x, y) == (0, 0)
                    || (x, y) == (0, 99)
                    || (x, y) == (99, 0)
                    || (x, y) == (99, 99)
                {
                    true
                } else if (x >= 0 && x < 100) && (y >= 0 && y < 100) && grid[(x + y * 100) as usize]
                {
                    num_turned_on_neighbours == 2 || num_turned_on_neighbours == 3
                } else {
                    num_turned_on_neighbours == 3
                };
            }
        }
        grid = new_grid;
    }
    let num_turned_on_lights: usize = grid.iter().filter(|&&light| light).count();
    num_turned_on_lights
}

pub fn solve(configuration: &str) {
    println!("--- Day 18: Like a GIF For Your Yard ---");
    println!("Part 1: {}", part_1(configuration));
    println!("Part 2: {}", part_2(configuration));
}
