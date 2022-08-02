use std::collections::HashSet;

pub fn solve(directions: &str) {
    println!("--- Day 3: Perfectly Spherical Houses in a Vacuum ---");
    println!("Part 1: {}", part_1(directions));
    println!("Part 2: {}", part_2(directions));
}

#[derive(Default, Copy, Clone, Eq, PartialEq, Hash)]
struct Point {
    x: i32,
    y: i32,
}

fn part_1(directions: &str) -> usize {
    let mut santa: Point = Default::default();
    let mut visited_houses = HashSet::new();
    visited_houses.insert(santa);
    for direction in directions.chars() {
        match direction {
            '^' => santa.y += 1,
            'v' => santa.y -= 1,
            '>' => santa.x += 1,
            '<' => santa.x -= 1,
            _ => continue,
        }
        visited_houses.insert(santa);
    }
    visited_houses.len()
}

fn part_2(directions: &str) -> usize {
    let mut santa: Point = Default::default();
    let mut robo_santa: Point = Default::default();
    let mut visited_houses = HashSet::new();
    visited_houses.insert(santa);
    let mut cur_santa: &mut Point;
    for (i, direction) in directions.chars().enumerate() {
        cur_santa = if i % 2 == 0 {
            &mut santa
        } else {
            &mut robo_santa
        };
        match direction {
            '^' => cur_santa.y += 1,
            'v' => cur_santa.y -= 1,
            '>' => cur_santa.x += 1,
            '<' => cur_santa.x -= 1,
            _ => continue,
        }
        visited_houses.insert(cur_santa.clone());
    }
    visited_houses.len()
}
