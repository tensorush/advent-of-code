const std = @import("std");

const NodeArray = std.BoundedArray(Node, 1 << 10);

pub fn solve() std.fmt.ParseIntError!void {
    const input = @embedFile("../inputs/day_22.txt");
    var grid = Grid(32, 31){};
    try grid.parseGrid(input);
    const nodes = try parseNodes(input);
    std.debug.print("--- Day 22: Grid Computing ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{countViableNodePairs(nodes)});
    std.debug.print("Part 2: \n{s}", .{grid});
}

const Node = struct {
    avail: u16 = undefined,
    used: u16,

    fn availLessThan(_: void, lhs: Node, rhs: Node) bool {
        return lhs.avail > rhs.avail;
    }

    fn usedLessThan(_: void, lhs: Node, rhs: Node) bool {
        return lhs.used < rhs.used;
    }
};

fn Grid(comptime width: u8, comptime height: u8) type {
    return struct {
        const Self = @This();

        nodes: [height][width]Node = undefined,

        fn parseGrid(self: *Self, input: []const u8) std.fmt.ParseIntError!void {
            var str_column_iter: std.mem.TokenIterator(u8) = undefined;
            var str_node_iter = std.mem.tokenize(u8, input, "\n");
            var str_column: []const u8 = undefined;
            var x_y_split_idx: usize = undefined;
            var used: u16 = undefined;
            var x: u16 = undefined;
            var y: u16 = undefined;
            while (str_node_iter.next()) |str_node| {
                str_column_iter = std.mem.tokenize(u8, str_node, " T");
                str_column = str_column_iter.next().?;
                x_y_split_idx = std.mem.indexOfScalarPos(u8, str_column, 16, '-').?;
                x = try std.fmt.parseUnsigned(u8, str_column[16..x_y_split_idx], 10);
                y = try std.fmt.parseUnsigned(u8, str_column[x_y_split_idx + 2 ..], 10);
                _ = str_column_iter.next();
                used = try std.fmt.parseUnsigned(u16, str_column_iter.next().?, 10);
                _ = str_column_iter.next();
                self.nodes[y][x] = .{ .used = used };
            }
        }

        pub fn format(self: Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
            var str_node: []const u8 = undefined;
            for (self.nodes) |row, y| {
                if (y >= height) continue;
                for (row) |node, x| {
                    if (x >= width) continue;
                    if (node.used > 100) {
                        str_node = " # ";
                    } else if (node.used == 0) {
                        str_node = " _ ";
                    } else if (y == 0 and x == 0) {
                        str_node = "(.)";
                    } else if (y == 0 and x == width - 1) {
                        str_node = " G ";
                    } else {
                        str_node = " . ";
                    }
                    try writer.writeAll(str_node);
                }
                try writer.writeAll("\n");
            }
        }
    };
}

fn parseNodes(input: []const u8) std.fmt.ParseIntError!NodeArray {
    var str_column_iter: std.mem.TokenIterator(u8) = undefined;
    var str_node_iter = std.mem.tokenize(u8, input, "\n");
    var nodes = try NodeArray.init(0);
    var avail: u16 = undefined;
    var used: u16 = undefined;
    while (str_node_iter.next()) |str_node| {
        str_column_iter = std.mem.tokenize(u8, str_node, " T");
        _ = str_column_iter.next();
        _ = str_column_iter.next();
        used = try std.fmt.parseUnsigned(u16, str_column_iter.next().?, 10);
        avail = try std.fmt.parseUnsigned(u16, str_column_iter.next().?, 10);
        nodes.appendAssumeCapacity(.{ .used = used, .avail = avail });
    }
    return nodes;
}

fn countViableNodePairs(nodes: NodeArray) usize {
    var viable_node_pair_count: usize = 0;
    var avail_nodes = nodes;
    var used_nodes = nodes;
    std.sort.sort(Node, used_nodes.slice(), {}, Node.usedLessThan);
    std.sort.sort(Node, avail_nodes.slice(), {}, Node.availLessThan);
    for (used_nodes.constSlice()) |used_node| {
        if (used_node.used > 100 or used_node.used == 0) continue;
        for (avail_nodes.constSlice()) |avail_node, i| {
            if (avail_node.avail < used_node.used) {
                viable_node_pair_count += i;
                break;
            }
        }
    }
    return viable_node_pair_count;
}

test "Day 22" {
    const input = "/dev/grid/node-x0-y0   10T    8T     2T   80%\n/dev/grid/node-x0-y1   11T    6T     5T   54%\n/dev/grid/node-x0-y2   32T   28T     4T   87%\n/dev/grid/node-x1-y0    9T    7T     2T   77%\n/dev/grid/node-x1-y1    8T    0T     8T    0%\n/dev/grid/node-x1-y2   11T    7T     4T   63%\n/dev/grid/node-x2-y0   10T    6T     4T   60%\n/dev/grid/node-x2-y1    9T    8T     1T   88%\n/dev/grid/node-x2-y2    9T    6T     3T   66%";
    var grid = Grid(3, 3){};
    try grid.parseGrid(input);
    try std.testing.expectFmt("(.) .  G \n .  _  . \n .  .  . \n", "{s}", .{grid});
}
