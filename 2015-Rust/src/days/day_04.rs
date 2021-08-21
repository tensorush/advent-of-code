use md5::{Context, Digest};

fn part_1(secret_key: &str) -> u64 {
    let mut number: u64 = 1;
    let mut digest: Digest;
    let mut context: Context;
    let mut starts_with_five_zeros: bool;
    loop {
        context = Context::new();
        context.consume(secret_key.as_bytes());
        context.consume(number.to_string().as_bytes());
        digest = context.compute();
        starts_with_five_zeros = format!("{:x}", digest).starts_with("00000");
        if starts_with_five_zeros {
            break;
        }
        number += 1;
    }
    number
}

fn part_2(secret_key: &str) -> u64 {
    let mut number: u64 = 1;
    let mut digest: Digest;
    let mut context: Context;
    let mut starts_with_six_zeros: bool;
    loop {
        context = Context::new();
        context.consume(secret_key.as_bytes());
        context.consume(number.to_string().as_bytes());
        digest = context.compute();
        starts_with_six_zeros = format!("{:x}", digest).starts_with("000000");
        if starts_with_six_zeros {
            break;
        }
        number += 1;
    }
    number
}

pub fn solve(secret_key: &str) {
    println!("--- Day 4: The Ideal Stocking Stuffer ---");
    println!("Part 1: {}", part_1(secret_key));
    println!("Part 2: {}", part_2(secret_key));
}
