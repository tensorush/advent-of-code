const std = @import("std");

const InstructionArray = std.BoundedArray(Instruction, 1 << 5);

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_23.txt");
    const instructions = try parseInstructions(input);
    std.debug.print("--- Day 23: Safe Cracking ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{executeInstructions(instructions, 7)});
    std.debug.print("Part 2: {d}\n", .{executeInstructions(instructions, 12)});
}

const Instruction = union(enum) { cpy: ValuePair, inc: Value, dec: Value, jnz: ValuePair, tgl: Value };

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
    var lhs_rhs_split_idx: usize = undefined;
    while (str_instruction_iter.next()) |str_instruction| {
        instructions.appendAssumeCapacity(switch (str_instruction[0]) {
            'c' => blk: {
                lhs_rhs_split_idx = std.mem.indexOfScalarPos(u8, str_instruction, 4, ' ').?;
                break :blk .{
                    .cpy = .{
                        .lhs = if (std.fmt.parseInt(i32, str_instruction[4..lhs_rhs_split_idx], 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[4] - 'a' },
                        .rhs = .{ .register_idx = str_instruction[lhs_rhs_split_idx + 1] - 'a' },
                    },
                };
            },
            'i' => .{ .inc = .{ .register_idx = str_instruction[4] - 'a' } },
            'd' => .{ .dec = .{ .register_idx = str_instruction[4] - 'a' } },
            'j' => .{
                .jnz = .{
                    .lhs = if (std.fmt.parseInt(i32, std.mem.trimRight(u8, str_instruction[4..6], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[4] - 'a' },
                    .rhs = if (std.fmt.parseInt(i32, std.mem.trimLeft(u8, str_instruction[6..], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[str_instruction.len - 1] - 'a' },
                },
            },
            else => .{ .tgl = .{ .register_idx = str_instruction[4] - 'a' } },
        });
    }
    return instructions;
}

fn executeInstructions(instructions: InstructionArray, comptime initial_value: i32) i32 {
    var registers = [1]i32{initial_value} ++ [1]i32{0} ** 3;
    var instructions_copy = instructions;
    var tgl_idx: usize = undefined;
    var instruction_idx: i32 = 0;
    while (instruction_idx < instructions_copy.len) {
        instruction_idx = blk: {
            switch (instructions_copy.get(@intCast(usize, instruction_idx))) {
                .cpy => |cpy| {
                    switch (cpy.rhs) {
                        .register_idx => |register_idx| registers[register_idx] = cpy.lhs.resolve(registers),
                        .integer => {},
                    }
                },
                .inc => |inc| {
                    switch (inc) {
                        .register_idx => |register_idx| registers[register_idx] += 1,
                        .integer => {},
                    }
                },
                .dec => |dec| {
                    switch (dec) {
                        .register_idx => |register_idx| registers[register_idx] -= 1,
                        .integer => {},
                    }
                },
                .jnz => |jnz| {
                    if (jnz.lhs.resolve(registers) != 0) break :blk instruction_idx + jnz.rhs.resolve(registers);
                },
                .tgl => |tgl| {
                    tgl_idx = @intCast(usize, instruction_idx + tgl.resolve(registers));
                    if (tgl_idx >= 0 and tgl_idx < instructions_copy.len) {
                        instructions_copy.set(tgl_idx, switch (instructions_copy.get(tgl_idx)) {
                            .inc => |value| .{ .dec = value },
                            .dec, .tgl => |value| .{ .inc = value },
                            .jnz => |pair| .{ .cpy = pair },
                            .cpy => |pair| .{ .jnz = pair },
                        });
                    }
                },
            }
            break :blk instruction_idx + 1;
        };
    }
    return registers[0];
}

test "Day 23" {
    const input = "\ncpy 2 a\ntgl a\ntgl a\ntgl a\ncpy 1 a\ndec a\ndec a";
    const instructions = try parseInstructions(input);
    try std.testing.expect(3 == executeInstructions(instructions, 7));
}
