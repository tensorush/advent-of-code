const std = @import("std");

const MAX_NUM_OUTS = 1 << 5;
const MAX_NUM_BOTS = 1 << 8;

pub fn solve() std.fmt.ParseIntError!void {
    const input = @embedFile("../inputs/day_10.txt");
    var state1 = State{ .is_part1 = true };
    var state2 = State{ .is_part1 = false };
    std.debug.print("--- Day 10: Balance Bots ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try state1.parseAndExecuteInstructions(input)});
    std.debug.print("Part 2: {d}\n", .{try state2.parseAndExecuteInstructions(input)});
}

const BotInstruction = struct { low_to: To, low_number: u16, high_to: To, high_number: u16 };

const To = enum { Bot, Out };

const State = struct {
    out_opts: [MAX_NUM_OUTS]?u16 = [1]?u16{null} ** MAX_NUM_OUTS,
    bot_instructions: [MAX_NUM_BOTS]BotInstruction = undefined,
    bots: [MAX_NUM_BOTS]Bot = undefined,
    target_high: u16 = 61,
    target_low: u16 = 17,
    is_part1: bool,

    fn parseAndExecuteInstructions(self: *State, input: []const u8) std.fmt.ParseIntError!u16 {
        return blk: {
            var str_instruction_iter = std.mem.tokenize(u8, input, "\n");
            var bot_number_end_idx: usize = undefined;
            var high_start_idx: usize = undefined;
            var low_start_idx: usize = undefined;
            var low_end_idx: usize = undefined;
            var high_number: u16 = undefined;
            var bot_number: u16 = undefined;
            var low_number: u16 = undefined;
            var high_to: To = undefined;
            var low_to: To = undefined;
            var chip: u8 = undefined;
            while (str_instruction_iter.next()) |str_instruction| {
                if (str_instruction[0] == 'b') {
                    bot_number_end_idx = std.mem.indexOfScalarPos(u8, str_instruction, 4, ' ').?;
                    bot_number = try std.fmt.parseUnsigned(u16, str_instruction[4..bot_number_end_idx], 10);
                    low_to = if (str_instruction[bot_number_end_idx + 14] == 'b') .Bot else .Out;
                    low_start_idx = std.mem.indexOfScalarPos(u8, str_instruction, bot_number_end_idx + 14, ' ').? + 1;
                    low_end_idx = std.mem.indexOfScalarPos(u8, str_instruction, low_start_idx, ' ').?;
                    low_number = try std.fmt.parseUnsigned(u16, str_instruction[low_start_idx..low_end_idx], 10);
                    high_to = if (str_instruction[low_end_idx + 13] == 'b') .Bot else .Out;
                    high_start_idx = std.mem.indexOfScalarPos(u8, str_instruction, low_end_idx + 13, ' ').? + 1;
                    high_number = try std.fmt.parseUnsigned(u16, str_instruction[high_start_idx..], 10);
                    self.bot_instructions[bot_number] = .{ .low_to = low_to, .low_number = low_number, .high_to = high_to, .high_number = high_number };
                }
            }
            str_instruction_iter.reset();
            while (str_instruction_iter.next()) |str_instruction| {
                if (str_instruction[0] == 'v') {
                    chip = try std.fmt.parseUnsigned(u8, std.mem.trimRight(u8, str_instruction[6..8], " "), 10);
                    bot_number = try std.fmt.parseUnsigned(u16, std.mem.trimLeft(u8, str_instruction[20..], " "), 10);
                    if (self.bots[bot_number].executeInstruction(self, chip, bot_number)) |result| break :blk result;
                }
            }
            unreachable;
        };
    }
};

const Bot = struct {
    chip_opts: [2]?u8 = [1]?u8{null} ** 2,

    fn executeInstruction(self: *Bot, state: *State, chip: u8, bot_number: u16) ?u16 {
        if (self.chip_opts[0] == null) self.chip_opts[0] = chip else self.chip_opts[1] = chip;
        if (self.chip_opts[1]) |*chip2| {
            var chip1 = &self.chip_opts[0].?;
            if (chip1.* > chip2.*) std.mem.swap(u8, chip1, chip2);
            if (state.is_part1 and chip1.* == state.target_low and chip2.* == state.target_high) return bot_number;
            if (!state.is_part1 and state.out_opts[0] != null and state.out_opts[1] != null and state.out_opts[2] != null) return state.out_opts[0].? * state.out_opts[1].? * state.out_opts[2].?;
            const instruction = state.bot_instructions[bot_number];
            var number = instruction.low_number;
            switch (instruction.low_to) {
                .Bot => {
                    if (state.bots[number].executeInstruction(state, chip1.*, number)) |result| return result;
                },
                .Out => state.out_opts[number] = chip1.*,
            }
            self.chip_opts[0] = null;
            number = instruction.high_number;
            switch (instruction.high_to) {
                .Bot => {
                    if (state.bots[number].executeInstruction(state, chip2.*, number)) |result| return result;
                },
                .Out => state.out_opts[number] = chip2.*,
            }
            self.chip_opts[1] = null;
        }
        return null;
    }
};

test "Day 10" {
    const input = "value 5 goes to bot 2\nbot 2 gives low to bot 1 and high to bot 0\nvalue 3 goes to bot 1\nbot 1 gives low to output 1 and high to bot 0\nbot 0 gives low to output 2 and high to output 0\nvalue 2 goes to bot 2";
    var state = State{ .target_high = 5, .target_low = 2, .is_part1 = true };
    try std.testing.expect(2 == try state.parseAndExecuteInstructions(input));
}
