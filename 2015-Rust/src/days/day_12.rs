use serde_json::{from_str, json, Value};

pub fn solve(document: &str) {
    println!("--- Day 12: JSAbacusFramework.io ---");
    println!("Part 1: {}", part_1(document));
    println!("Part 2: {}", part_2(document));
}

fn part_1(document: &str) -> i64 {
    let value = from_str(&document).unwrap();
    fn sum_numbers(value: &Value) -> i64 {
        match value {
            Value::Number(number) => number.as_i64().unwrap(),
            Value::Object(object) => object
                .iter()
                .map(|(_, next_value)| sum_numbers(next_value))
                .sum(),
            Value::Array(array) => array.iter().map(|next_value| sum_numbers(next_value)).sum(),
            _ => 0,
        }
    }
    let numbers_sum = sum_numbers(&value);
    numbers_sum
}

fn part_2(document: &str) -> i64 {
    let red = json!("red");
    let value = from_str(&document).unwrap();
    fn sum_numbers(value: &Value, red: &Value) -> i64 {
        match value {
            Value::Number(number) => number.as_i64().unwrap(),
            Value::Object(object) => {
                if object.iter().any(|(_, next_value)| next_value == red) {
                    0
                } else {
                    object
                        .iter()
                        .map(|(_, next_value)| sum_numbers(next_value, red))
                        .sum()
                }
            }
            Value::Array(array) => array
                .iter()
                .map(|next_value| sum_numbers(next_value, red))
                .sum(),
            _ => 0,
        }
    }
    let numbers_sum = sum_numbers(&value, &red);
    numbers_sum
}
