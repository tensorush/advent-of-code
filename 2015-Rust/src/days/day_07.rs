use std::collections::HashMap;

pub fn solve(instructions: &str) {
    println!("--- Day 7: Some Assembly Required ---");
    println!("Part 1: {}", part_1(instructions));
    println!("Part 2: {}", part_2(instructions));
}

#[derive(Copy, Clone)]
enum Operation<'a> {
    Put(&'a str),
    Not(&'a str),
    Or(&'a str, &'a str),
    And(&'a str, &'a str),
    LShift(&'a str, &'a str),
    RShift(&'a str, &'a str),
}

#[derive(Copy, Clone)]
struct Gate<'a> {
    operation: Operation<'a>,
    output: Option<u16>,
}

impl<'a> Gate<'a> {
    const fn new(operation: Operation<'a>) -> Self {
        Gate {
            operation,
            output: None,
        }
    }
}

fn part_1(instructions: &str) -> u16 {
    let mut wire;
    let mut gate;
    let mut input;
    let mut input_2;
    let mut operation;
    let mut words: Vec<&str>;
    let mut gates = HashMap::new();
    for instruction in instructions.lines() {
        words = instruction.split(' ').collect();
        match words.len() {
            3 => {
                wire = words[2];
                input = words[0];
                gate = Gate::new(Operation::Put(input));
                gates.insert(wire, gate);
            }
            4 => {
                wire = words[3];
                input = words[1];
                gate = Gate::new(Operation::Not(input));
                gates.insert(wire, gate);
            }
            5 => {
                wire = words[4];
                input = words[0];
                input_2 = words[2];
                operation = match words[1] {
                    "OR" => Operation::Or(input, input_2),
                    "AND" => Operation::And(input, input_2),
                    "LSHIFT" => Operation::LShift(input, input_2),
                    "RSHIFT" => Operation::RShift(input, input_2),
                    _ => panic!("Unknown operation {}", words[1]),
                };
                gate = Gate::new(operation);
                gates.insert(wire, gate);
            }
            _ => panic!("Unknown number of words: {}", words.len()),
        }
    }
    let output_at_wire_a = find_output("a", &mut gates).unwrap();
    output_at_wire_a
}

fn part_2(instructions: &str) -> u16 {
    let mut wire;
    let mut gate;
    let mut input;
    let mut input_2;
    let mut operation;
    let mut words: Vec<&str>;
    let mut gates = HashMap::new();
    for instruction in instructions.lines() {
        words = instruction.split(' ').collect();
        match words.len() {
            3 => {
                wire = words[2];
                input = words[0];
                gate = Gate::new(Operation::Put(input));
                gates.insert(wire, gate);
            }
            4 => {
                wire = words[3];
                input = words[1];
                gate = Gate::new(Operation::Not(input));
                gates.insert(wire, gate);
            }
            5 => {
                wire = words[4];
                input = words[0];
                input_2 = words[2];
                operation = match words[1] {
                    "OR" => Operation::Or(input, input_2),
                    "AND" => Operation::And(input, input_2),
                    "LSHIFT" => Operation::LShift(input, input_2),
                    "RSHIFT" => Operation::RShift(input, input_2),
                    _ => panic!("Unknown operation: {}", words[1]),
                };
                gate = Gate::new(operation);
                gates.insert(wire, gate);
            }
            _ => panic!("Unknown number of words: {}", words.len()),
        }
    }
    let string_output_at_wire_a = find_output("a", &mut gates).unwrap().to_string();
    for (_key, value) in gates.iter_mut() {
        value.output = None;
    }
    gates.insert("b", Gate::new(Operation::Put(&string_output_at_wire_a)));
    let output_at_wire_a = find_output("a", &mut gates).unwrap();
    output_at_wire_a
}

fn find_output(wire: &str, gates: &mut HashMap<&str, Gate>) -> Option<u16> {
    let gate: &Gate = gates.get(wire).unwrap();
    match gate.output {
        Some(output) => Some(output),
        None => {
            let output: u16 = match gate.operation {
                Operation::Put(input) => parse_input(input, gates)?,
                Operation::Not(input) => !parse_input(input, gates)?,
                Operation::Or(lhs, rhs) => parse_input(lhs, gates)? | parse_input(rhs, gates)?,
                Operation::And(lhs, rhs) => parse_input(lhs, gates)? & parse_input(rhs, gates)?,
                Operation::LShift(lhs, rhs) => parse_input(lhs, gates)? << parse_input(rhs, gates)?,
                Operation::RShift(lhs, rhs) => parse_input(lhs, gates)? >> parse_input(rhs, gates)?,
            };
            gates.get_mut(wire).unwrap().output = Some(output);
            Some(output)
        }
    }
}

fn parse_input(num_or_wire: &str, gates: &mut HashMap<&str, Gate>) -> Option<u16> {
    num_or_wire
        .parse()
        .ok()
        .or_else(|| find_output(num_or_wire, gates))
}
