const std = @import("std");

pub fn solve() std.mem.Allocator.Error!void {
    const initial_state = "11110010111001001";
    var checksum = Checksum{ .allocator = std.heap.page_allocator };
    defer checksum.deinit();
    std.debug.print("--- Day 16: Dragon Checksum ---\n", .{});
    std.debug.print("Part 1: {s}", .{try checksum.generateChecksum(initial_state, 272)});
    std.debug.print("Part 2: {s}", .{try checksum.generateChecksum(initial_state, 35_651_584)});
}

const Checksum = struct {
    bit_set: std.bit_set.DynamicBitSetUnmanaged = undefined,
    allocator: std.mem.Allocator,
    len: usize = undefined,

    fn deinit(self: *Checksum) void {
        self.bit_set.deinit(self.allocator);
    }

    fn generateChecksum(self: *Checksum, initial_state: []const u8, comptime disk_len: usize) std.mem.Allocator.Error!*const Checksum {
        self.bit_set = try std.bit_set.DynamicBitSetUnmanaged.initEmpty(self.allocator, disk_len);
        for (initial_state) |char, i| {
            self.bit_set.setValue(i, char == '1');
        }
        var checksum_idx = initial_state.len;
        var checksum_rev_idx = checksum_idx;
        while (checksum_idx < disk_len) : (checksum_rev_idx = checksum_idx) {
            checksum_idx += 1;
            while (checksum_rev_idx > 0 and checksum_idx < disk_len) : (checksum_rev_idx -= 1) {
                self.bit_set.setValue(checksum_idx, !self.bit_set.isSet(checksum_rev_idx - 1));
                checksum_idx += 1;
            }
        }
        var checksum_pair_idx: usize = undefined;
        var checksum_len = disk_len;
        while (checksum_len % 2 == 0) : (checksum_len /= 2) {
            checksum_pair_idx = 0;
            checksum_idx = 0;
            while (checksum_pair_idx < checksum_len) : (checksum_pair_idx += 2) {
                self.bit_set.setValue(checksum_idx, self.bit_set.isSet(checksum_pair_idx) == self.bit_set.isSet(checksum_pair_idx + 1));
                checksum_idx += 1;
            }
        }
        self.len = checksum_len;
        return self;
    }

    pub fn format(self: Checksum, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
        var checksum_iter = self.bit_set.iterator(.{});
        var checksum_idx: usize = 0;
        while (checksum_iter.next()) |set_bit_idx| {
            if (set_bit_idx < self.len) {
                while (checksum_idx < set_bit_idx) : (checksum_idx += 1) {
                    try writer.writeAll("0");
                }
                try writer.writeAll("1");
                checksum_idx += 1;
            } else {
                while (checksum_idx < self.len) : (checksum_idx += 1) {
                    try writer.writeAll("0");
                }
                break;
            }
        }
        try writer.writeAll("\n");
    }
};

test "Day 16" {
    var checksum = Checksum{ .allocator = std.testing.allocator };
    defer checksum.deinit();
    try std.testing.expectFmt("01100\n", "{s}", .{try checksum.generateChecksum("10000", 20)});
}
