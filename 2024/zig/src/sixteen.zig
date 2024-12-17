const std = @import("std");
const utils = @import("utils.zig");

const Direction = enum {
    north,
    east,
    south,
    west,

    fn right(this: @This()) Direction {
        return switch (this) {
            .north => .east,
            .east => .south,
            .south => .west,
            .west => .north,
        };
    }

    fn left(this: @This()) Direction {
        return switch (this) {
            .north => .west,
            .west => .south,
            .south => .east,
            .east => .north,
        };
    }
};

const Point = struct {
    x: usize,
    y: usize,
};

const Location = struct {
    dir: Direction = .east,
    prev: Direction = .east,
    loc: Point,
    cost: usize = 0,

    fn moveForward(this: @This()) Location {
        var next = this;

        next.prev = this.dir;
        next.cost += 1;

        switch (next.dir) {
            .north => next.loc.y -= 1,
            .east => next.loc.x += 1,
            .south => next.loc.y += 1,
            .west => next.loc.x -= 1,
        }

        return next;
    }

    fn lookForward(this: @This()) Point {
        return switch (this.dir) {
            .north => Point{ .x = this.loc.x, .y = this.loc.y - 1 },
            .east => Point{ .x = this.loc.x + 1, .y = this.loc.y },
            .south => Point{ .x = this.loc.x, .y = this.loc.y + 1 },
            .west => Point{ .x = this.loc.x - 1, .y = this.loc.y },
        };
    }

    fn rotateRight(this: @This()) Location {
        var next = this;

        next.prev = this.dir;
        next.cost += 1000;
        next.dir = this.dir.right();

        return next;
    }

    fn lookRight(this: @This()) Point {
        return switch (this.dir) {
            .north => Point{ .x = this.loc.x + 1, .y = this.loc.y },
            .east => Point{ .x = this.loc.x, .y = this.loc.y + 1 },
            .south => Point{ .x = this.loc.x - 1, .y = this.loc.y },
            .west => Point{ .x = this.loc.x, .y = this.loc.y - 1 },
        };
    }

    fn rotateLeft(this: @This()) Location {
        var next = this;

        next.prev = this.dir;
        next.cost += 1000;
        next.dir = this.dir.left();

        return next;
    }

    fn lookLeft(this: @This()) Point {
        return switch (this.dir) {
            .north => Point{ .x = this.loc.x - 1, .y = this.loc.y },
            .east => Point{ .x = this.loc.x, .y = this.loc.y - 1 },
            .south => Point{ .x = this.loc.x + 1, .y = this.loc.y },
            .west => Point{ .x = this.loc.x, .y = this.loc.y + 1 },
        };
    }

    fn hasRotated(this: @This()) bool {
        return this.prev != this.dir;
    }

    fn reverse(this: @This()) void {
        if (this.dir == this.prev) {
            this.cost -= 1;

            switch (this.dir) {
                .north => this.loc.y += 1,
                .east => this.loc.x -= 1,
                .south => this.loc.y -= 1,
                .west => this.loc.x += 1,
            }
        } else {
            this.cost -= 1000;
            this.dir = this.prev;
        }
    }

    fn eql(this: @This(), other: @This()) bool {
        return this.dir == other.dir and this.prev == other.prev and this.loc.x == other.loc.x and this.loc.y == other.loc.y and this.cost == other.cost;
    }
};

const Tile = enum(u8) {
    wall = '#',
    empty = '.',
    start = 'S',
    end = 'E',
    none = ' ',
};

fn parseMap(input: []const u8, size: comptime_int, start: *Point, end: *Point) [size][size]Tile {
    var map = [_][size]Tile{[_]Tile{.none} ** size} ** size;
    var lines = std.mem.split(u8, input, "\n");

    var row: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |col, c| {
            map[row][col] = @enumFromInt(c);

            if (c == 'S') {
                start.* = Point{ .x = col, .y = row };
            }

            if (c == 'E') {
                end.* = Point{ .x = col, .y = row };
            }
        }

        row += 1;
    }

    return map;
}

