use permutohedron::Heap;
use std::collections::{HashMap, HashSet};

pub fn solve(city_pairs: &str) {
    println!("--- Day 9: All in a Single Night ---");
    println!("Part 1: {}", part_1(city_pairs));
    println!("Part 2: {}", part_2(city_pairs));
}

fn part_1(city_pairs: &str) -> u32 {
    let mut distance;
    let mut words: Vec<&str>;
    let mut cities = HashSet::new();
    let mut distances = HashMap::new();
    for city_pair in city_pairs.lines() {
        words = city_pair.split(' ').collect();
        distance = words[4].parse().unwrap();
        let (from, to) = (words[0], words[2]);
        cities.insert(from);
        cities.insert(to);
        distances.insert((from, to), distance);
        distances.insert((to, from), distance);
    }
    let mut cities: Vec<&str> = cities.into_iter().collect();
    let routes = Heap::new(&mut cities);
    let mut route_distances: Vec<u32> = routes
        .map(|route| {
            let total_distance = route
                .windows(2)
                .map(|city_pair| {
                    let (from, to) = (city_pair[0], city_pair[1]);
                    distances.get(&(from, to)).unwrap()
                })
                .fold(0, |distance_1, distance_2| distance_1 + distance_2);
            total_distance
        })
        .collect();
    route_distances.sort();
    let shortest_distance = route_distances.first().unwrap().clone();
    shortest_distance
}

fn part_2(city_pairs: &str) -> u32 {
    let mut distance;
    let mut words: Vec<&str>;
    let mut cities = HashSet::new();
    let mut distances = HashMap::new();
    for city_pair in city_pairs.lines() {
        words = city_pair.split(' ').collect();
        distance = words[4].parse().unwrap();
        let (from, to) = (words[0], words[2]);
        cities.insert(from);
        cities.insert(to);
        distances.insert((from, to), distance);
        distances.insert((to, from), distance);
    }
    let mut cities: Vec<&str> = cities.into_iter().collect();
    let routes = Heap::new(&mut cities);
    let mut route_distances: Vec<u32> = routes
        .map(|route| {
            let total_distance = route
                .windows(2)
                .map(|city_pair| {
                    let (from, to) = (city_pair[0], city_pair[1]);
                    distances.get(&(from, to)).unwrap()
                })
                .fold(0, |distance_1, distance_2| distance_1 + distance_2);
            total_distance
        })
        .collect();
    route_distances.sort();
    let longest_distance = route_distances.last().unwrap().clone();
    longest_distance
}
