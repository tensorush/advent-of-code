const std = @import("std");

const MAX_ISOTOPE_LEN: u2 = 3;
const NUM_FLOORS: usize = 1 << 2;
const MAX_NUM_STATES: usize = 1 << 22;

const ItemSet = std.enums.EnumSet(Item);

pub fn solve() std.mem.Allocator.Error!void {
    const input = @embedFile("../inputs/day_11.txt");
    std.debug.print("--- Day 11: Radioisotope Thermoelectric Generators ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try findShortestPathLen(std.heap.page_allocator, input, 10, false)});
    std.debug.print("Part 2: {d}\n", .{try findShortestPathLen(std.heap.page_allocator, input, 14, true)});
}

// Items are pairs of compatible generators (even) and microchips (odd) in order of appearance.
// First four are reserved for additions in part 2 and for test input.
const Item = enum { @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13" };

fn Facility(comptime num_items: u4) type {
    return struct {
        floors: [NUM_FLOORS]ItemSet,
        elevator_idx: u2 = 0,

        fn init(input: []const u8, is_part2_opt: ?bool) Facility(num_items) {
            var floors = [NUM_FLOORS]ItemSet{ .{}, .{}, .{}, .{} };
            if (is_part2_opt) |is_part2| {
                var isotope_opts = [1]?[]const u8{null} ** std.meta.fields(Item).len;
                var str_item_iter: std.mem.SplitIterator(u8) = undefined;
                var str_floor_iter = std.mem.tokenize(u8, input, "\n");
                var cur_isotope: []const u8 = undefined;
                var item_split_idx: usize = undefined;
                var isotope_idx: u4 = undefined;
                var floor_idx: u4 = 0;
                var item_idx: u4 = 4;
                if (is_part2) {
                    floors[0].toggle(.@"0");
                    floors[0].toggle(.@"1");
                    floors[0].toggle(.@"2");
                    floors[0].toggle(.@"3");
                }
                while (str_floor_iter.next()) |str_floor| : (floor_idx += 1) {
                    str_item_iter = std.mem.split(u8, str_floor, "a ");
                    _ = str_item_iter.next();
                    str_item_loop: while (str_item_iter.next()) |str_item| {
                        item_split_idx = std.mem.indexOfScalar(u8, str_item, ' ').?;
                        if (str_item[item_split_idx + 1] == 'g') isotope_idx = 0 else isotope_idx = 1;
                        cur_isotope = str_item[0..MAX_ISOTOPE_LEN];
                        while (isotope_idx < std.meta.fields(Item).len) : (isotope_idx += 2) {
                            if (isotope_opts[isotope_idx]) |isotope| {
                                if (std.mem.eql(u8, cur_isotope, isotope)) {
                                    floors[floor_idx].toggle(@intToEnum(Item, isotope_idx));
                                    continue :str_item_loop;
                                }
                            }
                        }
                        if (str_item[item_split_idx + 1] == 'g') {
                            floors[floor_idx].toggle(@intToEnum(Item, item_idx));
                            isotope_opts[item_idx + 1] = cur_isotope;
                        } else {
                            floors[floor_idx].toggle(@intToEnum(Item, item_idx + 1));
                            isotope_opts[item_idx] = cur_isotope;
                        }
                        item_idx += 2;
                    }
                }
            } else {
                floors[1].toggle(.@"0");
                floors[0].toggle(.@"1");
                floors[2].toggle(.@"2");
                floors[0].toggle(.@"3");
            }
            return .{ .floors = floors };
        }

        fn isSafe(self: *Facility(num_items)) bool {
            var has_unpaired_microchip: bool = undefined;
            var last_generator_idx_opt: ?u4 = undefined;
            var item_iter: ItemSet.Iterator = undefined;
            for (self.floors) |*floor| {
                has_unpaired_microchip = false;
                last_generator_idx_opt = null;
                item_iter = floor.iterator();
                while (item_iter.next()) |item| {
                    if (@enumToInt(item) % 2 == 0) {
                        if (has_unpaired_microchip) return false else last_generator_idx_opt = @enumToInt(item);
                    } else {
                        if (last_generator_idx_opt) |last_generator_idx| {
                            if (last_generator_idx != @enumToInt(item) - 1) return false;
                        } else {
                            if (!has_unpaired_microchip) has_unpaired_microchip = true;
                        }
                    }
                }
            }
            return true;
        }

        fn estimateHeuristicCost(self: Facility(num_items)) u32 {
            var heuristic_cost: usize = 0;
            for (self.floors) |floor, i| {
                heuristic_cost += floor.count() * (NUM_FLOORS - i - 1);
            }
            return @intCast(u32, heuristic_cost / 2);
        }

        fn bringItemPair(self: *Facility(num_items), item_pair: []const Item, from_floor_idx: u2, to_floor_idx: u2) void {
            for (item_pair) |item| {
                self.floors[from_floor_idx].toggle(item);
                self.floors[to_floor_idx].toggle(item);
                if (item_pair[0] == item_pair[1]) break;
            }
        }

        fn isLast(self: Facility(num_items)) bool {
            return self.floors[NUM_FLOORS - 1].count() == num_items;
        }

        fn lessThan(f_scores: *const std.AutoHashMapUnmanaged(Facility(num_items), u32), lhs: Facility(num_items), rhs: Facility(num_items)) std.math.Order {
            return std.math.order(f_scores.get(lhs) orelse std.math.maxInt(u32), f_scores.get(rhs) orelse std.math.maxInt(u32));
        }
    };
}

fn findShortestPathLen(allocator: std.mem.Allocator, input: []const u8, comptime num_items: u4, is_part2_opt: ?bool) std.mem.Allocator.Error!u32 {
    return blk: {
        const initial_facility = Facility(num_items).init(input, is_part2_opt);
        var arena = std.heap.ArenaAllocator.init(allocator);
        defer arena.deinit();
        const arena_allocator = arena.allocator();
        var f_scores = std.AutoHashMapUnmanaged(Facility(num_items), u32){};
        try f_scores.ensureTotalCapacity(arena_allocator, MAX_NUM_STATES);
        f_scores.putAssumeCapacity(initial_facility, initial_facility.estimateHeuristicCost());
        var g_scores = std.AutoHashMapUnmanaged(Facility(num_items), u32){};
        try g_scores.ensureTotalCapacity(arena_allocator, MAX_NUM_STATES);
        g_scores.putAssumeCapacity(initial_facility, 0);
        var closed_set = std.AutoHashMapUnmanaged(Facility(num_items), void){};
        try closed_set.ensureTotalCapacity(arena_allocator, MAX_NUM_STATES);
        var open_set = std.AutoHashMapUnmanaged(Facility(num_items), void){};
        try open_set.ensureTotalCapacity(arena_allocator, MAX_NUM_STATES);
        open_set.putAssumeCapacity(initial_facility, {});
        var open_min_heap = std.PriorityQueue(Facility(num_items), *const std.AutoHashMapUnmanaged(Facility(num_items), u32), Facility(num_items).lessThan).init(arena_allocator, &f_scores);
        try open_min_heap.add(initial_facility);
        while (open_min_heap.removeOrNull()) |facility| {
            if (facility.isLast()) break :blk g_scores.get(facility).?;
            closed_set.putAssumeCapacity(facility, {});
            _ = open_set.remove(facility);
            var from_floor_idx = facility.elevator_idx;
            var to_floor_idxs = switch (from_floor_idx) {
                0 => &[1]u2{from_floor_idx + 1},
                NUM_FLOORS - 1 => &[1]u2{from_floor_idx - 1},
                else => &[2]u2{ from_floor_idx + 1, from_floor_idx - 1 },
            };
            for (to_floor_idxs) |to_floor_idx| {
                var facility_copy = facility;
                facility_copy.elevator_idx = to_floor_idx;
                var floor_iter1 = facility_copy.floors[facility.elevator_idx].iterator();
                while (floor_iter1.next()) |item1| {
                    var floor_iter2 = facility_copy.floors[facility.elevator_idx].iterator();
                    while (floor_iter2.next()) |item2| {
                        if (@enumToInt(item2) < @enumToInt(item1)) continue;
                        var next_facility = facility_copy;
                        next_facility.bringItemPair(&[2]Item{ item1, item2 }, from_floor_idx, to_floor_idx);
                        if (closed_set.contains(next_facility) or !next_facility.isSafe()) continue;
                        var tentative_g_score = g_scores.get(facility).? + 1;
                        if (!open_set.contains(next_facility)) {
                            open_set.putAssumeCapacity(next_facility, {});
                        } else if (tentative_g_score >= g_scores.get(next_facility) orelse std.math.maxInt(u32)) {
                            continue;
                        } else {
                            var open_min_heap_iter = open_min_heap.iterator();
                            while (open_min_heap_iter.next()) |remove_facility| {
                                if (std.meta.eql(remove_facility, next_facility)) break;
                            }
                            _ = open_min_heap.removeIndex(open_min_heap_iter.count - 1);
                        }
                        f_scores.putAssumeCapacity(next_facility, tentative_g_score + next_facility.estimateHeuristicCost());
                        g_scores.putAssumeCapacity(next_facility, tentative_g_score);
                        try open_min_heap.add(next_facility);
                    }
                }
            }
            _ = f_scores.remove(facility);
            _ = g_scores.remove(facility);
        }
        unreachable;
    };
}

test "Day 11" {
    const input = "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.\nThe second floor contains a hydrogen generator.\nThe third floor contains a lithium generator.\nThe fourth floor contains nothing relevant.";
    try std.testing.expect(11 == try findShortestPathLen(std.testing.allocator, input, 4, null));
}
