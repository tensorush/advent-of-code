const std = @import("std");

const PointMinHeap = std.PriorityQueue(Point, void, Point.lessThan);

pub fn main() std.mem.Allocator.Error!void {
    const input = @embedFile("inputs/day_24.txt");
    var map = Map(183, 39, 8){};
    map.parseLocations(input);
    try map.findShortestPathLens(std.heap.page_allocator);
    std.debug.print("--- Day 24: Air Duct Spelunking ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{map.findMinShortestPathLen(false)});
    std.debug.print("Part 2: {d}\n", .{map.findMinShortestPathLen(true)});
}

const Location = union(enum) { Digit: enum { @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7" }, NonDigit: enum { Passage, Wall } };

const Move = enum { Up, Down, Left, Right };

const Point = struct {
    f_score: u16 = undefined,
    path_len: u16 = 0,
    x: u8,
    y: u8,

    fn isLast(self: Point, end_point: Point) bool {
        return self.x == end_point.x and self.y == end_point.y;
    }

    fn lessThan(_: void, lhs: Point, rhs: Point) std.math.Order {
        return std.math.order(lhs.f_score, rhs.f_score);
    }
};

fn Map(comptime width: u8, comptime height: u8, comptime num_points: u4) type {
    return struct {
        const Self = @This();

        shortest_path_lens: [num_points][num_points]u16 = undefined,
        locations: [height][width]Location = undefined,
        points: [num_points]Point = undefined,

        fn parseLocations(self: *Self, input: []const u8) void {
            var str_row_iter = std.mem.tokenize(u8, input, "\n");
            var str_row: []const u8 = undefined;
            for (self.locations) |*row, y| {
                str_row = str_row_iter.next().?;
                for (str_row) |str_location, x| {
                    if (str_location == '.') {
                        row[x] = .{ .NonDigit = .Passage };
                    } else if (str_location == '#') {
                        row[x] = .{ .NonDigit = .Wall };
                    } else {
                        row[x] = .{ .Digit = @intToEnum(std.meta.TagPayload(Location, .Digit), str_location - '0') };
                        self.points[str_location - '0'] = .{ .x = @intCast(u8, x), .y = @intCast(u8, y) };
                    }
                }
            }
        }

        fn findShortestPathLens(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!void {
            var closed_set: [height][width]bool = undefined;
            var open_set: [height][width]bool = undefined;
            var open_min_heap: PointMinHeap = undefined;
            var does_move_left: bool = undefined;
            var does_move_up: bool = undefined;
            var start_point: Point = undefined;
            var end_point: Point = undefined;
            var point_combination = [2]u4{ 0, 1 };
            var combination_opt: ?[]u4 = point_combination[0..];
            while (combination_opt) |combination| : (combination_opt = nextCombination(u4, num_points, combination)) {
                closed_set = [1][width]bool{[1]bool{false} ** width} ** height;
                open_set = [1][width]bool{[1]bool{false} ** width} ** height;
                start_point = self.points[combination[0]];
                end_point = self.points[combination[1]];
                does_move_left = start_point.x > end_point.x;
                does_move_up = start_point.y > end_point.y;
                start_point.f_score = if (does_move_left) start_point.x - end_point.x else end_point.x - start_point.x + if (does_move_up) start_point.y - end_point.y else end_point.y - start_point.y;
                open_min_heap = PointMinHeap.init(allocator, {});
                defer open_min_heap.deinit();
                try open_min_heap.add(start_point);
                while (open_min_heap.removeOrNull()) |point| {
                    if (point.isLast(end_point)) {
                        self.shortest_path_lens[combination[0]][combination[1]] = point.path_len;
                        self.shortest_path_lens[combination[1]][combination[0]] = point.path_len;
                        break;
                    }
                    closed_set[point.y][point.x] = true;
                    open_set[point.y][point.x] = false;
                    if (std.meta.activeTag(self.locations[point.y][point.x]) != .NonDigit or self.locations[point.y][point.x].NonDigit != .Wall) {
                        for ([4]Move{ .Right, .Left, .Down, .Up }) |move| {
                            try open_min_heap.add(switch (move) {
                                .Right => blk: {
                                    if (closed_set[point.y][point.x + 1] or open_set[point.y][point.x + 1]) continue;
                                    break :blk .{ .f_score = if (does_move_left) point.f_score + 2 else point.f_score, .path_len = point.path_len + 1, .x = point.x + 1, .y = point.y };
                                },
                                .Left => blk: {
                                    if (closed_set[point.y][point.x - 1] or open_set[point.y][point.x - 1]) continue;
                                    break :blk .{ .f_score = if (does_move_left) point.f_score else point.f_score + 2, .path_len = point.path_len + 1, .x = point.x - 1, .y = point.y };
                                },
                                .Down => blk: {
                                    if (closed_set[point.y + 1][point.x] or open_set[point.y + 1][point.x]) continue;
                                    break :blk .{ .f_score = if (does_move_up) point.f_score + 2 else point.f_score, .path_len = point.path_len + 1, .x = point.x, .y = point.y + 1 };
                                },
                                .Up => blk: {
                                    if (closed_set[point.y - 1][point.x] or open_set[point.y - 1][point.x]) continue;
                                    break :blk .{ .f_score = if (does_move_up) point.f_score else point.f_score + 2, .path_len = point.path_len + 1, .x = point.x, .y = point.y - 1 };
                                },
                            });
                        }
                    }
                }
            }
        }

        fn findMinShortestPathLen(self: Self, is_part2: bool) u16 {
            var min_shortest_path_len: u16 = std.math.maxInt(u16);
            var point_permutation: [num_points - 1]u4 = undefined;
            var point_idx: u4 = 1;
            while (point_idx < num_points) : (point_idx += 1) {
                point_permutation[point_idx - 1] = point_idx;
            }
            var permutation_opt: ?[]u4 = point_permutation[0..];
            var shortest_path_len: u16 = undefined;
            while (permutation_opt) |permutation| : (permutation_opt = nextPermutation(u4, permutation)) {
                shortest_path_len = self.shortest_path_lens[0][permutation[0]];
                point_idx = 1;
                while (point_idx < permutation.len) : (point_idx += 1) {
                    shortest_path_len += self.shortest_path_lens[permutation[point_idx - 1]][permutation[point_idx]];
                }
                if (is_part2) shortest_path_len += self.shortest_path_lens[0][permutation[permutation.len - 1]];
                if (shortest_path_len < min_shortest_path_len) min_shortest_path_len = shortest_path_len;
            }
            return min_shortest_path_len;
        }
    };
}

fn nextCombination(comptime T: type, num_elements: usize, combination: []T) ?[]T {
    std.debug.assert(num_elements > 1 and combination.len < num_elements);
    var i = @intCast(T, combination.len - 1);
    while (combination[i] > num_elements - combination.len + i - 1) : (i -= 1) {
        if (i == 0) return null;
    }
    combination[i] += 1;
    var j = i + 1;
    while (j < combination.len) : (j += 1) {
        combination[j] = combination[i] + j - i;
    }
    return combination;
}

fn nextPermutation(comptime T: type, permutation: []T) ?[]T {
    std.debug.assert(permutation.len > 1);
    var i = permutation.len - 2;
    while (permutation[i] > permutation[i + 1]) : (i -= 1) {
        if (i == 0) return null;
    }
    var j = permutation.len - 1;
    while (permutation[j] < permutation[i]) : (j -= 1) {}
    std.mem.swap(T, &permutation[i], &permutation[j]);
    i += 1;
    j = permutation.len - 1;
    while (i < j) : (i += 1) {
        std.mem.swap(T, &permutation[i], &permutation[j]);
        j -= 1;
    }
    return permutation;
}

test "Day 24" {
    var map = Map(11, 5, 5){};
    map.parseLocations("###########\n#0.1.....2#\n#.#######.#\n#4.......3#\n###########");
    try map.findShortestPathLens(std.testing.allocator);
    try std.testing.expect(14 == map.findMinShortestPathLen(false));
}
