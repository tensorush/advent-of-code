const std = @import("std");

const ElfList = std.SinglyLinkedList(u32);

pub fn solve() std.mem.Allocator.Error!void {
    std.debug.print("--- Day 19: An Elephant Named Joseph ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{try findWinner(std.heap.page_allocator, 3_017_957, false)});
    std.debug.print("Part 2: {d}\n", .{try findWinner(std.heap.page_allocator, 3_017_957, true)});
}

fn findWinner(allocator: std.mem.Allocator, num_elves: u32, is_part2: bool) std.mem.Allocator.Error!u32 {
    var elf: *ElfList.Node = undefined;
    var elf_position = num_elves - 1;
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();
    var last_elf = try arena_allocator.create(ElfList.Node);
    var elves = ElfList{};
    elves.prepend(last_elf);
    while (elf_position > 0) : (elf_position -= 1) {
        elf = try arena_allocator.create(ElfList.Node);
        elf.* = .{ .data = elf_position };
        elves.prepend(elf);
    }
    last_elf.*.next = elves.first;
    elf = elves.first.?;
    if (is_part2) {
        var opposite_elf_idx = num_elves / 2 - 1;
        var elf_idx: usize = 0;
        while (elf_idx < opposite_elf_idx) : (elf_idx += 1) {
            elf = elf.next.?;
        }
    }
    elf_position = num_elves;
    var winner = elves.first.?;
    while (elf_position > 2) : (elf_position -= 1) {
        _ = elf.removeNext();
        if (!is_part2 or elf_position % 2 == 1) elf = elf.next.?;
        winner = winner.next.?;
    }
    return winner.data;
}

test "Day 19" {
    try std.testing.expect(3 == try findWinner(std.testing.allocator, 5, false));
    try std.testing.expect(2 == try findWinner(std.testing.allocator, 5, true));
}