fn findWay(current: Location, trail: *std.AutoHashMap(Point, usize), seats: *std.AutoHashMap(Point, usize), min: *u64, mapSize: comptime_int, map: [mapSize][mapSize]Tile) !u64 {
    if ((min.* > 0 and current.cost > min.*)) {
        return 0;
    }

    var reachedEnd: u64 = 0;
    const forward = current.lookForward();
    const left = current.lookLeft();
    const right = current.lookRight();
    std.debug.assert(map[current.loc.y][current.loc.x] != .end);
    std.debug.assert(map[current.loc.y][current.loc.x] != .wall);
    std.debug.assert(map[current.loc.y][current.loc.x] != .none);

    if (map[forward.y][forward.x] != .wall) {
        const next = current.moveForward();
        std.debug.assert(!current.eql(next));

        if (map[next.loc.y][next.loc.x] == .end and (min.* == 0 or next.cost <= min.*)) {
            min.* = next.cost;
            return next.cost;
        } else if ((min.* == 0 or next.cost <= min.*)) {
            const val = trail.get(next.loc) orelse 0;
            var valAfterVal: usize = 0;
            var nextNextCost: usize = 0;
            const forwardForward = next.lookForward();
            if (map[forwardForward.y][forwardForward.x] != .wall) {
                const nextNext = next.moveForward();
                valAfterVal = trail.get(nextNext.loc) orelse 0;
                nextNextCost = nextNext.cost;
            }
            if (val == 0 or val >= next.cost or valAfterVal >= nextNextCost) {
                try trail.put(next.loc, next.cost);
                const res = try findWay(next, trail, seats, min, mapSize, map);

                if (res > 0) {
                    const val2 = seats.get(next.loc) orelse res;
                    const minSeat = if (res <= val2) res else val2;
                    try seats.put(next.loc, minSeat);

                    if (reachedEnd == 0 or res < reachedEnd) {
                        reachedEnd = res;
                    }
                }
            }
        }
    }

    if (map[left.y][left.x] != .wall and !current.hasRotated()) {
        const next = current.rotateLeft();
        std.debug.assert(!current.eql(next));
        const res = try findWay(next, trail, seats, min, mapSize, map);

        if (res > 0) {
            const val2 = seats.get(next.loc) orelse res;
            const minSeat = if (res <= val2) res else val2;
            try seats.put(next.loc, minSeat);

            if (reachedEnd == 0 or res < reachedEnd) {
                reachedEnd = res;
            }
        }
    }

    if (map[right.y][right.x] != .wall and !current.hasRotated()) {
        const next = current.rotateRight();
        std.debug.assert(!current.eql(next));
        const res = try findWay(next, trail, seats, min, mapSize, map);

        if (res > 0) {
            const val2 = seats.get(next.loc) orelse res;
            const minSeat = if (res <= val2) res else val2;
            try seats.put(next.loc, minSeat);

            if (reachedEnd == 0 or res < reachedEnd) {
                reachedEnd = res;
            }
        }
    }

    return reachedEnd;
}

fn printTrail(trail: std.AutoHashMap(Point, usize), mapSize: comptime_int, map: [mapSize][mapSize]Tile) void {
    for (0.., map) |y, row| {
        for (0.., row) |x, tile| {
            switch (tile) {
                .start, .end, .wall => std.debug.print("{c}", .{@intFromEnum(tile)}),
                .empty => {
                    var visited = false;

                    if (trail.contains(Point{ .x = x, .y = y })) {
                        visited = true;
                    }

                    if (visited) {
                        std.debug.print("x", .{});
                    } else {
                        std.debug.print(".", .{});
                    }
                },
                else => {},
            }
        }

        std.debug.print("\n", .{});
    }
}

