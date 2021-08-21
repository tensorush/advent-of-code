fn form_groups(
    weights: &[u64],
    cur_group: Vec<u64>,
    cur_group_size: u64,
    max_group_size: u64,
    max_group_weight: u64,
) -> Vec<Vec<u64>> {
    if cur_group_size >= max_group_size {
        return vec![];
    }
    let cur_group_weight: u64 = cur_group.iter().sum();
    if cur_group_weight == max_group_weight {
        return vec![cur_group];
    }
    if cur_group_weight > max_group_weight {
        return vec![];
    }
    weights
        .iter()
        .enumerate()
        .flat_map(|(i, n)| {
            let left_weights: &[u64] = &weights[i + 1..];
            let next_group_size: u64 = cur_group_size + 1;
            let mut next_group: Vec<u64> = cur_group.clone();
            next_group.extend(vec![n]);
            form_groups(
                left_weights,
                next_group,
                next_group_size,
                max_group_size,
                max_group_weight,
            )
        })
        .collect()
}

fn part_1(input: &str) -> u64 {
    let mut weights: Vec<u64> = vec![];
    for line in input.lines() {
        weights.push(line.parse().unwrap());
    }
    const NUM_GROUPS: u64 = 3;
    let num_packages: u64 = weights.len() as u64;
    let total_weight: u64 = weights.iter().sum();
    let max_group_size: u64 = num_packages / NUM_GROUPS;
    let max_group_weight: u64 = total_weight / NUM_GROUPS;
    let groups: Vec<Vec<u64>> = form_groups(&weights, vec![], 0, max_group_size, max_group_weight);
    let smallest_group_size: usize = groups.iter().map(|x| x.len()).min().unwrap();
    let mut smallest_groups: Vec<u64> = groups
        .iter()
        .filter(|x| x.len() == smallest_group_size)
        .map(|x| x.iter().product())
        .collect();
    smallest_groups.sort();
    let ideal_quantum_entanglement: u64 = smallest_groups.first().unwrap().clone();
    ideal_quantum_entanglement
}

fn part_2(input: &str) -> u64 {
    let mut weights: Vec<u64> = vec![];
    for line in input.lines() {
        weights.push(line.parse().unwrap());
    }
    const NUM_GROUPS: u64 = 4;
    let num_packages: u64 = weights.len() as u64;
    let total_weight: u64 = weights.iter().sum();
    let max_group_size: u64 = num_packages / NUM_GROUPS;
    let max_group_weight: u64 = total_weight / NUM_GROUPS;
    let groups: Vec<Vec<u64>> = form_groups(&weights, vec![], 0, max_group_size, max_group_weight);
    let smallest_group_size: usize = groups.iter().map(|x| x.len()).min().unwrap();
    let mut smallest_groups: Vec<u64> = groups
        .iter()
        .filter(|x| x.len() == smallest_group_size)
        .map(|x| x.iter().product())
        .collect();
    smallest_groups.sort();
    let ideal_quantum_entanglement: u64 = smallest_groups.first().unwrap().clone();
    ideal_quantum_entanglement
}

pub fn solve(input: &str) {
    println!("--- Day 24: It Hangs in the Balance ---");
    println!("Part 1: {}", part_1(input));
    println!("Part 2: {}", part_2(input));
}
