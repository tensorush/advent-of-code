use std::collections::HashMap;

#[derive(Copy, Clone)]
enum Instruction {
    Jump(i16),
    Half(char),
    Triple(char),
    Increment(char),
    JumpIfOne(char, i16),
    JumpIfEven(char, i16),
}

fn part_1(input: &str) -> u32 {
    let mut instructions: Vec<Instruction> = vec![];
    for line in input.lines() {
        let words: Vec<&str> = line.split(' ').collect();
        let instruction: Instruction = match words[0] {
            "jmp" => Instruction::Jump(words[1].parse().unwrap()),
            "hlf" => Instruction::Half(words[1].chars().next().unwrap()),
            "tpl" => Instruction::Triple(words[1].chars().next().unwrap()),
            "inc" => Instruction::Increment(words[1].chars().next().unwrap()),
            "jio" => {
                Instruction::JumpIfOne(words[1].chars().next().unwrap(), words[2].parse().unwrap())
            }
            "jie" => {
                Instruction::JumpIfEven(words[1].chars().next().unwrap(), words[2].parse().unwrap())
            }
            _ => panic!("Unknown instruction {}", words[0]),
        };
        instructions.push(instruction);
    }
    let mut instruction: Instruction;
    let mut instruction_pointer: i16 = 0;
    let num_instructions: i16 = instructions.len() as i16;
    let mut registers: HashMap<char, u32> = HashMap::new();
    loop {
        instruction = instructions[instruction_pointer as usize];
        match instruction {
            Instruction::Jump(offset) => instruction_pointer += offset - 1,
            Instruction::Half(register) => *registers.entry(register).or_insert(0) /= 2,
            Instruction::Triple(register) => *registers.entry(register).or_insert(0) *= 3,
            Instruction::Increment(register) => *registers.entry(register).or_insert(0) += 1,
            Instruction::JumpIfEven(register, offset) => {
                if registers.get(&register).unwrap_or(&0) % 2 == 0 {
                    instruction_pointer += offset - 1
                }
            }
            Instruction::JumpIfOne(register, offset) => {
                if *registers.get(&register).unwrap_or(&0) == 1 {
                    instruction_pointer += offset - 1
                }
            }
        };
        instruction_pointer += 1;
        if instruction_pointer >= num_instructions {
            break;
        }
    }
    let register_b_value: u32 = *registers.get(&'b').unwrap();
    register_b_value
}

fn part_2(input: &str) -> u32 {
    let mut instructions: Vec<Instruction> = vec![];
    for line in input.lines() {
        let words: Vec<&str> = line.split(' ').collect();
        let instruction: Instruction = match words[0] {
            "jmp" => Instruction::Jump(words[1].parse().unwrap()),
            "hlf" => Instruction::Half(words[1].chars().next().unwrap()),
            "tpl" => Instruction::Triple(words[1].chars().next().unwrap()),
            "inc" => Instruction::Increment(words[1].chars().next().unwrap()),
            "jio" => {
                Instruction::JumpIfOne(words[1].chars().next().unwrap(), words[2].parse().unwrap())
            }
            "jie" => {
                Instruction::JumpIfEven(words[1].chars().next().unwrap(), words[2].parse().unwrap())
            }
            _ => panic!("Unknown instruction {}", words[0]),
        };
        instructions.push(instruction);
    }
    let mut instruction: Instruction;
    let mut instruction_pointer: i16 = 0;
    let num_instructions: i16 = instructions.len() as i16;
    let mut registers: HashMap<char, u32> = HashMap::new();
    registers.insert('a', 1);
    loop {
        instruction = instructions[instruction_pointer as usize];
        match instruction {
            Instruction::Jump(offset) => instruction_pointer += offset - 1,
            Instruction::Half(register) => *registers.entry(register).or_insert(0) /= 2,
            Instruction::Triple(register) => *registers.entry(register).or_insert(0) *= 3,
            Instruction::Increment(register) => *registers.entry(register).or_insert(0) += 1,
            Instruction::JumpIfEven(register, offset) => {
                if registers.get(&register).unwrap_or(&0) % 2 == 0 {
                    instruction_pointer += offset - 1
                }
            }
            Instruction::JumpIfOne(register, offset) => {
                if *registers.get(&register).unwrap_or(&0) == 1 {
                    instruction_pointer += offset - 1
                }
            }
        };
        instruction_pointer += 1;
        if instruction_pointer >= num_instructions {
            break;
        }
    }
    let register_b_value: u32 = *registers.get(&'b').unwrap();
    register_b_value
}

pub fn solve(input: &str) {
    println!("--- Day 23: Opening the Turing Lock ---");
    println!("Part 1: {}", part_1(input));
    println!("Part 2: {}", part_2(input));
}
