const std = @import("std");

const RangeArray = std.BoundedArray(Range, 1 << 11);

pub fn solve() std.fmt.ParseIntError!void {
    const input = @embedFile("../inputs/day_20.txt");
    const solution = try findLowestAllowedIpAndCountAllowedIps(input, std.math.maxInt(u32));
    std.debug.print("--- Day 20: Firewall Rules ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{solution.lowest_allowed_ip});
    std.debug.print("Part 2: {d}\n", .{solution.allowed_ip_count});
}

const Solution = struct { lowest_allowed_ip: u32, allowed_ip_count: u32 };

const Range = struct {
    min: u32,
    max: u32,

    fn lessThan(_: void, lhs: Range, rhs: Range) bool {
        return if (lhs.min == rhs.min) lhs.max < rhs.max else lhs.min < rhs.min;
    }
};

fn findLowestAllowedIpAndCountAllowedIps(input: []const u8, max_ip: u32) std.fmt.ParseIntError!Solution {
    var str_range_iter = std.mem.tokenize(u8, input, "\n");
    var str_range_split_idx: usize = undefined;
    var ranges = try RangeArray.init(0);
    while (str_range_iter.next()) |str_range| {
        str_range_split_idx = std.mem.indexOfScalar(u8, str_range, '-').?;
        ranges.appendAssumeCapacity(Range{
            .min = try std.fmt.parseUnsigned(u32, str_range[0..str_range_split_idx], 10),
            .max = try std.fmt.parseUnsigned(u32, str_range[str_range_split_idx + 1 ..], 10),
        });
    }
    std.sort.sort(Range, ranges.slice(), {}, Range.lessThan);
    var lowest_allowed_ip_opt: ?u32 = null;
    var allowed_ip_count: u32 = 0;
    var ip: u32 = 0;
    for (ranges.constSlice()) |range| {
        while (ip < range.min) : (ip += 1) {
            if (lowest_allowed_ip_opt == null) lowest_allowed_ip_opt = ip;
            allowed_ip_count += 1;
        }
        if (ip < range.max) {
            if (range.max < max_ip)
                ip = range.max + 1
            else {
                ip = max_ip;
                break;
            }
        }
    }
    allowed_ip_count += max_ip - ip;
    return Solution{ .lowest_allowed_ip = lowest_allowed_ip_opt.?, .allowed_ip_count = allowed_ip_count };
}

test "Day 20" {
    const solution = try findLowestAllowedIpAndCountAllowedIps("5-8\n0-2\n4-7", 9);
    try std.testing.expect(3 == solution.lowest_allowed_ip);
    try std.testing.expect(2 == solution.allowed_ip_count);
}
