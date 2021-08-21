use std::collections::HashMap;

fn part_1(aunt_list: &str) -> usize {
    let mut correct_aunt: HashMap<&str, u32> = HashMap::new();
    correct_aunt.insert("children", 3);
    correct_aunt.insert("cats", 7);
    correct_aunt.insert("samoyeds", 2);
    correct_aunt.insert("pomeranians", 3);
    correct_aunt.insert("akitas", 0);
    correct_aunt.insert("vizslas", 0);
    correct_aunt.insert("goldfish", 5);
    correct_aunt.insert("trees", 3);
    correct_aunt.insert("cars", 2);
    correct_aunt.insert("perfumes", 1);
    let mut item_name: &str;
    let mut item_value: u32;
    let mut words: Vec<&str>;
    let mut is_matching: bool;
    let mut correct_value: u32;
    let mut correct_aunt_number: usize = 0;
    'outer: for (i, aunt) in aunt_list.lines().enumerate() {
        words = aunt.split(' ').collect();
        for j in (2..words.len()).step_by(2) {
            item_name = words[j].strip_suffix(':').unwrap();
            item_value = words[j + 1]
                .strip_suffix(',')
                .unwrap_or(words[j + 1])
                .parse()
                .unwrap();
            correct_value = correct_aunt.get(item_name).unwrap().clone();
            is_matching = correct_value == item_value;
            if !is_matching {
                continue 'outer;
            }
        }
        correct_aunt_number = i + 1;
        break;
    }
    correct_aunt_number
}

fn part_2(aunt_list: &str) -> usize {
    let mut correct_aunt: HashMap<&str, u32> = HashMap::new();
    correct_aunt.insert("children", 3);
    correct_aunt.insert("cats", 7);
    correct_aunt.insert("samoyeds", 2);
    correct_aunt.insert("pomeranians", 3);
    correct_aunt.insert("akitas", 0);
    correct_aunt.insert("vizslas", 0);
    correct_aunt.insert("goldfish", 5);
    correct_aunt.insert("trees", 3);
    correct_aunt.insert("cars", 2);
    correct_aunt.insert("perfumes", 1);
    let mut item_name: &str;
    let mut item_value: u32;
    let mut words: Vec<&str>;
    let mut is_matching: bool;
    let mut correct_value: u32;
    let mut correct_aunt_number: usize = 0;
    'outer: for (i, aunt) in aunt_list.lines().enumerate() {
        words = aunt.split(' ').collect();
        for j in (2..words.len()).step_by(2) {
            item_name = words[j].strip_suffix(':').unwrap();
            item_value = words[j + 1]
                .strip_suffix(',')
                .unwrap_or(words[j + 1])
                .parse()
                .unwrap();
            correct_value = correct_aunt.get(item_name).unwrap().clone();
            is_matching = match item_name {
                "cats" | "trees" => correct_value < item_value,
                "pomeranians" | "goldfish" => correct_value > item_value,
                _ => correct_value == item_value,
            };
            if !is_matching {
                continue 'outer;
            }
        }
        correct_aunt_number = i + 1;
        break;
    }
    correct_aunt_number
}

pub fn solve(aunt_list: &str) {
    println!("--- Day 16: Aunt Sue ---");
    println!("Part 1: {}", part_1(aunt_list));
    println!("Part 2: {}", part_2(aunt_list));
}
