const std = @import("std");
const day_01 = @import("day_01.zig");
const day_02 = @import("day_02.zig");
const day_03 = @import("day_03.zig");
const day_04 = @import("day_04.zig");
const day_05 = @import("day_05.zig");
const day_06 = @import("day_06.zig");
const day_07 = @import("day_07.zig");
const day_08 = @import("day_08.zig");
const day_09 = @import("day_09.zig");
const day_10 = @import("day_10.zig");
const day_11 = @import("day_11.zig");
const day_12 = @import("day_12.zig");
const day_13 = @import("day_13.zig");
const day_14 = @import("day_14.zig");
const day_15 = @import("day_15.zig");
const day_16 = @import("day_16.zig");
const day_17 = @import("day_17.zig");
const day_18 = @import("day_18.zig");
const day_19 = @import("day_19.zig");
const day_20 = @import("day_20.zig");
const day_21 = @import("day_21.zig");
const day_22 = @import("day_22.zig");
const day_23 = @import("day_23.zig");
const day_24 = @import("day_24.zig");
const day_25 = @import("day_25.zig");

pub fn main() (error{Overflow} || std.fmt.BufPrintError || std.mem.Allocator.Error || std.fmt.ParseIntError)!void {
    try day_01.solve();
    try day_02.solve();
    try day_03.solve();
    try day_04.solve();
    try day_05.solve();
    day_06.solve();
    try day_07.solve();
    try day_08.solve();
    try day_09.solve();
    try day_10.solve();
    try day_11.solve();
    try day_12.solve();
    try day_13.solve();
    try day_14.solve();
    try day_15.solve();
    try day_16.solve();
    try day_17.solve();
    day_18.solve();
    try day_19.solve();
    try day_20.solve();
    try day_21.solve();
    try day_22.solve();
    try day_23.solve();
    try day_24.solve();
    try day_25.solve();
}

test {
    std.testing.refAllDecls(@This());
}
