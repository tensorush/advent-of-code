const std = @import("std");

const PointArray = std.BoundedArray(Point, 1 << 11);
const InstructionArray = std.BoundedArray(Instruction, 1 << 8);

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("../inputs/day_01.txt");
    var path = try makePath(input);
    std.debug.print("--- Day 1: No Time for a Taxicab ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{computeManhattanDistance(.{}, path.pop())});
    std.debug.print("Part 2: {d}\n", .{computeManhattanDistance(.{}, try findFirstPointVisitedTwice(path))});
}

const Instruction = struct { distance: u8, turn: Turn };

const Direction = enum { North, East, South, West };

const Point = struct { x: i16 = 0, y: i16 = 0 };

const Turn = enum { Right, Left };

fn makePath(input: []const u8) std.fmt.ParseIntError!PointArray {
    const instructions = try parseInstructions(input);
    var path = try PointArray.init(0);
    var int_direction: u2 = undefined;
    var direction = Direction.North;
    var distance: u8 = undefined;
    var point = Point{};
    path.appendAssumeCapacity(point);
    for (instructions.constSlice()) |instruction| {
        int_direction = @enumToInt(direction);
        direction = @intToEnum(Direction, switch (instruction.turn) {
            .Right => int_direction +% 1,
            .Left => int_direction -% 1,
        });
        distance = 0;
        while (distance < instruction.distance) : (distance += 1) {
            switch (direction) {
                .North => point.y += 1,
                .East => point.x += 1,
                .South => point.y -= 1,
                .West => point.x -= 1,
            }
            path.appendAssumeCapacity(point);
        }
    }
    return path;
}

fn parseInstructions(input: []const u8) std.fmt.ParseIntError!InstructionArray {
    var str_instruction_iter = std.mem.tokenize(u8, input, ", \n");
    var instructions = try InstructionArray.init(0);
    var distance: u8 = undefined;
    var turn: Turn = undefined;
    while (str_instruction_iter.next()) |str_instruction| {
        turn = if (str_instruction[0] == 'R') .Right else .Left;
        distance = try std.fmt.parseUnsigned(u8, str_instruction[1..], 10);
        instructions.appendAssumeCapacity(.{ .turn = turn, .distance = distance });
    }
    return instructions;
}

fn computeManhattanDistance(point1: Point, point2: Point) u16 {
    return std.math.absCast(point1.x - point2.x) + std.math.absCast(point1.y - point2.y);
}

fn findFirstPointVisitedTwice(path: PointArray) error{Overflow}!Point {
    return blk: {
        var visited_points = try PointArray.init(0);
        for (path.constSlice()) |point| {
            for (visited_points.constSlice()) |visited_point| {
                if (std.meta.eql(point, visited_point)) break :blk point;
            }
            visited_points.appendAssumeCapacity(point);
        }
        unreachable;
    };
}

test "Day 1" {
    var path = try makePath("R2, L3");
    try std.testing.expect(5 == computeManhattanDistance(.{}, path.pop()));
    path = try makePath("R2, R2, R2");
    try std.testing.expect(2 == computeManhattanDistance(.{}, path.pop()));
    path = try makePath("R5, L5, R5, R3");
    try std.testing.expect(12 == computeManhattanDistance(.{}, path.pop()));
    path = try makePath("R8, R4, R4, R8");
    const point = try findFirstPointVisitedTwice(path);
    try std.testing.expect(4 == point.x);
    try std.testing.expect(0 == point.y);
}
