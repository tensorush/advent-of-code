const std = @import("std");

const DiscArray = std.BoundedArray(Disc, 1 << 3);

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("../inputs/day_15.txt");
    var discs = try parseDiscs(input);
    std.debug.print("--- Day 15: Timing is Everything ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{findStartTime(&discs, false)});
    std.debug.print("Part 2: {d}\n", .{findStartTime(&discs, true)});
}

const Disc = struct { num_positions: u32, start_position: u32 };

fn parseDiscs(input: []const u8) std.fmt.ParseIntError!DiscArray {
    var str_disc_iter = std.mem.tokenize(u8, input, "\n");
    var discs = try DiscArray.init(0);
    while (str_disc_iter.next()) |str_disc| {
        discs.appendAssumeCapacity(.{
            .num_positions = try std.fmt.parseUnsigned(u32, std.mem.trimRight(u8, str_disc[12..14], " "), 10),
            .start_position = try std.fmt.parseUnsigned(u32, str_disc[str_disc.len - 2 .. str_disc.len - 1], 10),
        });
    }
    return discs;
}

fn findStartTime(discs: *DiscArray, is_part2: bool) u32 {
    if (is_part2) discs.appendAssumeCapacity(.{ .num_positions = 11, .start_position = 0 });
    var time: u32 = undefined;
    var start_time: u32 = 0;
    time_loop: while (true) : (start_time += 1) {
        time = start_time + 1;
        for (discs.constSlice()) |disc| {
            if ((disc.start_position + time) % disc.num_positions != 0) continue :time_loop;
            time += 1;
        }
        return start_time;
    }
}

test "Day 15" {
    const input = "\nDisc #1 has 5 num_positions; at time=0, it is at start_position 4.\nDisc #2 has 2 num_positions; at time=0, it is at start_position 1.";
    var discs = try parseDiscs(input);
    try std.testing.expect(5 == findStartTime(&discs, false));
}
