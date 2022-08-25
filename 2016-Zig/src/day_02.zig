const std = @import("std");

const MAX_CODE_LEN: u4 = 1 << 3;
const EXPECTED_KEYPAD = [5][5]?Key{ .{null} ** 5, .{ null, .@"1", .@"2", .@"3", null }, .{ null, .@"4", .@"5", .@"6", null }, .{ null, .@"7", .@"8", .@"9", null }, .{null} ** 5 };
const ACTUAL_KEYPAD = [5][5]?Key{ .{ null, null, .@"1", null, null }, .{ null, .@"2", .@"3", .@"4", null }, .{ .@"5", .@"6", .@"7", .@"8", .@"9" }, .{ null, .A, .B, .C, null }, .{ null, null, .D, null, null } };

const MoveArray = std.BoundedArray(Move, 1 << 10);
const KeyMovesArray = std.BoundedArray(MoveArray, MAX_CODE_LEN);

pub fn main() error{Overflow}!void {
    const input = @embedFile("inputs/day_02.txt");
    const key_moves = try parseKeyMoves(input);
    var code: [MAX_CODE_LEN]u8 = undefined;
    std.debug.print("--- Day 2: Bathroom Security ---\n", .{});
    std.debug.print("Part 1: {s}\n", .{try findCode(key_moves, EXPECTED_KEYPAD, code[0..])});
    std.debug.print("Part 2: {s}\n", .{try findCode(key_moves, ACTUAL_KEYPAD, code[0..])});
}

const Key = enum { @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", A, B, C, D };

const Point = struct { x: u4 = 2, y: u4 = 2 };

const Move = enum { Up, Left, Down, Right };

fn parseKeyMoves(input: []const u8) error{Overflow}!KeyMovesArray {
    var str_key_move_iter = std.mem.tokenize(u8, input, "\n");
    var key_moves = try KeyMovesArray.init(0);
    var moves: MoveArray = undefined;
    while (str_key_move_iter.next()) |str_moves| {
        moves = try MoveArray.init(0);
        for (str_moves) |char_move| {
            moves.appendAssumeCapacity(switch (char_move) {
                'U' => .Up,
                'L' => .Left,
                'D' => .Down,
                'R' => .Right,
                else => unreachable,
            });
        }
        key_moves.appendAssumeCapacity(moves);
    }
    return key_moves;
}

fn findCode(key_moves: KeyMovesArray, keypad: [5][5]?Key, code: []u8) error{Overflow}![]const u8 {
    var point: Point = if (keypad[0][2]) |_| .{ .x = 0 } else .{};
    var key_count: usize = 0;
    var key = Key.@"5";
    for (key_moves.constSlice()) |moves| {
        for (moves.constSlice()) |move| {
            switch (move) {
                .Up => if (point.y > 0 and keypad[point.y - 1][point.x] != null) {
                    point.y -= 1;
                },
                .Left => if (point.x > 0 and keypad[point.y][point.x - 1] != null) {
                    point.x -= 1;
                },
                .Down => if (point.y < keypad.len - 1 and keypad[point.y + 1][point.x] != null) {
                    point.y += 1;
                },
                .Right => if (point.x < keypad.len - 1 and keypad[point.y][point.x + 1] != null) {
                    point.x += 1;
                },
            }
            key = keypad[point.y][point.x].?;
        }
        code[key_count] = @tagName(key)[0];
        key_count += 1;
    }
    return code[0..key_count];
}

test "Day 2" {
    var code: [MAX_CODE_LEN]u8 = undefined;
    const key_moves = try parseKeyMoves("ULL\nRRDDD\nLURDL\nUUUUD");
    try std.testing.expectEqualStrings("1985", try findCode(key_moves, EXPECTED_KEYPAD, code[0..]));
    try std.testing.expectEqualStrings("5DB3", try findCode(key_moves, ACTUAL_KEYPAD, code[0..]));
}
