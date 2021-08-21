use permutohedron::Heap;
use std::collections::{HashMap, HashSet};

fn part_1(guest_list: &str) -> i32 {
    let mut guests: HashSet<&str> = HashSet::new();
    let mut happiness_changes: HashMap<(&str, &str), i32> = HashMap::new();
    for guest in guest_list.lines() {
        let words: Vec<&str> = guest.split(' ').collect();
        let guest: &str = words[0];
        let mut happiness: i32 = words[3].parse().unwrap();
        if words[2] == "lose" {
            happiness = -happiness;
        }
        let neighbour: &str = words[10].strip_suffix('.').unwrap();
        guests.insert(guest);
        guests.insert(neighbour);
        happiness_changes.insert((guest, neighbour), happiness);
    }
    let num_guests: usize = guests.len();
    let mut guests: Vec<&str> = guests.into_iter().collect();
    let seatings: Heap<Vec<&str>, &str> = Heap::new(&mut guests);
    let mut total_happiness_changes: Vec<i32> = seatings
        .map(|seating| {
            let total_happiness_change: i32 = seating
                .iter()
                .enumerate()
                .map(|(i, guest)| {
                    let neighbour_1: &str = seating[((i + num_guests) - 1) % num_guests];
                    let neighbour_2: &str = seating[(i + 1) % num_guests];
                    let mut happiness_change: i32 = 0;
                    happiness_change += happiness_changes.get(&(guest, neighbour_1)).unwrap();
                    happiness_change += happiness_changes.get(&(guest, neighbour_2)).unwrap();
                    happiness_change
                })
                .fold(0, |change_1, change_2| change_1 + change_2);
            total_happiness_change
        })
        .collect();
    total_happiness_changes.sort();
    let optimal_total_happiness_change: i32 = total_happiness_changes.last().unwrap().clone();
    optimal_total_happiness_change
}

fn part_2(guest_list: &str) -> i32 {
    let mut guests: HashSet<&str> = HashSet::new();
    let mut happiness_changes: HashMap<(&str, &str), i32> = HashMap::new();
    for guest in guest_list.lines() {
        let words: Vec<&str> = guest.split(' ').collect();
        let guest: &str = words[0];
        let mut happiness: i32 = words[3].parse().unwrap();
        if words[2] == "lose" {
            happiness = -happiness;
        }
        let neighbour: &str = words[10].strip_suffix('.').unwrap();
        guests.insert(guest);
        guests.insert(neighbour);
        happiness_changes.insert((guest, neighbour), happiness);
    }
    for guest in &guests {
        happiness_changes.insert((guest, "Me"), 0);
        happiness_changes.insert(("Me", guest), 0);
    }
    guests.insert("Me");
    let num_guests: usize = guests.len();
    let mut guests: Vec<&str> = guests.into_iter().collect();
    let seatings: Heap<Vec<&str>, &str> = Heap::new(&mut guests);
    let mut total_happiness_changes: Vec<i32> = seatings
        .map(|seating| {
            let total_happiness_change: i32 = seating
                .iter()
                .enumerate()
                .map(|(i, guest)| {
                    let neighbour_1: &str = seating[((i + num_guests) - 1) % num_guests];
                    let neighbour_2: &str = seating[(i + 1) % num_guests];
                    let mut happiness_change: i32 = 0;
                    happiness_change += happiness_changes.get(&(guest, neighbour_1)).unwrap();
                    happiness_change += happiness_changes.get(&(guest, neighbour_2)).unwrap();
                    happiness_change
                })
                .fold(0, |change_1, change_2| change_1 + change_2);
            total_happiness_change
        })
        .collect();
    total_happiness_changes.sort();
    let optimal_total_happiness_change: i32 = total_happiness_changes.last().unwrap().clone();
    optimal_total_happiness_change
}

pub fn solve(guest_list: &str) {
    println!("--- Day 13: Knights of the Dinner Table ---");
    println!("Part 1: {}", part_1(guest_list));
    println!("Part 2: {}", part_2(guest_list));
}
