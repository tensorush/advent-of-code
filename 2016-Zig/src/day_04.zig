const std = @import("std");

const MAX_NAME_LEN: u8 = 1 << 7;

const RoomArray = std.BoundedArray(Room, 1 << 10);

pub fn main() std.fmt.ParseIntError!void {
    const input = @embedFile("inputs/day_04.txt");
    const real_rooms = try parseAndFindRealRooms(input);
    std.debug.print("--- Day 4: Security Through Obscurity ---\n", .{});
    std.debug.print("Part 1: {d}\n", .{findSectorIdSum(real_rooms)});
    std.debug.print("Part 2: {d}\n", .{findNorthPoleRoomSectorId(real_rooms)});
}

const Room = struct {
    checksum: []const u8,
    name: []const u8,
    sector_id: u16,

    fn isReal(self: Room) bool {
        var letter_counts = [1]u16{0} ** 26;
        for (self.name) |char| {
            if (char != '-') letter_counts[@as(usize, char - 'a')] += 1;
        }
        var letters: [26]u8 = "abcdefghijklmnopqrstuvwxyz".*;
        std.sort.sort(u8, letters[0..], letter_counts, letterLessThan);
        return std.mem.eql(u8, letters[0..5], self.checksum);
    }

    fn letterLessThan(letter_counts: [26]u16, lhs: u8, rhs: u8) bool {
        return letter_counts[lhs - 'a'] > letter_counts[rhs - 'a'];
    }

    fn decryptRoom(self: Room, real_name: []u8) []u8 {
        for (self.name) |char, i| {
            real_name[i] = if (char == '-') ' ' else @intCast(u8, (@as(u16, char) - 'a' + self.sector_id) % 26 + 'a');
        }
        return real_name[0..self.name.len];
    }
};

fn parseAndFindRealRooms(input: []const u8) std.fmt.ParseIntError!RoomArray {
    var str_room_iter = std.mem.tokenize(u8, input, "\n");
    var checksum_start_idx: usize = undefined;
    var real_rooms = try RoomArray.init(0);
    var room: Room = undefined;
    while (str_room_iter.next()) |str_room| {
        checksum_start_idx = std.mem.indexOfScalar(u8, str_room, '[').?;
        room = .{
            .checksum = str_room[checksum_start_idx + 1 .. checksum_start_idx + 6],
            .name = str_room[0 .. checksum_start_idx - 4],
            .sector_id = try std.fmt.parseUnsigned(u16, str_room[checksum_start_idx - 3 .. checksum_start_idx], 10),
        };
        if (room.isReal()) real_rooms.appendAssumeCapacity(room);
    }
    return real_rooms;
}

fn findSectorIdSum(real_rooms: RoomArray) u32 {
    var sector_id_sum: u32 = 0;
    for (real_rooms.constSlice()) |real_room| {
        sector_id_sum += @as(u32, real_room.sector_id);
    }
    return sector_id_sum;
}

fn findNorthPoleRoomSectorId(rooms: RoomArray) u16 {
    return blk: {
        for (rooms.constSlice()) |room| {
            var real_name_buf: [MAX_NAME_LEN]u8 = undefined;
            const real_name = room.decryptRoom(real_name_buf[0..]);
            if (std.mem.containsAtLeast(u8, real_name, 1, "north") and std.mem.containsAtLeast(u8, real_name, 1, "pole")) break :blk room.sector_id;
        }
        unreachable;
    };
}

test "Day 4" {
    const input = "aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]";
    var real_rooms = try parseAndFindRealRooms(input);
    try std.testing.expect(1514 == findSectorIdSum(real_rooms));
    var real_name_buf: [MAX_NAME_LEN]u8 = undefined;
    real_rooms = try parseAndFindRealRooms("qzmt-zixmtkozy-ivhz-343[zimth]");
    try std.testing.expectEqualStrings("very encrypted name", real_rooms.pop().decryptRoom(real_name_buf[0..]));
}
