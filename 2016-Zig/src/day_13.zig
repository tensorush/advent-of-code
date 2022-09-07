const std = @import("std");

const MAX_PATH_LEN: u8 = 49;
const MAX_SIDE_LEN: u16 = 1 << 6;

const PointQueue = std.TailQueue(Point);

pub fn solve() std.mem.Allocator.Error!void {
    var start = Point{};
    var favorite_number: u16 = 1362;
    var end = Point{ .x = 31, .y = 39 };
    std.debug.print("--- Day 13: A Maze of Twisty Little Cubicles ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try findShortestPathLen(std.heap.page_allocator, start, end, favorite_number, false)});
    std.debug.print("Part 2: {d}\n", .{try findShortestPathLen(std.heap.page_allocator, start, end, favorite_number, true)});
}

const Point = struct {
    x: u16 = 1,
    y: u16 = 1,

    fn isOpen(self: Point, favorite_number: u16) bool {
        return @popCount(self.x * self.x + 3 * self.x + 2 * self.x * self.y + self.y + self.y * self.y + favorite_number) % 2 == 0;
    }
};

fn findShortestPathLen(allocator: std.mem.Allocator, start: Point, end: Point, favorite_number: u16, is_part2: bool) std.mem.Allocator.Error!u8 {
    var shortest_path_lens = [1][MAX_SIDE_LEN]u8{[1]u8{std.math.maxInt(u8)} ** MAX_SIDE_LEN} ** MAX_SIDE_LEN;
    shortest_path_lens[start.y][start.x] = 0;
    var reachable_point_count: u8 = 1;
    var next_point: Point = undefined;
    var left_opt: ?Point = undefined;
    var up_opt: ?Point = undefined;
    var point: Point = undefined;
    var right: Point = undefined;
    var down: Point = undefined;
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    var point_queue = PointQueue{};
    var next_node = try arena_allocator.create(PointQueue.Node);
    next_node.* = .{ .data = start };
    point_queue.prepend(next_node);
    while (point_queue.pop()) |node| {
        point = node.data;
        if (is_part2) {
            if (shortest_path_lens[point.y][point.x] > MAX_PATH_LEN) continue;
        } else if (std.meta.eql(point, end)) {
            return shortest_path_lens[point.y][point.x];
        }
        left_opt = if (point.x > 0) Point{ .x = point.x - 1, .y = point.y } else null;
        up_opt = if (point.y > 0) Point{ .x = point.x, .y = point.y - 1 } else null;
        right = Point{ .x = point.x + 1, .y = point.y };
        down = Point{ .x = point.x, .y = point.y + 1 };
        for ([4]?Point{ down, right, up_opt, left_opt }) |next_opt| {
            next_point = next_opt orelse continue;
            if (shortest_path_lens[next_point.y][next_point.x] == std.math.maxInt(u8) and next_point.isOpen(favorite_number)) {
                shortest_path_lens[next_point.y][next_point.x] = shortest_path_lens[point.y][point.x] + 1;
                next_node = try arena_allocator.create(PointQueue.Node);
                next_node.* = .{ .data = next_point };
                point_queue.prepend(next_node);
                if (is_part2) reachable_point_count += 1;
            }
        }
    }
    return reachable_point_count;
}

test "Day 13" {
    var start = Point{};
    const favorite_number: u16 = 10;
    var end = Point{ .x = 7, .y = 4 };
    try std.testing.expect(11 == try findShortestPathLen(std.testing.allocator, start, end, favorite_number, false));
}
