use std::cmp::{max, min};

pub fn solve(descriptions: &str) {
    println!("--- Day 14: Reindeer Olympics ---");
    println!("Part 1: {}", part_1(descriptions));
    println!("Part 2: {}", part_2(descriptions));
}

#[derive(Copy, Clone)]
struct Reindeer {
    speed: u32,
    points: u32,
    air_time: u32,
    rest_time: u32,
    distance: u32,
}

impl Reindeer {
    pub fn new(speed: u32, air_time: u32, rest_time: u32) -> Reindeer {
        Reindeer {
            speed,
            points: 0,
            air_time,
            rest_time,
            distance: 0,
        }
    }
}

fn part_1(descriptions: &str) -> u32 {
    let mut speed;
    let mut air_time;
    let mut rest_time;
    let mut words: Vec<&str>;
    let mut reindeers = Vec::new();
    for description in descriptions.lines() {
        words = description.split(' ').collect();
        speed = words[3].parse().unwrap();
        air_time = words[6].parse().unwrap();
        rest_time = words[13].parse().unwrap();
        reindeers.push(Reindeer::new(speed, air_time, rest_time));
    }
    const TIME: u32 = 2503;
    let mut cycle_time;
    let mut cycle_distance;
    let mut remaining_time;
    let mut winner_distance = 0;
    let mut full_cycles_distance;
    let mut remaining_time_speed;
    let mut remaining_time_distance;
    for deer in reindeers.iter_mut() {
        cycle_time = deer.air_time + deer.rest_time;
        cycle_distance = deer.speed * deer.air_time;
        full_cycles_distance = (TIME / cycle_time) * cycle_distance;
        remaining_time = TIME % cycle_time;
        remaining_time_speed = min(remaining_time, deer.air_time);
        remaining_time_distance = deer.speed * remaining_time_speed;
        deer.distance = full_cycles_distance + remaining_time_distance;
        winner_distance = max(winner_distance, deer.distance);
    }
    reindeers.iter().map(|deer| deer.distance).max().unwrap()
}

fn part_2(descriptions: &str) -> u32 {
    let mut speed;
    let mut air_time;
    let mut rest_time;
    let mut words: Vec<&str>;
    let mut reindeers = Vec::new();
    for description in descriptions.lines() {
        words = description.split(' ').collect();
        speed = words[3].parse().unwrap();
        air_time = words[6].parse().unwrap();
        rest_time = words[13].parse().unwrap();
        reindeers.push(Reindeer::new(speed, air_time, rest_time));
    }
    const TIME: u32 = 2503;
    let mut cycle_time;
    let mut cycle_distance;
    let mut remaining_time;
    let mut winner_distance = 0;
    let mut full_cycles_distance;
    let mut remaining_time_speed;
    let mut remaining_time_distance;
    for time in 1..=TIME {
        for deer in reindeers.iter_mut() {
            cycle_time = deer.air_time + deer.rest_time;
            cycle_distance = deer.speed * deer.air_time;
            full_cycles_distance = (time / cycle_time) * cycle_distance;
            remaining_time = time % cycle_time;
            remaining_time_speed = min(remaining_time, deer.air_time);
            remaining_time_distance = deer.speed * remaining_time_speed;
            deer.distance = full_cycles_distance + remaining_time_distance;
            winner_distance = max(winner_distance, deer.distance);
        }
        for deer in reindeers.iter_mut() {
            if deer.distance == winner_distance {
                deer.points += 1;
            }
        }
    }
    reindeers.iter().map(|deer| deer.points).max().unwrap()
}
