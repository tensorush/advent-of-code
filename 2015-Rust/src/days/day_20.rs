fn part_1(input: &str) -> usize {
    const PRESENT_MULTIPLIER: usize = 10;
    const MAX_VISITS: usize = usize::MAX;
    let num_presents: usize = input.parse().unwrap();
    let highest_house_number: usize = num_presents / PRESENT_MULTIPLIER;
    let mut presents: Vec<usize> = vec![0; highest_house_number];
    for elf_number in 1..highest_house_number {
        for house_number in (elf_number..highest_house_number)
            .step_by(elf_number)
            .take(MAX_VISITS)
        {
            presents[house_number] += elf_number * PRESENT_MULTIPLIER;
        }
    }
    presents
        .iter()
        .enumerate()
        .find(|&(_index, &cur_num_presents)| cur_num_presents >= num_presents)
        .map(|(index, _cur_num_presents)| index)
        .unwrap()
}

fn part_2(input: &str) -> usize {
    const PRESENT_MULTIPLIER: usize = 11;
    const MAX_VISITS: usize = 50;
    let num_presents: usize = input.parse().unwrap();
    let highest_house_number: usize = num_presents / PRESENT_MULTIPLIER;
    let mut presents: Vec<usize> = vec![0; highest_house_number];
    for elf_number in 1..highest_house_number {
        for house_number in (elf_number..highest_house_number)
            .step_by(elf_number)
            .take(MAX_VISITS)
        {
            presents[house_number] += elf_number * PRESENT_MULTIPLIER;
        }
    }
    presents
        .iter()
        .enumerate()
        .find(|&(_index, &cur_num_presents)| cur_num_presents >= num_presents)
        .map(|(index, _cur_num_presents)| index)
        .unwrap()
}

pub fn solve(input: &str) {
    println!("--- Day 20: Infinite Elves and Infinite Houses ---");
    println!("Part 1: {}", part_1(input));
    println!("Part 2: {}", part_2(input));
}
