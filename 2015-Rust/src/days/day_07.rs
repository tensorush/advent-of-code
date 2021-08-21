use std::collections::HashMap;

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

fn pass_input(num_or_wire: &str, gates: &mut HashMap<&str, Gate>) -> Option<u16> {
    num_or_wire
        .parse()
        .ok()
        .or_else(|| find_output(num_or_wire, gates))
}

fn find_output(wire: &str, gates: &mut HashMap<&str, Gate>) -> Option<u16> {
    let gate: &Gate = gates.get(wire).unwrap();
    match gate.output {
        Some(output) => Some(output),
        None => {
            let output: u16 = match gate.operation {
                Operation::Put(input) => pass_input(input, gates)?,
                Operation::Not(input) => !pass_input(input, gates)?,
                Operation::Or(lhs, rhs) => pass_input(lhs, gates)? | pass_input(rhs, gates)?,
                Operation::And(lhs, rhs) => pass_input(lhs, gates)? & pass_input(rhs, gates)?,
                Operation::LShift(lhs, rhs) => pass_input(lhs, gates)? << pass_input(rhs, gates)?,
                Operation::RShift(lhs, rhs) => pass_input(lhs, gates)? >> pass_input(rhs, gates)?,
            };
            gates.get_mut(wire).unwrap().output = Some(output);
            Some(output)
        }
    }
}

fn part_1(instructions: &str) -> u16 {
    let mut wire: &str;
    let mut gate: Gate;
    let mut input: &str;
    let mut input_2: &str;
    let mut words: Vec<&str>;
    let mut operation: Operation;
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
    let output_at_wire_a: u16 = find_output("a", &mut gates).unwrap();
    output_at_wire_a
}

fn part_2(instructions: &str) -> u16 {
    let mut wire: &str;
    let mut gate: Gate;
    let mut input: &str;
    let mut input_2: &str;
    let mut words: Vec<&str>;
    let mut operation: Operation;
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
    let string_output_at_wire_a: String = find_output("a", &mut gates).unwrap().to_string();
    for (_key, value) in gates.iter_mut() {
        value.output = None;
    }
    gates.insert("b", Gate::new(Operation::Put(&string_output_at_wire_a)));
    let output_at_wire_a: u16 = find_output("a", &mut gates).unwrap();
    output_at_wire_a
}

pub fn solve(instructions: &str) {
    println!("--- Day 7: Some Assembly Required ---");
    println!("Part 1: {}", part_1(instructions));
    println!("Part 2: {}", part_2(instructions));
}
