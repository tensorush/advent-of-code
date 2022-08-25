const std = @import("std");

const MAX_SIGNAL_LEN: u4 = 1 << 3;

const InstructionArray = std.BoundedArray(Instruction, 1 << 5);

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_25.txt");
    const instructions = try parseInstructions(input);
    std.debug.print("--- Day 25: Clock Signal ---\n", .{});
    std.debug.print("Final Part: {d}\n", .{executeInstructions(instructions)});
}

const Instruction = union(enum) { cpy: struct { from: Value, to: u8 }, inc: u8, dec: u8, jnz: struct { check: Value, jump: Value }, out: u8 };

const ValuePair = struct { lhs: Value, rhs: Value };

const Value = union(enum) {
    register_idx: u8,
    integer: i32,

    fn resolve(self: Value, registers: [4]i32) i32 {
        return switch (self) {
            .register_idx => |register_idx| registers[register_idx],
            .integer => |integer| integer,
        };
    }
};

fn parseInstructions(input: []const u8) std.fmt.ParseIntError!InstructionArray {
    var str_instruction_iter = std.mem.tokenize(u8, input, "\n");
    var instructions = try InstructionArray.init(0);
    var from_to_split_idx: usize = undefined;
    while (str_instruction_iter.next()) |str_instruction| {
        instructions.appendAssumeCapacity(switch (str_instruction[0]) {
            'c' => blk: {
                from_to_split_idx = std.mem.indexOfScalarPos(u8, str_instruction, 4, ' ').?;
                break :blk .{
                    .cpy = .{
                        .from = if (std.fmt.parseInt(i32, str_instruction[4..from_to_split_idx], 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[4] - 'a' },
                        .to = str_instruction[from_to_split_idx + 1] - 'a',
                    },
                };
            },
            'i' => .{ .inc = str_instruction[4] - 'a' },
            'd' => .{ .dec = str_instruction[4] - 'a' },
            'j' => .{
                .jnz = .{
                    .check = if (std.fmt.parseInt(i32, std.mem.trimRight(u8, str_instruction[4..6], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[4] - 'a' },
                    .jump = if (std.fmt.parseInt(i32, std.mem.trimLeft(u8, str_instruction[6..], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[str_instruction.len - 1] - 'a' },
                },
            },
            else => .{ .out = str_instruction[4] - 'a' },
        });
    }
    return instructions;
}

fn executeInstructions(instructions: InstructionArray) i32 {
    var signal: [MAX_SIGNAL_LEN]bool = undefined;
    var registers: [4]i32 = undefined;
    var signal_idx: u4 = undefined;
    var instruction_idx: i32 = 0;
    var initial_value: i32 = 1;
    initial_value_loop: while (true) : (initial_value += 1) {
        registers = [1]i32{0} ** 4;
        instruction_idx = 0;
        signal = undefined;
        signal_idx = 0;
        registers[0] = initial_value;
        while (instruction_idx < instructions.len) {
            instruction_idx = blk: {
                switch (instructions.get(@intCast(usize, instruction_idx))) {
                    .cpy => |cpy| {
                        registers[cpy.to] = cpy.from.resolve(registers);
                    },
                    .inc => |register_idx| {
                        registers[register_idx] += 1;
                    },
                    .dec => |register_idx| {
                        registers[register_idx] -= 1;
                    },
                    .jnz => |jnz| {
                        if (jnz.check.resolve(registers) != 0) break :blk instruction_idx + jnz.jump.resolve(registers);
                    },
                    .out => |register_idx| {
                        signal[signal_idx] = registers[register_idx] == 1;
                        if (signal[signal_idx] and signal_idx % 2 == 0 or !signal[signal_idx] and signal_idx % 2 == 1) continue :initial_value_loop;
                        if (signal_idx < MAX_SIGNAL_LEN - 1) signal_idx += 1 else return initial_value;
                    },
                }
                break :blk instruction_idx + 1;
            };
        }
    }
}
