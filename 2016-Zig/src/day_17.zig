const std = @import("std");

const MAX_SIDE_IDX: u4 = 3;
const MAX_PATH_LEN: u16 = 1 << 10;

const StateMinHeap = std.PriorityQueue(State, void, State.lessThan);

pub fn main() (std.mem.Allocator.Error || std.fmt.BufPrintError)!void {
    const input = "gdjjyniy";
    var path: [MAX_PATH_LEN]u8 = undefined;
    std.debug.print("--- Day 17: Two Steps Forward ---\n", .{});
    std.debug.print("Part 1: {s}\n", .{try findShortestPath(std.heap.page_allocator, input, path[0..])});
    std.debug.print("Part 2: {d}\n", .{try findLongestPathLen(input, .{})});
}

const Move = enum { Up, Down, Left, Right };

const State = struct {
    path: [MAX_PATH_LEN]u8 = undefined,
    f_score: u16 = 2 * MAX_SIDE_IDX,
    path_len: u16 = 0,
    x: u2 = 0,
    y: u2 = 0,

    fn nextStates(self: State, comptime input: []const u8, comptime moves: []const Move) std.fmt.BufPrintError![moves.len]?State {
        var hash: [std.crypto.hash.Md5.digest_length]u8 = undefined;
        var hash_buf: [MAX_PATH_LEN + input.len]u8 = undefined;
        var next_states = [1]?State{null} ** moves.len;
        var path: [MAX_PATH_LEN]u8 = undefined;
        var hash_input: []const u8 = undefined;
        var hex_hash: []const u8 = undefined;
        var x: u2 = undefined;
        var y: u2 = undefined;
        hash_input = try std.fmt.bufPrint(hash_buf[0..], "{s}{s}", .{ input, self.path[0..self.path_len] });
        std.crypto.hash.Md5.hash(hash_input, &hash, .{});
        hex_hash = try std.fmt.bufPrint(hash_buf[0..], "{x}", .{std.fmt.fmtSliceHexLower(hash[0..])});
        for (moves) |move, i| {
            x = self.x;
            y = self.y;
            switch (move) {
                .Down => {
                    if (y < MAX_SIDE_IDX) y += 1 else continue;
                },
                .Right => {
                    if (x < MAX_SIDE_IDX) x += 1 else continue;
                },
                .Up => {
                    if (y > 0) y -= 1 else continue;
                },
                .Left => {
                    if (x > 0) x -= 1 else continue;
                },
            }
            if (std.mem.indexOfScalar(u8, "bcdef", hex_hash[@enumToInt(move)])) |_| {
                path[self.path_len] = @tagName(move)[0];
                std.mem.copy(u8, path[0..], self.path[0..self.path_len]);
                next_states[i] = .{ .path = path, .f_score = 2 * MAX_SIDE_IDX + self.path_len - x - y + 1, .path_len = self.path_len + 1, .x = x, .y = y };
            }
        }
        return next_states;
    }

    fn isLast(self: State) bool {
        return self.x == MAX_SIDE_IDX and self.y == MAX_SIDE_IDX;
    }

    fn lessThan(_: void, lhs: State, rhs: State) std.math.Order {
        return std.math.order(lhs.f_score, rhs.f_score);
    }
};

fn findShortestPath(allocator: std.mem.Allocator, comptime input: []const u8, shortest_path: []u8) (std.mem.Allocator.Error || std.fmt.BufPrintError)![]u8 {
    return blk: {
        var open_min_heap = StateMinHeap.init(allocator, {});
        defer open_min_heap.deinit();
        try open_min_heap.add(.{});
        while (open_min_heap.removeOrNull()) |state| {
            if (state.isLast()) {
                std.mem.copy(u8, shortest_path, state.path[0..state.path_len]);
                break :blk shortest_path[0..state.path_len];
            }
            for (try state.nextStates(input, &[4]Move{ .Down, .Right, .Up, .Left })) |next_state_opt| {
                if (next_state_opt) |next_state| try open_min_heap.add(next_state);
            }
        }
        unreachable;
    };
}

fn findLongestPathLen(comptime input: []const u8, state: State) std.fmt.BufPrintError!u16 {
    var longest_path_len: u16 = 0;
    if (state.isLast()) return state.path_len;
    for (try state.nextStates(input, &[4]Move{ .Left, .Up, .Right, .Down })) |next_state_opt| {
        if (next_state_opt) |next_state| longest_path_len = std.math.max(longest_path_len, try findLongestPathLen(input, next_state));
    }
    return longest_path_len;
}

test "Day 17" {
    var path: [MAX_PATH_LEN]u8 = undefined;
    try std.testing.expectEqualStrings("DDRRRD", try findShortestPath(std.testing.allocator, "ihgpwlah", path[0..]));
    try std.testing.expectEqualStrings("DDUDRLRRUDRD", try findShortestPath(std.testing.allocator, "kglvqrro", path[0..]));
    try std.testing.expectEqualStrings("DRURDRUDDLLDLUURRDULRLDUUDDDRR", try findShortestPath(std.testing.allocator, "ulqzkmiv", path[0..]));
    try std.testing.expect(370 == try findLongestPathLen("ihgpwlah", .{}));
    try std.testing.expect(492 == try findLongestPathLen("kglvqrro", .{}));
    try std.testing.expect(830 == try findLongestPathLen("ulqzkmiv", .{}));
}
