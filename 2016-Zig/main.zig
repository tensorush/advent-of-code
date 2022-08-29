const std = @import("std");
const day_01 = @import("src/day_01.zig");
const day_02 = @import("src/day_02.zig");
const day_03 = @import("src/day_03.zig");
const day_04 = @import("src/day_04.zig");
const day_05 = @import("src/day_05.zig");
const day_06 = @import("src/day_06.zig");
const day_07 = @import("src/day_07.zig");
const day_08 = @import("src/day_08.zig");
const day_09 = @import("src/day_09.zig");
const day_10 = @import("src/day_10.zig");
const day_11 = @import("src/day_11.zig");
const day_12 = @import("src/day_12.zig");
const day_13 = @import("src/day_13.zig");
const day_14 = @import("src/day_14.zig");
const day_15 = @import("src/day_15.zig");
const day_16 = @import("src/day_16.zig");
const day_17 = @import("src/day_17.zig");
const day_18 = @import("src/day_18.zig");
const day_19 = @import("src/day_19.zig");
const day_20 = @import("src/day_20.zig");
const day_21 = @import("src/day_21.zig");
const day_22 = @import("src/day_22.zig");
const day_23 = @import("src/day_23.zig");
const day_24 = @import("src/day_24.zig");
const day_25 = @import("src/day_25.zig");

pub fn main() (std.fmt.BufPrintError || std.mem.Allocator.Error || std.fmt.ParseIntError || error{Overflow})!void {
    _ = try @import("src/day_01.zig").solve();
    _ = try @import("src/day_02.zig").solve();
    _ = try @import("src/day_03.zig").solve();
    _ = try @import("src/day_04.zig").solve();
    _ = try @import("src/day_05.zig").solve();
    _ = @import("src/day_06.zig").solve();
    _ = try @import("src/day_07.zig").solve();
    _ = try @import("src/day_08.zig").solve();
    _ = try @import("src/day_09.zig").solve();
    _ = try @import("src/day_10.zig").solve();
    _ = try @import("src/day_11.zig").solve();
    _ = try @import("src/day_12.zig").solve();
    _ = try @import("src/day_13.zig").solve();
    _ = try @import("src/day_14.zig").solve();
    _ = try @import("src/day_15.zig").solve();
    _ = try @import("src/day_16.zig").solve();
    _ = try @import("src/day_17.zig").solve();
    _ = @import("src/day_18.zig").solve();
    _ = try @import("src/day_19.zig").solve();
    _ = try @import("src/day_20.zig").solve();
    _ = try @import("src/day_21.zig").solve();
    _ = try @import("src/day_22.zig").solve();
    _ = try @import("src/day_23.zig").solve();
    _ = try @import("src/day_24.zig").solve();
    _ = try @import("src/day_25.zig").solve();
}

test {
    std.testing.refAllDecls(@This());
}
