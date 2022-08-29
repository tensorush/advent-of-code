const std = @import("std");

const ThreeCharArray = std.BoundedArray([]const u8, 1 << 4);

pub fn solve() error{Overflow}!void {
    var tls_count: u16 = 0;
    var ssl_count: u16 = 0;
    const input = @embedFile("../inputs/day_07.txt");
    var ip_iter = std.mem.tokenize(u8, input, "\n");
    while (ip_iter.next()) |ip| {
        if (doesSupportTls(ip)) tls_count += 1;
        if (try doesSupportSsl(ip)) ssl_count += 1;
    }
    std.debug.print("--- Day 7: Internet Protocol Version 7 ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{tls_count});
    std.debug.print("Part 2: {d}\n", .{ssl_count});
}

fn doesSupportTls(ip: []const u8) bool {
    var sequence_iter = std.mem.tokenize(u8, ip, "[]");
    var hypernet: []const u8 = undefined;
    var hasSupernetAbba = false;
    while (sequence_iter.next()) |supernet| {
        if (!hasSupernetAbba) hasSupernetAbba = hasAbba(supernet);
        hypernet = sequence_iter.next() orelse break;
        if (hasAbba(hypernet)) return false;
    }
    return hasSupernetAbba;
}

fn hasAbba(sequence: []const u8) bool {
    for (sequence[2..]) |_, i| {
        if (i > sequence.len - 4) break;
        if (sequence[i] == sequence[i + 3] and sequence[i + 1] == sequence[i + 2] and sequence[i] != sequence[i + 1]) return true;
    }
    return false;
}

fn doesSupportSsl(ip: []const u8) error{Overflow}!bool {
    var sequence_iter = std.mem.tokenize(u8, ip, "[]");
    var three_chars: []const u8 = undefined;
    var abas = try ThreeCharArray.init(0);
    var babs = try ThreeCharArray.init(0);
    var hypernet: []const u8 = undefined;
    while (sequence_iter.next()) |supernet| {
        for (supernet) |_, i| {
            if (i > supernet.len - 3) break;
            three_chars = supernet[i .. i + 3];
            if (three_chars[0] == three_chars[2] and three_chars[0] != three_chars[1]) abas.appendAssumeCapacity(three_chars);
        }
        hypernet = sequence_iter.next() orelse break;
        for (hypernet) |_, i| {
            if (i > hypernet.len - 3) break;
            three_chars = hypernet[i .. i + 3];
            if (three_chars[0] == three_chars[2] and three_chars[0] != three_chars[1]) babs.appendAssumeCapacity(three_chars);
        }
    }
    for (abas.constSlice()) |aba| {
        for (babs.constSlice()) |bab| {
            if (std.mem.eql(u8, aba[0..2], bab[1..]) and std.mem.eql(u8, aba[1..], bab[0..2])) return true;
        }
    }
    return false;
}

test "Day 7" {
    try std.testing.expect(doesSupportTls("abba[mnop]qrst"));
    try std.testing.expect(!doesSupportTls("abcd[bddb]xyyx"));
    try std.testing.expect(!doesSupportTls("aaaa[qwer]tyui"));
    try std.testing.expect(doesSupportTls("ioxxoj[asdfgh]zxcvbn"));
    try std.testing.expect(try doesSupportSsl("aba[bab]xyz"));
    try std.testing.expect(!try doesSupportSsl("xyx[xyx]xyx"));
    try std.testing.expect(try doesSupportSsl("aaa[kek]eke"));
    try std.testing.expect(try doesSupportSsl("zazbz[bzb]cdb"));
}
