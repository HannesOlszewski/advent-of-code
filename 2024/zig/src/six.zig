const std = @import("std");
const utils = @import("utils.zig");

const TileState = struct {
    empty: bool = false,
    blocked: bool = false,
    visited: bool = false,
    visitedUp: bool = false,
    visitedDown: bool = false,
    visitedLeft: bool = false,
    visitedRight: bool = false,
    obstructable: bool = false,
};

const Point = struct {
    row: usize,
    col: usize,
};

const Direction = enum {
    up,
    right,
    down,
    left,

    pub fn next(self: Direction) Direction {
        return @enumFromInt(@intFromEnum(self) +% 1);
    }

    pub fn prev(self: Direction) Direction {
        return @enumFromInt(@intFromEnum(self) -% 1);
    }

    pub fn reverse(self: Direction) Direction {
        return switch (self) {
            .up => .down,
            .right => .left,
            .down => .up,
            .left => .right,
        };
    }
};

fn move(loc: Point, dir: Direction) Point {
    return switch (dir) {
        .up => Point{ .row = loc.row - 1, .col = loc.col },
        .down => Point{ .row = loc.row + 1, .col = loc.col },
        .left => Point{ .row = loc.row, .col = loc.col - 1 },
        .right => Point{ .row = loc.row, .col = loc.col + 1 },
    };
}

fn isOnMap(loc: Point) bool {
    return loc.row >= 0 and loc.col >= 0 and loc.row < size and loc.col < size;
}

const size: usize = 130; // full input

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var map = [_][size]TileState{[_]TileState{TileState{}} ** size} ** size;
    var loc = Point{ .row = 0, .col = 0 };
    var dir = Direction.up;
    var row: usize = 0;
    var visitedTiles: u64 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            row += 1;

            continue;
        }

        for (0.., line) |col, c| {
            if (c == '#') {
                map[row][col].blocked = true;
                continue;
            }

            map[row][col].empty = true;

            if (c == '^') {
                loc.row = row;
                loc.col = col;
            }
        }

        row += 1;
    }

    while (true) {
        if (map[loc.row][loc.col].empty and !map[loc.row][loc.col].visited) {
            map[loc.row][loc.col].visited = true;
            visitedTiles += 1;
        }

        const next = move(loc, dir);

        if (!isOnMap(next)) {
            break;
        }

        if (map[next.row][next.col].blocked) {
            dir = dir.next();
        } else {
            loc = next;
        }
    }

    return visitedTiles;
}

test "six part one" {
    const input =
        \\....#.....
        \\.........#
        \\..........
        \\..#.......
        \\.......#..
        \\..........
        \\.#..^.....
        \\........#.
        \\#.........
        \\......#...
    ;

    const expected = 41;
    const actual = partOne(input);

    try std.testing.expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var map = [_][size]TileState{[_]TileState{TileState{}} ** size} ** size;
    var loc = Point{ .row = 0, .col = 0 };
    var guardPost = Point{ .row = 0, .col = 0 };
    var dir = Direction.up;
    var row: usize = 0;
    var placableObstacles: u64 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            row += 1;

            continue;
        }

        for (0.., line) |col, c| {
            if (c == '#') {
                map[row][col].blocked = true;
                continue;
            }

            map[row][col].empty = true;

            if (c == '^') {
                loc.row = row;
                loc.col = col;
                guardPost.row = row;
                guardPost.col = col;
            }
        }

        row += 1;
    }

    while (true) {
        if (map[loc.row][loc.col].empty) {
            map[loc.row][loc.col].visited = true;

            switch (dir) {
                .up => map[loc.row][loc.col].visitedUp = true,
                .down => map[loc.row][loc.col].visitedDown = true,
                .left => map[loc.row][loc.col].visitedLeft = true,
                .right => map[loc.row][loc.col].visitedRight = true,
            }
        }

        const next = move(loc, dir);

        if (!isOnMap(next)) {
            break;
        }

        if (map[next.row][next.col].blocked) {
            dir = dir.next();
            continue;
        }

        const obstacle = next;

        if ((obstacle.row == guardPost.row and obstacle.col == guardPost.col) or map[obstacle.row][obstacle.col].visited or map[obstacle.row][obstacle.col].obstructable) {
            loc = next;
            continue;
        }

        var loopDir = dir.next();
        var loopNext = Point{ .row = loc.row, .col = loc.col };
        var loopMap = [_][size]TileState{[_]TileState{TileState{}} ** size} ** size;
        var loopSteps: usize = 0;
        switch (loopDir) {
            .up => loopMap[loopNext.row][loopNext.col].visitedUp = true,
            .down => loopMap[loopNext.row][loopNext.col].visitedDown = true,
            .left => loopMap[loopNext.row][loopNext.col].visitedLeft = true,
            .right => loopMap[loopNext.row][loopNext.col].visitedRight = true,
        }

        while (isOnMap(loopNext)) {
            if (map[loopNext.row][loopNext.col].blocked or (loopNext.row == obstacle.row and loopNext.col == obstacle.col)) {
                loopNext = move(loopNext, loopDir.reverse());
                loopDir = loopDir.next();
                continue;
            }

            const isVisitedInLoopDir = switch (loopDir) {
                .up => map[loopNext.row][loopNext.col].visitedUp or loopMap[loopNext.row][loopNext.col].visitedUp,
                .down => map[loopNext.row][loopNext.col].visitedDown or loopMap[loopNext.row][loopNext.col].visitedDown,
                .left => map[loopNext.row][loopNext.col].visitedLeft or loopMap[loopNext.row][loopNext.col].visitedLeft,
                .right => map[loopNext.row][loopNext.col].visitedRight or loopMap[loopNext.row][loopNext.col].visitedRight,
            };

            if (loopSteps > 0 and isVisitedInLoopDir) {
                map[obstacle.row][obstacle.col].obstructable = true;
                placableObstacles += 1;
                break;
            }

            switch (loopDir) {
                .up => loopMap[loopNext.row][loopNext.col].visitedUp = true,
                .down => loopMap[loopNext.row][loopNext.col].visitedDown = true,
                .left => loopMap[loopNext.row][loopNext.col].visitedLeft = true,
                .right => loopMap[loopNext.row][loopNext.col].visitedRight = true,
            }

            if ((loopNext.row == 0 and loopDir == .up) or (loopNext.col == 0 and loopDir == .left)) {
                break;
            }

            loopNext = move(loopNext, loopDir);
            loopSteps += 1;
        }

        loc = next;
    }

    return placableObstacles;
}

test "six part two" {
    const input =
        \\....#........
        \\.........#...
        \\.............
        \\..#..........
        \\.......#.....
        \\.............
        \\.#..^........
        \\........#....
        \\#............
        \\......#......
        \\.............
        \\#............
        \\.............
    ;

    const expected = 7;
    const actual = partTwo(input);

    try std.testing.expectEqual(expected, actual);
}
