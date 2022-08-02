use std::cmp::max;
use std::collections::HashSet;

pub fn solve(recipe: &str) {
    println!("--- Day 15: Science for Hungry People ---");
    println!("Part 1: {}", part_1(recipe));
    println!("Part 2: {}", part_2(recipe));
}

#[derive(Copy, Clone)]
struct Ingredient {
    capacity: i32,
    durability: i32,
    flavour: i32,
    texture: i32,
    calories: i32,
}

fn calculate_total_score(
    ingredients: &Vec<Ingredient>,
    num_ingredient_1: i32,
    num_ingredient_2: i32,
    num_ingredient_3: i32,
    num_ingredient_4: i32,
) -> i32 {
    let capacity_score = max(
        0,
        num_ingredient_1 * ingredients[0].capacity
            + num_ingredient_2 * ingredients[1].capacity
            + num_ingredient_3 * ingredients[2].capacity
            + num_ingredient_4 * ingredients[3].capacity,
    );
    let durability_score = max(
        0,
        num_ingredient_1 * ingredients[0].durability
            + num_ingredient_2 * ingredients[1].durability
            + num_ingredient_3 * ingredients[2].durability
            + num_ingredient_4 * ingredients[3].durability,
    );
    let flavour_score = max(
        0,
        num_ingredient_1 * ingredients[0].flavour
            + num_ingredient_2 * ingredients[1].flavour
            + num_ingredient_3 * ingredients[2].flavour
            + num_ingredient_4 * ingredients[3].flavour,
    );
    let texture_score = max(
        0,
        num_ingredient_1 * ingredients[0].texture
            + num_ingredient_2 * ingredients[1].texture
            + num_ingredient_3 * ingredients[2].texture
            + num_ingredient_4 * ingredients[3].texture,
    );
    capacity_score * durability_score * flavour_score * texture_score
}

fn part_1(recipe: &str) -> i32 {
    let mut flavour;
    let mut texture;
    let mut capacity;
    let mut calories;
    let mut durability;
    let mut words: Vec<&str>;
    let mut ingredients = Vec::new();
    for recipe_item in recipe.lines() {
        words = recipe_item.split(' ').collect();
        capacity = words[2][0..words[2].len() - 1].parse().unwrap();
        durability = words[4][0..words[4].len() - 1].parse().unwrap();
        flavour = words[6][0..words[6].len() - 1].parse().unwrap();
        texture = words[8][0..words[8].len() - 1].parse().unwrap();
        calories = words[10].parse().unwrap();
        ingredients.push(Ingredient {
            capacity,
            durability,
            flavour,
            texture,
            calories,
        });
    }
    let mut total_score;
    let mut num_ingredient_4;
    const NUM_TEASPOONS: i32 = 100;
    let mut total_scores = HashSet::new();
    for num_ingredient_1 in 0..NUM_TEASPOONS {
        for num_ingredient_2 in 0..NUM_TEASPOONS - num_ingredient_1 {
            for num_ingredient_3 in 0..NUM_TEASPOONS - num_ingredient_1 - num_ingredient_2 {
                num_ingredient_4 =
                    NUM_TEASPOONS - num_ingredient_1 - num_ingredient_2 - num_ingredient_3;
                total_score = calculate_total_score(
                    &ingredients,
                    num_ingredient_1,
                    num_ingredient_2,
                    num_ingredient_3,
                    num_ingredient_4,
                );
                total_scores.insert(total_score);
            }
        }
    }
    let best_total_score = *total_scores.iter().max().unwrap();
    best_total_score
}

fn part_2(recipe: &str) -> i32 {
    let mut flavour;
    let mut texture;
    let mut capacity;
    let mut calories;
    let mut durability;
    let mut words: Vec<&str>;
    let mut ingredients = Vec::new();
    for recipe_item in recipe.lines() {
        words = recipe_item.split(' ').collect();
        capacity = words[2][0..words[2].len() - 1].parse().unwrap();
        durability = words[4][0..words[4].len() - 1].parse().unwrap();
        flavour = words[6][0..words[6].len() - 1].parse().unwrap();
        texture = words[8][0..words[8].len() - 1].parse().unwrap();
        calories = words[10].parse().unwrap();
        ingredients.push(Ingredient {
            capacity,
            durability,
            flavour,
            texture,
            calories,
        });
    }
    let mut total_score;
    let mut calories_score;
    let mut num_ingredient_4;
    const MAX_CALORIES: i32 = 500;
    const NUM_TEASPOONS: i32 = 100;
    let mut total_scores = HashSet::new();
    for num_ingredient_1 in 0..NUM_TEASPOONS {
        for num_ingredient_2 in 0..NUM_TEASPOONS - num_ingredient_1 {
            for num_ingredient_3 in 0..NUM_TEASPOONS - num_ingredient_1 - num_ingredient_2 {
                num_ingredient_4 =
                    NUM_TEASPOONS - num_ingredient_1 - num_ingredient_2 - num_ingredient_3;
                calories_score = max(
                    0,
                    num_ingredient_1 * ingredients[0].calories
                        + num_ingredient_2 * ingredients[1].calories
                        + num_ingredient_3 * ingredients[2].calories
                        + num_ingredient_4 * ingredients[3].calories,
                );
                if calories_score == MAX_CALORIES {
                    total_score = calculate_total_score(
                        &ingredients,
                        num_ingredient_1,
                        num_ingredient_2,
                        num_ingredient_3,
                        num_ingredient_4,
                    );
                    total_scores.insert(total_score);
                }
            }
        }
    }
    let best_total_score = *total_scores.iter().max().unwrap();
    best_total_score
}
