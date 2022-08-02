pub fn solve(inventory: &str) {
    println!("--- Day 17: No Such Thing as Too Much ---");
    println!("Part 1: {}", part_1(inventory));
    println!("Part 2: {}", part_2(inventory));
}

fn part_1(inventory: &str) -> u32 {
    const TOTAL_SIZE: usize = 150;
    let container_sizes: Vec<usize> = inventory
        .lines()
        .map(|container_size| container_size.parse().unwrap())
        .collect();
    let mut num_combinations = [0; TOTAL_SIZE + 1];
    num_combinations[0] = 1;
    for container_size in container_sizes {
        for next_size in (container_size..=TOTAL_SIZE).rev() {
            num_combinations[next_size] += num_combinations[next_size - container_size];
        }
    }
    num_combinations[TOTAL_SIZE]
}

fn part_2(inventory: &str) -> usize {
    const TOTAL_SIZE: usize = 150;
    let container_sizes: Vec<usize> = inventory
        .lines()
        .map(|container_size| container_size.parse().unwrap())
        .collect();
    let mut num_bits: usize = 0;
    let num_containers = container_sizes.len();
    for i in 0..num_containers {
        num_bits |= 1 << i;
    }
    let mut total_size: usize;
    let mut min_num_containers;
    let mut num_combinations = 0;
    for possible_num_containers in 1..=num_containers {
        num_combinations = 0;
        for bit_mask in 1..=num_bits {
            min_num_containers = bit_mask.count_ones() as usize;
            if min_num_containers == possible_num_containers {
                total_size = container_sizes
                    .iter()
                    .enumerate()
                    .filter(|&(index, _size)| (1 << index) & bit_mask > 0)
                    .map(|(_index, size)| size)
                    .sum();
                if total_size == TOTAL_SIZE {
                    num_combinations += 1;
                }
            }
        }
        if num_combinations != 0 {
            break;
        }
    }
    num_combinations
}
