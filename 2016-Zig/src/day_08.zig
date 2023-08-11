const std = @import("std");

pub fn solve() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_08.txt");
    var screen = Screen(50, 6){};
    try screen.parseAndExecuteInstructions(input);
    std.debug.print("--- Day 8: Two-Factor Authentication ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{screen.countLitPixels()});
    std.debug.print("Part 2:\n{s}", .{screen});
}

fn Screen(comptime width: u8, comptime height: u8) type {
    return struct {
        const Self = @This();

        pixels: [height][width]bool = [1][width]bool{[1]bool{false} ** width} ** height,

        fn parseAndExecuteInstructions(self: *Self, input: []const u8) std.fmt.ParseIntError!void {
            var str_instruction_iter = std.mem.tokenize(u8, input, "\n");
            while (str_instruction_iter.next()) |instruction| {
                if (instruction[1] == 'e') {
                    const size_split_idx = std.mem.indexOfScalar(u8, instruction, 'x').?;
                    const rect_height = try std.fmt.parseUnsigned(u8, instruction[size_split_idx + 1 ..], 10);
                    const rect_width = try std.fmt.parseUnsigned(u8, instruction[5..size_split_idx], 10);
                    self.rect(rect_width, rect_height);
                } else if (instruction[7] == 'r') {
                    const y = try std.fmt.parseUnsigned(u8, instruction[13..14], 10);
                    const num_rotations = try std.fmt.parseUnsigned(u8, instruction[18..], 10);
                    self.rotateRow(y, num_rotations);
                } else {
                    const x = try std.fmt.parseUnsigned(u8, std.mem.trimRight(u8, instruction[16..18], " "), 10);
                    const num_rotations = try std.fmt.parseUnsigned(u8, instruction[instruction.len - 1 ..], 10);
                    self.rotateColumn(x, num_rotations);
                }
            }
        }

        fn rect(self: *Self, rect_width: u8, rect_height: u8) void {
            var y: u8 = 0;
            while (y < rect_height) : (y += 1) {
                var x: u8 = 0;
                while (x < rect_width) : (x += 1) {
                    self.pixels[y][x] = true;
                }
            }
        }

        fn rotateRow(self: *Self, y: u8, num_rotations: u8) void {
            var rotation_count: u8 = 0;
            while (rotation_count < num_rotations) : (rotation_count += 1) {
                var last_pixel = &self.pixels[y][width - 1];
                var x: u8 = 0;
                while (x < width) : (x += 1) {
                    std.mem.swap(bool, last_pixel, &self.pixels[y][x]);
                }
            }
        }

        fn rotateColumn(self: *Self, x: u8, num_rotations: u8) void {
            var rotation_count: u8 = 0;
            while (rotation_count < num_rotations) : (rotation_count += 1) {
                var last_pixel = &self.pixels[height - 1][x];
                var y: u8 = 0;
                while (y < height) : (y += 1) {
                    std.mem.swap(bool, last_pixel, &self.pixels[y][x]);
                }
            }
        }

        fn countLitPixels(self: Self) u8 {
            var count: u8 = 0;
            for (self.pixels) |row| {
                for (row) |pixel| {
                    if (pixel) count += 1;
                }
            }
            return count;
        }

        pub fn format(self: Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
            for (self.pixels) |row| {
                for (row) |pixel| {
                    try writer.writeAll(if (pixel) "#" else ".");
                }
                try writer.writeAll("\n");
            }
        }
    };
}

test "Day 8" {
    const input = "rect 3x2\nrotate column x=1 by 1\nrotate row y=0 by 4\nrotate column x=1 by 1";
    var screen = Screen(7, 3){};
    try screen.parseAndExecuteInstructions(input);
    try std.testing.expect(6 == screen.countLitPixels());
    try std.testing.expectEqualSlices(bool, &[7]bool{ false, true, false, false, true, false, true }, screen.pixels[0][0..7]);
    try std.testing.expectEqualSlices(bool, &[7]bool{ true, false, true, false, false, false, false }, screen.pixels[1][0..7]);
    try std.testing.expectEqualSlices(bool, &[7]bool{ false, true, false, false, false, false, false }, screen.pixels[2][0..7]);
}
