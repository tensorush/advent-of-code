const std = @import("std");

const MAX_BUF_LEN: u8 = 1 << 7;
const PASSWORD_LEN: u4 = 1 << 3;

pub fn solve() std.fmt.BufPrintError!void {
    const door_id = "reyedfim";
    std.debug.print("--- Day 5: How About a Nice Game of Chess? ---\n", .{});
    std.debug.print("Part 1: {s}\n", .{try findPassword(door_id, true)});
    std.debug.print("Part 2: {s}\n", .{try findPassword(door_id, false)});
}

fn findPassword(door_id: []const u8, comptime is_part1: bool) std.fmt.BufPrintError![]const u8 {
    var hash: [std.crypto.hash.Md5.digest_length]u8 = undefined;
    var hash_buf: [MAX_BUF_LEN]u8 = undefined;
    var password = [1]u8{0} ** PASSWORD_LEN;
    var hash_input: []const u8 = undefined;
    var hex_hash: []const u8 = undefined;
    var position_opt: ?u8 = undefined;
    var password_idx: u4 = 0;
    var integer: u32 = 0;
    while (password_idx < PASSWORD_LEN) : (integer += 1) {
        hash_input = try std.fmt.bufPrint(hash_buf[0..], "{s}{d}", .{ door_id, integer });
        std.crypto.hash.Md5.hash(hash_input, &hash, .{});
        hex_hash = try std.fmt.bufPrint(hash_buf[0..], "{x}", .{std.fmt.fmtSliceHexLower(hash[0..])});
        if (std.mem.eql(u8, "00000", hex_hash[0..5])) {
            if (is_part1) {
                password[password_idx] = hex_hash[5];
                password_idx += 1;
            } else {
                position_opt = std.fmt.parseUnsigned(u8, hex_hash[5..6], 10) catch null;
                if (position_opt) |position| {
                    if (position < PASSWORD_LEN and password[position] == 0) {
                        password[position] = hex_hash[6];
                        password_idx += 1;
                    }
                }
            }
        }
    }
    return password[0..];
}

test "Day 5" {
    const door_id = "abc";
    try std.testing.expectEqualStrings("18f47a30", try findPassword(door_id, true));
    try std.testing.expectEqualStrings("05ace8e3", try findPassword(door_id, false));
}
