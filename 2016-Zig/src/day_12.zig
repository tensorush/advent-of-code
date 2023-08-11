const std = @import("std");

const InstructionArray = std.BoundedArray(Instruction, 1 << 5);

pub fn solve() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_12.txt");
    const instructions = try parseInstructions(input);
    std.debug.print("--- Day 12: Leonardo's Monorail ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{executeInstructions(instructions, false)});
    std.debug.print("Part 2: {d}\n", .{executeInstructions(instructions, true)});
}

const Instruction = union(enum) { cpy: struct { from: Value, to: u8 }, inc: u8, dec: u8, jnz: struct { check: Value, jump: Value } };

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
    while (str_instruction_iter.next()) |str_instruction| {
        instructions.appendAssumeCapacity(switch (str_instruction[0]) {
            'c' => .{
                .cpy = .{
                    .from = if (std.fmt.parseInt(i32, std.mem.trimRight(u8, str_instruction[4..6], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[4] - 'a' },
                    .to = std.mem.trimLeft(u8, str_instruction[6..], " ")[0] - 'a',
                },
            },
            'i' => .{ .inc = str_instruction[4] - 'a' },
            'd' => .{ .dec = str_instruction[4] - 'a' },
            else => .{
                .jnz = .{
                    .check = if (std.fmt.parseInt(i32, std.mem.trimRight(u8, str_instruction[4..6], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[4] - 'a' },
                    .jump = if (std.fmt.parseInt(i32, std.mem.trimLeft(u8, str_instruction[6..], " "), 10)) |integer| .{ .integer = integer } else |_| .{ .register_idx = str_instruction[str_instruction.len - 1] - 'a' },
                },
            },
        });
    }
    return instructions;
}

fn executeInstructions(instructions: InstructionArray, comptime is_part2: bool) i32 {
    var registers = [4]i32{ 0, 0, if (is_part2) 1 else 0, 0 };
    var instruction_idx: i32 = 0;
    while (instruction_idx < instructions.len) {
        instruction_idx = blk: {
            switch (instructions.get(@as(usize, @intCast(instruction_idx)))) {
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
            }
            break :blk instruction_idx + 1;
        };
    }
    return registers[0];
}

test "Day 12" {
    const input = "\ncpy 41 a\ninc a\ninc a\ndec a\njnz a 2\ndec a";
    const instructions = try parseInstructions(input);
    try std.testing.expect(42 == executeInstructions(instructions, false));
}
