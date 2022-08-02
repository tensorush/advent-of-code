pub fn solve(presents_list: &str) {
    println!("--- Day 2: I Was Told There Would Be No Math ---");
    println!("Part 1: {}", part_1(presents_list));
    println!("Part 2: {}", part_2(presents_list));
}

fn part_1(presents_list: &str) -> u32 {
    let total_wrapping_paper = presents_list
        .lines()
        .map(|present| -> u32 {
            let dimensions: Vec<u32> = present
                .split('x')
                .map(|dimension| dimension.parse().unwrap())
                .collect();
            let sides = [
                dimensions[0] * dimensions[1],
                dimensions[1] * dimensions[2],
                dimensions[2] * dimensions[0],
            ];
            let surface_area = 2 * sides.iter().sum::<u32>();
            let smallest_side = *sides.iter().min().unwrap();
            surface_area + smallest_side
        })
        .sum();
    total_wrapping_paper
}

fn part_2(presents_list: &str) -> u32 {
    let total_ribbon = presents_list
        .lines()
        .map(|present| -> u32 {
            let mut dimensions: Vec<u32> = present
                .split('x')
                .map(|dimension| dimension.parse().unwrap())
                .collect();
            dimensions.sort_unstable();
            let smallest_perimeter = 2 * (dimensions[0] + dimensions[1]);
            let volume: u32 = dimensions.iter().product();
            smallest_perimeter + volume
        })
        .sum();
    total_ribbon
}
