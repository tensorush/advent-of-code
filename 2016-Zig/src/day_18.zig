const std = @import("std");

pub fn main() void {
    const input = @embedFile("../inputs/day_18.txt");
    const row = parseRow(input);
    std.debug.print("--- Day 18: Like a Rogue ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{countSafeTiles(input.len, row, 40)});
    std.debug.print("Part 2: {d}\n", .{countSafeTiles(input.len, row, 400_000)});
}

const Tile = enum { Safe, Trap };

fn parseRow(comptime input: []const u8) [input.len]Tile {
    comptime {
        var row: [input.len]Tile = undefined;
        inline for (input) |char_tile, i| {
            switch (char_tile) {
                '.' => row[i] = .Safe,
                '^' => row[i] = .Trap,
                else => unreachable,
            }
        }
        return row;
    }
}

fn countSafeTiles(comptime input_len: usize, prev_row: [input_len]Tile, num_rows: u32) u32 {
    var next_row: [input_len]Tile = undefined;
    var row: [input_len]Tile = prev_row;
    var safe_tile_count: u32 = 0;
    var center: Tile = undefined;
    var right: Tile = undefined;
    var left: Tile = undefined;
    var row_idx: u32 = 0;
    while (row_idx < num_rows) : (row_idx += 1) {
        for (row) |tile| {
            if (tile == .Safe) safe_tile_count += 1;
        }
        for (next_row) |*tile, i| {
            center = row[i];
            right = if (i == 0) .Safe else row[i - 1];
            left = if (i == row.len - 1) .Safe else row[i + 1];
            tile.* = if (center == .Trap and right != .Trap and left == .Trap or
                center == .Trap and right == .Trap and left != .Trap or
                center != .Trap and right != .Trap and left == .Trap or
                center != .Trap and right == .Trap and left != .Trap) .Trap else .Safe;
        }
        row = next_row;
    }
    return safe_tile_count;
}

test "Day 18" {
    const input = ".^^.^.^^^^";
    const row = parseRow(input);
    try std.testing.expect(38 == countSafeTiles(input.len, row, 10));
}
