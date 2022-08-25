const std = @import("std");

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_03.txt");
    std.debug.print("--- Day 3: Squares With Three Sides ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try parseAndCountRowTriangles(input)});
    std.debug.print("Part 2: {d}\n", .{try parseAndCountColumnTriangles(input)});
}

const Triangle = struct { a: u16, b: u16, c: u16 };

fn parseAndCountRowTriangles(input: []const u8) std.fmt.ParseIntError!u16 {
    var str_triangle_iter = std.mem.tokenize(u8, input, "\n");
    var str_sides: [3][]const u8 = undefined;
    var triangle: Triangle = undefined;
    var triangle_count: u16 = 0;
    while (str_triangle_iter.next()) |str_triangle| {
        populateSideTriple(&str_sides, str_triangle);
        triangle = .{
            .a = try std.fmt.parseUnsigned(u16, str_sides[0], 10),
            .b = try std.fmt.parseUnsigned(u16, str_sides[1], 10),
            .c = try std.fmt.parseUnsigned(u16, str_sides[2], 10),
        };
        if (isTriangle(triangle)) triangle_count += 1;
    }
    return triangle_count;
}

fn parseAndCountColumnTriangles(input: []const u8) std.fmt.ParseIntError!u16 {
    var str_triangle_iter = std.mem.tokenize(u8, input, "\n");
    var str_sides_triples: [3][3][]const u8 = undefined;
    var triangle: Triangle = undefined;
    var triangle_count: u16 = 0;
    var triple: u2 = undefined;
    while (str_triangle_iter.next()) |str_triangle| {
        populateSideTriple(&str_sides_triples[0], str_triangle);
        populateSideTriple(&str_sides_triples[1], str_triangle_iter.next().?);
        populateSideTriple(&str_sides_triples[2], str_triangle_iter.next().?);
        triple = 0;
        while (triple < 3) : (triple += 1) {
            triangle = .{
                .a = try std.fmt.parseUnsigned(u16, str_sides_triples[0][triple], 10),
                .b = try std.fmt.parseUnsigned(u16, str_sides_triples[1][triple], 10),
                .c = try std.fmt.parseUnsigned(u16, str_sides_triples[2][triple], 10),
            };
            if (isTriangle(triangle)) triangle_count += 1;
        }
    }
    return triangle_count;
}

fn populateSideTriple(str_side_triple: *[3][]const u8, str_triangle: []const u8) void {
    var str_side_iter = std.mem.tokenize(u8, str_triangle, " ");
    str_side_triple[0] = str_side_iter.next().?;
    str_side_triple[1] = str_side_iter.next().?;
    str_side_triple[2] = str_side_iter.next().?;
}

fn isTriangle(triangle: Triangle) bool {
    return triangle.a + triangle.b > triangle.c and triangle.a + triangle.c > triangle.b and triangle.b + triangle.c > triangle.a;
}

test "Day 3" {
    const input = "101 301 501\n102 302 502\n103 303 503\n201 401 601\n202 402 602\n203 403 603";
    try std.testing.expect(6 == try parseAndCountColumnTriangles(input));
}