fn runPartOne(input: []const u8, size: comptime_int) !u64 {
    var start: Point = undefined;
    var end: Point = undefined;
    var min: u64 = 0;
    const map = parseMap(input, size, &start, &end);
    const location = Location{ .loc = start };
    var trail = std.AutoHashMap(Point, usize).init(utils.allocator);
    defer trail.deinit();
    var seats = std.AutoHashMap(Point, usize).init(utils.allocator);
    defer seats.deinit();

    _ = try findWay(location, &trail, &seats, &min, size, map);
    // printTrail(trail, size, map);
    // utils.debug("", .{});

    return min;
}

pub fn partOne(input: []const u8) !u64 {
    return runPartOne(input, 141);
}

fn printSeats(seats: std.AutoHashMap(Point, usize), mapSize: comptime_int, map: [mapSize][mapSize]Tile, min: usize) void {
    for (0.., map) |y, row| {
        for (0.., row) |x, tile| {
            switch (tile) {
                .wall => std.debug.print("#", .{}),
                .empty => {
                    if (seats.get(Point{ .x = x, .y = y })) |val| {
                        if (val == min) {
                            std.debug.print("O", .{});
                        } else {
                            std.debug.print(".", .{});
                        }
                    } else {
                        std.debug.print(".", .{});
                    }
                },
                .start, .end => std.debug.print("O", .{}),
                else => {},
            }
        }

        std.debug.print("\n", .{});
    }
}

fn runPartTwo(input: []const u8, size: comptime_int) !u64 {
    var start: Point = undefined;
    var end: Point = undefined;
    var min: u64 = 0;
    const map = parseMap(input, size, &start, &end);
    const location = Location{ .loc = start };
    var trail = std.AutoHashMap(Point, usize).init(utils.allocator);
    defer trail.deinit();
    var seats = std.AutoHashMap(Point, usize).init(utils.allocator);
    defer seats.deinit();

    _ = try findWay(location, &trail, &seats, &min, size, map);
    // printSeats(seats, size, map, min);
    // utils.debug("", .{});

    var numSeats: u64 = 0;

    for (0.., map) |y, row| {
        for (0.., row) |x, tile| {
            switch (tile) {
                .empty => {
                    if (seats.get(Point{ .x = x, .y = y })) |val| {
                        if (val == min) {
                            numSeats += 1;
                        }
                    }
                },
                .start, .end => numSeats += 1,
                else => {},
            }
        }
    }

    return numSeats;
}

pub fn partTwo(input: []const u8) !u64 {
    return runPartTwo(input, 141);
}

const testInput1 =
    \\###############
    \\#.......#....E#
    \\#.#.###.#.###.#
    \\#.....#.#...#.#
    \\#.###.#####.#.#
    \\#.#.#.......#.#
    \\#.#.#####.###.#
    \\#...........#.#
    \\###.#.#####.#.#
    \\#...#.....#.#.#
    \\#.#.#.###.#.#.#
    \\#.....#...#.#.#
    \\#.###.#.#.#.#.#
    \\#S..#.....#...#
    \\###############
;

const testInput2 =
    \\#################
    \\#...#...#...#..E#
    \\#.#.#.#.#.#.#.#.#
    \\#.#.#.#...#...#.#
    \\#.#.#.#.###.#.#.#
    \\#...#.#.#.....#.#
    \\#.#.#.#.#.#####.#
    \\#.#...#.#.#.....#
    \\#.#.#####.#.###.#
    \\#.#.#.......#...#
    \\#.#.###.#####.###
    \\#.#.#...#.....#.#
    \\#.#.#.#####.###.#
    \\#.#.#.........#.#
    \\#.#.#.#########.#
    \\#S#.............#
    \\#################
;

test "sixteen part one" {
    try std.testing.expectEqual(7036, runPartOne(testInput1, 15));
    try std.testing.expectEqual(11048, runPartOne(testInput2, 17));
}

test "sixteen part two" {
    try std.testing.expectEqual(45, runPartTwo(testInput1, 15));
    try std.testing.expectEqual(64, runPartTwo(testInput2, 17));
}
