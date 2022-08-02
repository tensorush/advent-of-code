const std = @import("std");

pub fn main() void {
    const message_len: u4 = 8;
    var message = [1]u8{0} ** message_len;
    const input = @embedFile("../inputs/day_06.txt");
    const corrupt_char_counts = parseAndCountCorruptChars(input, message_len);
    std.debug.print("--- Day 6: Signals and Noise ---\n", .{});
    std.debug.print("Part 1: {s}\n", .{correctMessage(corrupt_char_counts[0..], message[0..], true)});
    std.debug.print("Part 2: {s}\n", .{correctMessage(corrupt_char_counts[0..], message[0..], false)});
}

fn parseAndCountCorruptChars(input: []const u8, comptime message_len: u4) [message_len][26]u8 {
    var corrupt_char_counts = [1][26]u8{[1]u8{0} ** 26} ** message_len;
    var corrupt_message_iter = std.mem.tokenize(u8, input, "\n");
    while (corrupt_message_iter.next()) |corrupt_message| {
        for (corrupt_message) |corrupt_char, i| {
            corrupt_char_counts[i][corrupt_char - 'a'] += 1;
        }
    }
    return corrupt_char_counts;
}

fn correctMessage(corrupt_char_counts: []const [26]u8, message: []u8, is_part1: bool) []const u8 {
    if (is_part1) {
        var largest_corrupt_char_count: u8 = undefined;
        for (message) |*char, i| {
            largest_corrupt_char_count = 0;
            for (corrupt_char_counts[i]) |corrupt_char_count, j| {
                if (corrupt_char_count > largest_corrupt_char_count) {
                    largest_corrupt_char_count = corrupt_char_count;
                    char.* = @intCast(u8, j) + 'a';
                }
            }
        }
    } else {
        var smallest_corrupt_char_count: u8 = undefined;
        for (message) |*char, i| {
            smallest_corrupt_char_count = std.math.maxInt(u8);
            for (corrupt_char_counts[i]) |corrupt_char_count, j| {
                if (corrupt_char_count > 0 and corrupt_char_count < smallest_corrupt_char_count) {
                    smallest_corrupt_char_count = corrupt_char_count;
                    char.* = @intCast(u8, j) + 'a';
                }
            }
        }
    }
    return message;
}

test "Day 6" {
    const message_len: u4 = 6;
    var message = [1]u8{0} ** message_len;
    const input = "eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar";
    const corrupt_char_counts = parseAndCountCorruptChars(input, message_len);
    try std.testing.expectEqualStrings("easter", correctMessage(corrupt_char_counts[0..], message[0..], true));
    try std.testing.expectEqualStrings("advent", correctMessage(corrupt_char_counts[0..], message[0..], false));
}
