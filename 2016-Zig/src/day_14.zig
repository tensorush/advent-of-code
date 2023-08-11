const std = @import("std");

const MAX_BUF_LEN: u8 = 1 << 5;

const KeyArray = std.BoundedArray(CharSequence, 1 << 7);
const TripletArray = std.BoundedArray(CharSequence, 1 << 11);

pub fn solve() (std.fmt.BufPrintError || error{Overflow})!void {
    const salt = "ahsbgdzn";
    std.debug.print("--- Day 14: One-Time Pad ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try find64thKeyIndex(salt, false)});
    std.debug.print("Part 2: {d}\n", .{try find64thKeyIndex(salt, true)});
}

const CharSequence = struct {
    start_idx: u16,
    char: u8,

    fn lessThan(_: void, lhs: CharSequence, rhs: CharSequence) bool {
        return lhs.start_idx < rhs.start_idx;
    }
};

fn find64thKeyIndex(salt: []const u8, is_part2: bool) (std.fmt.BufPrintError || error{Overflow})!u16 {
    var hash: [std.crypto.hash.Md5.digest_length]u8 = undefined;
    var hash_buf: [MAX_BUF_LEN]u8 = undefined;
    var triplets = try TripletArray.init(0);
    var keys = try KeyArray.init(0);
    var idx1: u16 = 0;
    while (true) : (idx1 += 1) {
        var hash_input = try std.fmt.bufPrint(hash_buf[0..], "{s}{d}", .{ salt, idx1 });
        std.crypto.hash.Md5.hash(hash_input, &hash, .{});
        if (is_part2) {
            var idx2: u16 = 0;
            while (idx2 < 2016) : (idx2 += 1) {
                const hash_hex_input = try std.fmt.bufPrint(hash_buf[0..], "{}", .{std.fmt.fmtSliceHexLower(hash[0..])});
                std.crypto.hash.Md5.hash(hash_hex_input, &hash, .{});
            }
        }
        const hex_hash = try std.fmt.bufPrint(hash_buf[0..], "{}", .{std.fmt.fmtSliceHexLower(hash[0..])});
        if (findRepeatedChar(5, hex_hash)) |char| {
            var triplet: CharSequence = undefined;
            var triplet_idx: usize = 0;
            while (triplet_idx < triplets.len) {
                triplet = triplets.get(triplet_idx);
                if (idx1 > triplet.start_idx + 1000) {
                    _ = triplets.orderedRemove(triplet_idx);
                } else if (char == triplet.char) {
                    keys.appendAssumeCapacity(triplet);
                    _ = triplets.orderedRemove(triplet_idx);
                } else {
                    triplet_idx += 1;
                }
            }
        }
        if (keys.len > 63) {
            std.sort.block(CharSequence, keys.slice(), {}, CharSequence.lessThan);
            return keys.get(63).start_idx;
        }
        if (findRepeatedChar(3, hex_hash)) |char| triplets.appendAssumeCapacity(.{ .start_idx = idx1, .char = char });
    }
}

fn findRepeatedChar(num_reps: u4, hex_hash: []const u8) ?u8 {
    var rep_count: u4 = 0;
    var prev_char: u8 = 0;
    for (hex_hash) |char| {
        if (char == prev_char) {
            rep_count += 1;
        } else {
            prev_char = char;
            rep_count = 1;
        }
        if (rep_count >= num_reps) return prev_char;
    }
    return null;
}

test "Day 14" {
    const salt = "abc";
    try std.testing.expect(22_728 == try find64thKeyIndex(salt, false));
    try std.testing.expect(22_551 == try find64thKeyIndex(salt, true));
}
