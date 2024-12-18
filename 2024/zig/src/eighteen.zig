const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: u8,
    y: u8,
};

fn rainBytes(blocked: *std.AutoHashMap(Point, void), num: u64, input: []const u8) !Point {
    var lines = std.mem.split(u8, input, "\n");

    for (0..num) |i| {
        const str = lines.next() orelse unreachable;
        var parts = std.mem.split(u8, str, ",");
        const first = parts.next() orelse unreachable;
        const x = try std.fmt.parseInt(u8, first, 10);
        const second = parts.next() orelse unreachable;
        const y = try std.fmt.parseInt(u8, second, 10);
        const p = Point{ .x = x, .y = y };
        try blocked.put(p, {});

        if (i == num - 1) {
            return p;
        }
    }

    return Point{ .x = 0, .y = 0 };
}

fn countMaxBytesToFall(input: []const u8) usize {
    var lines = std.mem.split(u8, input, "\n");
    var count: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        count += 1;
    }

    return count;
}

fn visit(p: Point, visited: *std.AutoHashMap(Point, usize), blocked: *std.AutoHashMap(Point, void), bestWay: *std.AutoHashMap(Point, void), pathLen: usize, min: *u64, size: comptime_int) !bool {
    if (p.x == size - 1 and p.y == size - 1) {
        if (min.* == 0 or pathLen < min.*) {
            min.* = pathLen;
            bestWay.clearAndFree();
            try bestWay.put(p, {});

            return true;
        }

        return false;
    }

    try visited.put(p, pathLen);

    const right: ?Point = if (p.x < size - 1) Point{ .x = p.x + 1, .y = p.y } else undefined;
    const left: ?Point = if (p.x > 0) Point{ .x = p.x - 1, .y = p.y } else undefined;
    const up: ?Point = if (p.y > 0) Point{ .x = p.x, .y = p.y - 1 } else undefined;
    const down: ?Point = if (p.y < size - 1) Point{ .x = p.x, .y = p.y + 1 } else undefined;

    var reachedEnd = false;

    if (right) |next| {
        const nextLen = visited.get(next) orelse 0;

        if ((nextLen == 0 or nextLen > pathLen + 1) and !blocked.contains(next)) {
            reachedEnd = try visit(next, visited, blocked, bestWay, pathLen + 1, min, size) or reachedEnd;
        }
    }

    if (left) |next| {
        const nextLen = visited.get(next) orelse 0;

        if ((nextLen == 0 or nextLen > pathLen + 1) and !blocked.contains(next)) {
            reachedEnd = try visit(next, visited, blocked, bestWay, pathLen + 1, min, size) or reachedEnd;
        }
    }

    if (up) |next| {
        const nextLen = visited.get(next) orelse 0;

        if ((nextLen == 0 or nextLen > pathLen + 1) and !blocked.contains(next)) {
            reachedEnd = try visit(next, visited, blocked, bestWay, pathLen + 1, min, size) or reachedEnd;
        }
    }

    if (down) |next| {
        const nextLen = visited.get(next) orelse 0;

        if ((nextLen == 0 or nextLen > pathLen + 1) and !blocked.contains(next)) {
            reachedEnd = try visit(next, visited, blocked, bestWay, pathLen + 1, min, size) or reachedEnd;
        }
    }

    if (reachedEnd) {
        try bestWay.put(p, {});
    }

    return reachedEnd;
}

fn runPartOne(input: []const u8, size: comptime_int, fallingBytes: comptime_int) !u64 {
    var blocked = std.AutoHashMap(Point, void).init(utils.allocator);
    defer blocked.deinit();
    var visited = std.AutoHashMap(Point, usize).init(utils.allocator);
    defer visited.deinit();
    var bestWay = std.AutoHashMap(Point, void).init(utils.allocator);
    defer bestWay.deinit();
    var min: u64 = 0;

    _ = try rainBytes(&blocked, fallingBytes, input);
    _ = try visit(Point{ .x = 0, .y = 0 }, &visited, &blocked, &bestWay, 0, &min, size);

    // for (0..size) |y| {
    //     for (0..size) |x| {
    //         const p = Point{ .x = @truncate(x), .y = @truncate(y) };
    //
    //         if (blocked.contains(p)) {
    //             std.debug.print("#", .{});
    //         } else if (bestWay.contains(p)) {
    //             std.debug.print("O", .{});
    //         } else {
    //             std.debug.print(".", .{});
    //         }
    //     }
    //
    //     std.debug.print("\n", .{});
    // }

    return min;
}

pub fn partOne(input: []const u8) !u64 {
    return runPartOne(input, 71, 1024);
}

fn runPartTwo(input: []const u8, size: comptime_int, fallingBytes: comptime_int) !u64 {
    var blocked = std.AutoHashMap(Point, void).init(utils.allocator);
    defer blocked.deinit();
    var visited = std.AutoHashMap(Point, usize).init(utils.allocator);
    defer visited.deinit();
    var bestWay = std.AutoHashMap(Point, void).init(utils.allocator);
    defer bestWay.deinit();
    var bytesToFall: u64 = fallingBytes + 1;
    var min: u64 = 0;

    const maxBytesToFall = countMaxBytesToFall(input);

    _ = try rainBytes(&blocked, fallingBytes, input);
    _ = try visit(Point{ .x = 0, .y = 0 }, &visited, &blocked, &bestWay, 0, &min, size);

    while (bytesToFall <= maxBytesToFall) {
        min = 0;

        var finalBytes = try rainBytes(&blocked, bytesToFall, input);

        while (!bestWay.contains(finalBytes)) {
            bytesToFall += 1;
            finalBytes = try rainBytes(&blocked, bytesToFall, input);
        }

        visited.clearAndFree();
        bestWay.clearAndFree();

        const foundWay = try visit(Point{ .x = 0, .y = 0 }, &visited, &blocked, &bestWay, 0, &min, size);

        if (!foundWay) {
            const left = if (finalBytes.y < 10) @as(u64, finalBytes.x) * 100 else @as(u64, finalBytes.x) * 1000;
            return left + finalBytes.y;
        }

        bytesToFall += 1;
    }

    return 0;
}

pub fn partTwo(input: []const u8) !u64 {
    return runPartTwo(input, 71, 1024);
}

const testInput =
    \\5,4
    \\4,2
    \\4,5
    \\3,0
    \\2,1
    \\6,3
    \\2,4
    \\1,5
    \\0,6
    \\3,3
    \\2,6
    \\5,1
    \\1,2
    \\5,5
    \\2,5
    \\6,5
    \\1,4
    \\0,4
    \\6,4
    \\1,1
    \\6,1
    \\1,0
    \\0,5
    \\1,6
    \\2,0
;

test "eighteen part one" {
    try std.testing.expectEqual(22, runPartOne(testInput, 7, 12));
}

test "eighteen part two" {
    try std.testing.expectEqual(601, runPartTwo(testInput, 7, 12));
}
