const std = @import("std");

const OperationArray = std.BoundedArray(Operation, 1 << 7);

pub fn solve() error{Overflow}!void {
    const input = @embedFile("inputs/day_21.txt");
    var scrambler = Scrambler{};
    try scrambler.parseOperations(input);
    var scrambled_password = "fbgdceah".*;
    var unscrambled_password = "abcdefgh".*;
    std.debug.print("--- Day 21: Scrambled Letters and Hash ---\n", .{});
    std.debug.print("Part 1: {s}\n", .{scrambler.modifyPassword(unscrambled_password[0..], true)});
    std.debug.print("Part 2: {s}\n", .{scrambler.modifyPassword(scrambled_password[0..], false)});
}

const Operation = union(enum) { swap: OperandPair, rotate: OperandPair, reverse: OperandPair, move: OperandPair };

const OperandPair = struct { x: u8, y: u8 };

const Scrambler = struct {
    operations: OperationArray = undefined,
    password: []u8 = undefined,

    fn parseOperations(self: *Scrambler, input: []const u8) error{Overflow}!void {
        var str_operation_iter = std.mem.tokenize(u8, input, "\n");
        self.operations = try OperationArray.init(0);
        while (str_operation_iter.next()) |str_operation| {
            self.operations.appendAssumeCapacity(blk: {
                if (str_operation[0] == 's') {
                    if (str_operation[5] == 'p') {
                        break :blk Operation{ .swap = .{ .x = str_operation[14] - '0', .y = str_operation[30] - '0' } };
                    } else {
                        break :blk Operation{ .swap = .{ .x = str_operation[12], .y = str_operation[26] } };
                    }
                } else if (str_operation[2] == 't') {
                    if (str_operation[7] == 'l') {
                        break :blk Operation{ .rotate = .{ .x = str_operation[12] - '0', .y = 'l' } };
                    } else if (str_operation[7] == 'r') {
                        break :blk Operation{ .rotate = .{ .x = str_operation[13] - '0', .y = 'r' } };
                    } else {
                        break :blk Operation{ .rotate = .{ .x = str_operation[35], .y = 'b' } };
                    }
                } else if (str_operation[0] == 'r') {
                    break :blk Operation{ .reverse = .{ .x = str_operation[18] - '0', .y = str_operation[28] - '0' } };
                } else {
                    break :blk Operation{ .move = .{ .x = str_operation[14] - '0', .y = str_operation[28] - '0' } };
                }
            });
        }
    }

    fn modifyPassword(self: *Scrambler, password: []u8, comptime is_part1: bool) []const u8 {
        self.password = password;
        if (is_part1) {
            for (self.operations.constSlice()) |operation| {
                switch (operation) {
                    .swap => |operand_pair| if (std.ascii.isAlphabetic(operand_pair.x)) self.swapLetters(operand_pair.x, operand_pair.y) else self.swapDigits(operand_pair.x, operand_pair.y),
                    .rotate => |operand_pair| if (operand_pair.y == 'b') self.rotateBased(operand_pair, is_part1) else self.rotateLeftRight(operand_pair, is_part1),
                    .reverse => |operand_pair| self.reverse(operand_pair),
                    .move => |operand_pair| self.move(operand_pair.x, operand_pair.y),
                }
            }
        } else {
            while (self.operations.popOrNull()) |operation| {
                switch (operation) {
                    .swap => |operand_pair| if (std.ascii.isAlphabetic(operand_pair.x)) self.swapLetters(operand_pair.x, operand_pair.y) else self.swapDigits(operand_pair.x, operand_pair.y),
                    .rotate => |operand_pair| if (operand_pair.y == 'b') self.rotateBased(operand_pair, is_part1) else self.rotateLeftRight(operand_pair, is_part1),
                    .reverse => |operand_pair| self.reverse(operand_pair),
                    .move => |operand_pair| self.move(operand_pair.y, operand_pair.x),
                }
            }
        }
        return self.password;
    }

    fn swapLetters(self: *Scrambler, from: u8, to: u8) void {
        self.swapDigits(@as(u8, @intCast(std.mem.indexOfScalar(u8, self.password, from).?)), @as(u8, @intCast(std.mem.indexOfScalar(u8, self.password, to).?)));
    }

    fn swapDigits(self: *Scrambler, from_idx: u8, to_idx: u8) void {
        std.mem.swap(u8, &self.password[from_idx], &self.password[to_idx]);
    }

    fn rotateBased(self: *Scrambler, operand_pair: OperandPair, is_part1: bool) void {
        var rotation_count = @as(u8, @intCast(std.mem.indexOfScalar(u8, self.password, operand_pair.x).?));
        if (is_part1) {
            if (rotation_count > 3) rotation_count += 2 else rotation_count += 1;
        } else {
            if (rotation_count == 0) {
                rotation_count = 9;
            } else if (rotation_count % 2 == 0) {
                rotation_count = rotation_count / 2 + 5;
            } else {
                rotation_count = (rotation_count + 1) / 2;
            }
        }
        self.rotateLeftRight(.{ .x = rotation_count, .y = if (is_part1) 'r' else 'l' }, true);
    }

    fn rotateLeftRight(self: *Scrambler, operand_pair: OperandPair, is_part1: bool) void {
        var password_idx: usize = undefined;
        var rotation_count: u8 = 0;
        if (is_part1 and operand_pair.y == 'l' or !is_part1 and operand_pair.y == 'r') {
            while (rotation_count < operand_pair.x) : (rotation_count += 1) {
                password_idx = self.password.len - 1;
                while (password_idx > 0) : (password_idx -= 1) {
                    std.mem.swap(u8, &self.password[0], &self.password[password_idx]);
                }
            }
        } else {
            while (rotation_count < operand_pair.x) : (rotation_count += 1) {
                password_idx = 0;
                while (password_idx < self.password.len - 1) : (password_idx += 1) {
                    std.mem.swap(u8, &self.password[self.password.len - 1], &self.password[password_idx]);
                }
            }
        }
    }

    fn reverse(self: *Scrambler, operand_pair: OperandPair) void {
        var x_idx = operand_pair.x;
        var y_idx = operand_pair.y;
        while (x_idx < y_idx) : (x_idx += 1) {
            std.mem.swap(u8, &self.password[x_idx], &self.password[y_idx]);
            y_idx -= 1;
        }
    }

    fn move(self: *Scrambler, from: u8, to: u8) void {
        var password_idx = from;
        if (password_idx < to) {
            while (password_idx < to) : (password_idx += 1) {
                std.mem.swap(u8, &self.password[password_idx], &self.password[password_idx + 1]);
            }
        } else {
            while (password_idx > to) : (password_idx -= 1) {
                std.mem.swap(u8, &self.password[password_idx], &self.password[password_idx - 1]);
            }
        }
    }
};

test "Day 21" {
    var unscrambled_password = "abcde".*;
    var scrambler = Scrambler{};
    try scrambler.parseOperations("swap position 4 with position 0\nswap letter d with letter b\nreverse positions 0 through 4\nrotate left 1 step\nmove position 1 to position 4\nmove position 3 to position 0\nrotate based on position of letter b\nrotate based on position of letter d");
    try std.testing.expectEqualSlices(u8, "decab", scrambler.modifyPassword(unscrambled_password[0..], true));
}
