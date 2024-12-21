const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: u3,
    y: u3,

    pub fn diff(self: @This(), other: @This()) [2]u3 {
        const dx = if (other.x >= self.x) other.x - self.x + 3 else self.x - other.x;
        const dy = if (other.y > self.y) other.y - self.y else self.y - other.y + 4;

        return [_]u3{ dx, dy };
    }
};

fn makeDirpad() [4][3]u8 {
    return [_][3]u8{
        [_]u8{ ' ', '^', 'A' },
        [_]u8{ '<', 'v', '>' },
        [_]u8{ '.', '.', '.' },
        [_]u8{ '.', '.', '.' },
    };
}

fn makeNumpad() [4][3]u8 {
    return [_][3]u8{
        [_]u8{ '7', '8', '9' },
        [_]u8{ '4', '5', '6' },
        [_]u8{ '1', '2', '3' },
        [_]u8{ ' ', '0', 'A' },
    };
}

fn findPath(from: Point, to: Point, isNumpad: bool) ![]u8 {
    const diff = from.diff(to);
    const dx = if (diff[0] < 3) diff[0] else diff[0] - 3;
    const dxLeft = diff[0] < 3;
    const dy = if (diff[1] < 4) diff[1] else diff[1] - 4;
    const dyUp = diff[1] >= 4;
    var onGap = false;

    if (isNumpad) {
        onGap = (from.y == 3 and to.x == 0) or (from.x == 0 and to.y == 3);
    } else {
        onGap = (from.x == 0 and to.y == 0) or (from.y == 0 and to.x == 0);
    }

    var hMove: u8 = 'A';
    var vMove: u8 = 'A';

    if (dxLeft) {
        hMove = '<';
    } else {
        hMove = '>';
    }
    if (dyUp) {
        vMove = '^';
    } else {
        vMove = 'v';
    }

    var path = try utils.allocator.alloc(u8, dx + dy + 1);

    if (dxLeft != onGap) {
        for (0..dx) |i| {
            path[i] = hMove;
        }

        for (0..dy) |i| {
            path[i + dx] = vMove;
        }
    } else {
        for (0..dy) |i| {
            path[i] = vMove;
        }

        for (0..dx) |i| {
            path[i + dy] = hMove;
        }
    }

    path[dx + dy] = 'A';

    return path;
}

const Depths = [26]u64;

fn countFinalDirpadMoves(path: []u8, depth: u5, dirpadPoints: *std.AutoHashMap(u8, Point), cache: *std.StringHashMap(Depths), allocatedStrings: *std.ArrayList([]u8)) !u64 {
    if (cache.get(path)) |c| {
        if (c[depth] > 0) {
            return c[depth];
        }
    } else {
        const depths = [_]u64{0} ** 26;
        try cache.put(path, depths);
    }

    if (depth == 0) {
        return path.len;
    }

    var count: u64 = 0;
    var newPath = std.ArrayList([]u8).init(utils.allocator);
    defer newPath.deinit();

    var current = Point{ .x = 2, .y = 0 };

    for (path) |c| {
        const goal = dirpadPoints.get(c) orelse unreachable;
        const p = try findPath(current, goal, false);
        try newPath.append(p);
        try allocatedStrings.append(p);
        current = goal;
    }

    for (newPath.items) |p| {
        count += try countFinalDirpadMoves(p, depth - 1, dirpadPoints, cache, allocatedStrings);
    }

    var c = cache.getPtr(path) orelse unreachable;
    c[depth] = count;

    return count;
}

fn runPart(input: []const u8, depth: u5) !u64 {
    const numpad = makeNumpad();
    const dirpad = makeDirpad();
    var numpadPoints = std.AutoHashMap(u8, Point).init(utils.allocator);
    defer numpadPoints.deinit();
    var dirpadPoints = std.AutoHashMap(u8, Point).init(utils.allocator);
    defer dirpadPoints.deinit();
    var cache = std.StringHashMap(Depths).init(utils.allocator);
    defer cache.deinit();
    var allocatedStrings = std.ArrayList([]u8).init(utils.allocator);
    defer {
        for (allocatedStrings.items) |item| {
            utils.allocator.free(item);
        }

        allocatedStrings.deinit();
    }
    var lines = std.mem.split(u8, input, "\n");
    var result: u64 = 0;

    for (0.., numpad) |y, row| {
        for (0.., row) |x, c| {
            try numpadPoints.put(c, Point{ .x = @truncate(x), .y = @truncate(y) });
        }
    }

    for (0..2) |y| {
        for (0.., dirpad[y]) |x, c| {
            try dirpadPoints.put(c, Point{ .x = @truncate(x), .y = @truncate(y) });
        }
    }

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var path = std.ArrayList([]u8).init(utils.allocator);
        defer path.deinit();
        const numericVal = try std.fmt.parseInt(u64, line[0 .. line.len - 1], 10);

        var current = Point{ .x = 2, .y = 3 };

        for (line) |goalNum| {
            const goal = numpadPoints.get(goalNum) orelse unreachable;
            const p = try findPath(current, goal, true);
            try allocatedStrings.append(p);
            try path.append(p);
            current = goal;
        }

        var ownMoves: u64 = 0;

        for (path.items) |p| {
            ownMoves += try countFinalDirpadMoves(p, depth, &dirpadPoints, &cache, &allocatedStrings);
        }

        result += ownMoves * numericVal;
    }

    return result;
}

pub fn partOne(input: []const u8) !u64 {
    return runPart(input, 2);
}

pub fn partTwo(input: []const u8) !u64 {
    return runPart(input, 25);
}

const testInput =
    \\029A
    \\980A
    \\179A
    \\456A
    \\379A
;

test "twentyone part one" {
    try std.testing.expectEqual(126384, partOne(testInput));
}

test "twentyone part two" {
    try std.testing.expectEqual(154115708116294, partTwo(testInput));
}
