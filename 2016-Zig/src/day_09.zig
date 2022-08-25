const std = @import("std");

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_09.txt");
    std.debug.print("--- Day 9: Explosives in Cyberspace ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try parseAndDecompressFile(input, true)});
    std.debug.print("Part 2: {d}\n", .{try parseAndDecompressFile(input, false)});
}

fn parseAndDecompressFile(input: []const u8, is_part1: bool) std.fmt.ParseIntError!usize {
    var marker_iter: std.mem.TokenIterator(u8) = undefined;
    var marker_end_idx: usize = undefined;
    var num_chars: usize = undefined;
    var num_reps: usize = undefined;
    var first_char: u8 = undefined;
    var file_len: usize = 0;
    var rest = input;
    while (rest.len > 0) {
        first_char = rest[0];
        rest = rest[1..];
        if (first_char == '(') {
            marker_end_idx = std.mem.indexOfScalar(u8, rest, ')').?;
            marker_iter = std.mem.tokenize(u8, rest[0..marker_end_idx], "x");
            num_chars = try std.fmt.parseUnsigned(usize, marker_iter.next().?, 10);
            num_reps = try std.fmt.parseUnsigned(usize, marker_iter.next().?, 10);
            rest = rest[marker_end_idx + 1 ..];
            file_len += num_reps * if (is_part1) num_chars else try parseAndDecompressFile(rest[0..num_chars], false);
            rest = rest[num_chars..];
        } else {
            file_len += 1;
        }
    }
    return file_len;
}

test "Day 9" {
    try std.testing.expect(6 == try parseAndDecompressFile("ADVENT", true));
    try std.testing.expect(7 == try parseAndDecompressFile("A(1x5)BC", true));
    try std.testing.expect(9 == try parseAndDecompressFile("(3x3)XYZ", true));
    try std.testing.expect(11 == try parseAndDecompressFile("A(2x2)BCD(2x2)EFG", true));
    try std.testing.expect(6 == try parseAndDecompressFile("(6x1)(1x3)A", true));
    try std.testing.expect(18 == try parseAndDecompressFile("X(8x2)(3x3)ABCY", true));
    try std.testing.expect(9 == try parseAndDecompressFile("(3x3)XYZ", false));
    try std.testing.expect(20 == try parseAndDecompressFile("X(8x2)(3x3)ABCY", false));
    try std.testing.expect(241_920 == try parseAndDecompressFile("(27x12)(20x12)(13x14)(7x10)(1x12)A", false));
    try std.testing.expect(445 == try parseAndDecompressFile("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN", false));
}
