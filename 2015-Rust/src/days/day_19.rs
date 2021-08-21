use std::collections::{HashMap, HashSet};

fn part_1(input: &str) -> usize {
    let mut medicine_molecule: String = String::new();
    let mut replacements: HashMap<&str, Vec<&str>> = HashMap::new();
    for line in input.lines() {
        if line.is_empty() {
            continue;
        } else if let Some((from, to)) = line.split_once(" => ") {
            replacements.entry(from).or_insert_with(Vec::new).push(to);
        } else {
            medicine_molecule = line.to_string();
        }
    }
    let mut distinct_molecule: String;
    let mut distinct_molecules: HashSet<String> = HashSet::new();
    for (&from, to_options) in replacements.iter() {
        for (start_index, _) in medicine_molecule.match_indices(from) {
            for &to in to_options.iter() {
                distinct_molecule = format!(
                    "{}{}{}",
                    &medicine_molecule[..start_index],
                    to,
                    &medicine_molecule[start_index + from.len()..]
                );
                distinct_molecules.insert(distinct_molecule);
            }
        }
    }
    distinct_molecules.len()
}

fn part_2(input: &str) -> u32 {
    let mut medicine_molecule: String = String::new();
    let mut replacements: HashMap<&str, Vec<&str>> = HashMap::new();
    for line in input.lines() {
        if line.is_empty() {
            continue;
        } else if let Some((from, to)) = line.split_once(" => ") {
            replacements.entry(from).or_insert_with(Vec::new).push(to);
        } else {
            medicine_molecule = line.to_string();
        }
    }
    let mut min_num_steps: u32 = 0;
    let mut reversed_molecule: String = medicine_molecule.chars().rev().collect();
    let reversed_replacements: Vec<(String, String)> = replacements
        .into_iter()
        .flat_map(|(from, to_options)| {
            let reversed_from: String = from.chars().rev().collect();
            to_options.into_iter().map(move |to| {
                let reversed_to: String = to.chars().rev().collect();
                (reversed_to, reversed_from.clone())
            })
        })
        .collect();
    while reversed_molecule.len() != 1 {
        if let Some((index, reversed_to, reversed_from)) = reversed_replacements
            .iter()
            .filter_map(|(reversed_to, reversed_from)| {
                reversed_molecule
                    .find(reversed_to)
                    .map(|index| (index, reversed_to, reversed_from))
            })
            .min()
        {
            reversed_molecule = format!(
                "{}{}{}",
                &reversed_molecule[..index],
                reversed_from,
                &reversed_molecule[(index + reversed_to.len())..]
            );
            min_num_steps += 1;
        }
    }
    min_num_steps
}

pub fn solve(input: &str) {
    println!("--- Day 19: Medicine for Rudolph ---");
    println!("Part 1: {}", part_1(input));
    println!("Part 2: {}", part_2(input));
}
