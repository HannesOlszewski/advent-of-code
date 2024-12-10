const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: usize,
    y: usize,
};

fn hike(start: Point, map: *[56][56]u8, reachedEnds: *std.AutoHashMap(Point, usize)) !void {
    const current = map[start.y][start.x];
    const ways = [4][2]u2{ .{ 1, 0 }, .{ 1, 2 }, .{ 0, 1 }, .{ 2, 1 } };

    for (ways) |way| {
        const dx = way[0];
        const dy = way[1];

        if ((start.x == 0 and dx == 0) or (start.y == 0 and dy == 0)) {
            continue;
        }

        const x = start.x + dx - 1;
        const y = start.y + dy - 1;

        if (x >= map.len or y >= map.len) {
            continue;
        }

        const next = map[y][x];

        if (current >= next or next - current != 1) {
            continue;
        }

        const nextPoint = Point{ .x = x, .y = y };

        if (next == '9') {
            if (!reachedEnds.contains(nextPoint)) {
                try reachedEnds.put(nextPoint, 0);
            }

            const reached = reachedEnds.get(nextPoint);

            if (reached) |v| {
                try reachedEnds.put(nextPoint, v + 1);
            }
        } else {
            try hike(nextPoint, map, reachedEnds);
        }
    }
}

pub fn partOne(input: []const u8) !u64 {
    var sum: u64 = 0;
    var map = [_][56]u8{[_]u8{'.'} ** 56} ** 56;
    var trailheads = std.ArrayList(Point).init(utils.allocator);
    defer trailheads.deinit();
    var lines = std.mem.split(u8, input, "\n");

    var y: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |x, c| {
            map[y][x] = c;

            if (c == '0') {
                try trailheads.append(Point{ .x = x, .y = y });
            }
        }

        y += 1;
    }

    for (trailheads.items) |trailhead| {
        var reachedEnds = std.AutoHashMap(Point, usize).init(utils.allocator);
        defer reachedEnds.deinit();

        try hike(trailhead, &map, &reachedEnds);

        var keys = reachedEnds.keyIterator();

        while (keys.next()) |_| {
            sum += 1;
        }
    }

    return sum;
}

pub fn partTwo(input: []const u8) !u64 {
    var sum: u64 = 0;
    var map = [_][56]u8{[_]u8{'.'} ** 56} ** 56;
    var trailheads = std.ArrayList(Point).init(utils.allocator);
    defer trailheads.deinit();
    var lines = std.mem.split(u8, input, "\n");

    var y: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |x, c| {
            map[y][x] = c;

            if (c == '0') {
                try trailheads.append(Point{ .x = x, .y = y });
            }
        }

        y += 1;
    }

    for (trailheads.items) |trailhead| {
        var reachedEnds = std.AutoHashMap(Point, usize).init(utils.allocator);
        defer reachedEnds.deinit();

        try hike(trailhead, &map, &reachedEnds);

        var values = reachedEnds.valueIterator();

        while (values.next()) |value| {
            sum += value.*;
        }
    }

    return sum;
}

const testInput =
    \\89010123
    \\78121874
    \\87430965
    \\96549874
    \\45678903
    \\32019012
    \\01329801
    \\10456732
;

test "ten part one" {
    const expected = 36;
    const actual = partOne(testInput);
    try std.testing.expectEqual(expected, actual);
}

test "ten part two" {
    const expected = 81;
    const actual = partTwo(testInput);
    try std.testing.expectEqual(expected, actual);
}
