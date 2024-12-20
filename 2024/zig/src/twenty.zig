const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: u8,
    y: u8,
};

const Wall = '#';
const Empty = '.';
const Start = 'S';
const End = 'E';

const Tile = struct {
    type: u8 = Empty,
    elapsed: usize = 0,
};

fn Map(size: comptime_int) type {
    return [size][size]Tile;
}

fn parseMap(input: []const u8, size: comptime_int) Map(size) {
    var map = [_][size]Tile{[_]Tile{Tile{}} ** size} ** size;
    var lines = std.mem.split(u8, input, "\n");

    var row: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |col, c| {
            map[row][col].type = c;
        }

        row += 1;
    }

    return map;
}

fn findStart(size: comptime_int, map: *Map(size)) Point {
    for (0.., map) |y, row| {
        for (0.., row) |x, tile| {
            if (tile.type == Start) {
                return Point{ .x = @truncate(x), .y = @truncate(y) };
            }
        }
    }

    return Point{ .x = 0, .y = 0 };
}

fn runWithoutCheats(size: comptime_int, map: *Map(size)) void {
    var current = findStart(size, map);
    var elapsed: usize = 0;

    while (map[current.y][current.x].type != End) {
        const x = current.x;
        const y = current.y;

        if ((map[y - 1][x].type == Empty and map[y - 1][x].elapsed == 0) or map[y - 1][x].type == End) {
            current.y -= 1;
        } else if ((map[y + 1][x].type == Empty and map[y + 1][x].elapsed == 0) or map[y + 1][x].type == End) {
            current.y += 1;
        } else if ((map[y][x - 1].type == Empty and map[y][x - 1].elapsed == 0) or map[y][x - 1].type == End) {
            current.x -= 1;
        } else if ((map[y][x + 1].type == Empty and map[y][x + 1].elapsed == 0) or map[y][x + 1].type == End) {
            current.x += 1;
        }

        elapsed += 1;
        map[current.y][current.x].elapsed = elapsed;
    }
}

fn runPartOne(input: []const u8, size: comptime_int, threshold: comptime_int) !u64 {
    var map = parseMap(input, size);
    runWithoutCheats(size, &map);
    var cheatsOverThreshold: u64 = 0;

    for (0.., map) |y, row| {
        for (0.., row) |x, tile| {
            if (tile.type == Wall or tile.type == End) {
                continue;
            }

            if (y > 1 and (map[y - 2][x].type == Empty or map[y - 2][x].type == End) and map[y - 2][x].elapsed > tile.elapsed + 2) {
                const saved = map[y - 2][x].elapsed - tile.elapsed - 2;

                if (saved >= threshold) {
                    cheatsOverThreshold += 1;
                }
            }

            if (y < size - 2 and (map[y + 2][x].type == Empty or map[y + 2][x].type == End) and map[y + 2][x].elapsed > tile.elapsed + 2) {
                const saved = map[y + 2][x].elapsed - tile.elapsed - 2;

                if (saved >= threshold) {
                    cheatsOverThreshold += 1;
                }
            }

            if (x > 1 and (map[y][x - 2].type == Empty or map[y][x - 2].type == End) and map[y][x - 2].elapsed > tile.elapsed + 2) {
                const saved = map[y][x - 2].elapsed - tile.elapsed - 2;

                if (saved >= threshold) {
                    cheatsOverThreshold += 1;
                }
            }

            if (x < size - 2 and (map[y][x + 2].type == Empty or map[y][x + 2].type == End) and map[y][x + 2].elapsed > tile.elapsed + 2) {
                const saved = map[y][x + 2].elapsed - tile.elapsed - 2;

                if (saved >= threshold) {
                    cheatsOverThreshold += 1;
                }
            }
        }
    }

    return cheatsOverThreshold;
}

pub fn partOne(input: []const u8) !u64 {
    return runPartOne(input, 141, 100);
}

fn runPartTwo(input: []const u8, size: comptime_int, threshold: comptime_int) !u64 {
    var map = parseMap(input, size);
    runWithoutCheats(size, &map);
    var cheatsOverThreshold: u64 = 0;

    for (0.., map) |y, row| {
        for (0.., row) |x, tile| {
            if (tile.type == Wall or tile.type == End) {
                continue;
            }

            var minX: usize = 0;
            var maxX: usize = size - 1;
            var minY: usize = 0;
            var maxY: usize = size - 1;

            if (x > 20) {
                minX = x - 20;
            }
            if (size >= 21 and x < size - 21) {
                maxX = x + 20;
            }
            if (y > 20) {
                minY = y - 20;
            }
            if (size >= 21 and y < size - 21) {
                maxY = y + 20;
            }

            for (minY..maxY + 1) |y1| {
                for (minX..maxX + 1) |x1| {
                    const tile1 = map[y1][x1];
                    const distanceX = if (x1 >= x) x1 - x else x - x1;
                    const distanceY = if (y1 >= y) y1 - y else y - y1;
                    const distance = distanceX + distanceY;

                    if (tile1.type == Wall or distance == 0 or distance > 20 or tile1.elapsed < tile.elapsed + distance) {
                        continue;
                    }

                    const saved = tile1.elapsed - tile.elapsed - distance;

                    if (saved >= threshold) {
                        cheatsOverThreshold += 1;
                    }
                }
            }
        }
    }

    return cheatsOverThreshold;
}

pub fn partTwo(input: []const u8) !u64 {
    return runPartTwo(input, 141, 100);
}

const testInput =
    \\###############
    \\#...#...#.....#
    \\#.#.#.#.#.###.#
    \\#S#...#.#.#...#
    \\#######.#.#.###
    \\#######.#.#...#
    \\#######.#.###.#
    \\###..E#...#...#
    \\###.#######.###
    \\#...###...#...#
    \\#.#####.#.###.#
    \\#.#...#.#.#...#
    \\#.#.#.#.#.#.###
    \\#...#...#...###
    \\###############
;

test "twenty part one" {
    try std.testing.expectEqual(0, runPartOne(testInput, 15, 100));
    try std.testing.expectEqual(1, runPartOne(testInput, 15, 64));
    try std.testing.expectEqual(2, runPartOne(testInput, 15, 40));
    try std.testing.expectEqual(3, runPartOne(testInput, 15, 38));
    try std.testing.expectEqual(4, runPartOne(testInput, 15, 36));
    try std.testing.expectEqual(5, runPartOne(testInput, 15, 20));
    try std.testing.expectEqual(8, runPartOne(testInput, 15, 12));
    try std.testing.expectEqual(10, runPartOne(testInput, 15, 10));
    try std.testing.expectEqual(14, runPartOne(testInput, 15, 8));
    try std.testing.expectEqual(16, runPartOne(testInput, 15, 6));
    try std.testing.expectEqual(30, runPartOne(testInput, 15, 4));
    try std.testing.expectEqual(44, runPartOne(testInput, 15, 2));
}

test "twenty part two" {
    try std.testing.expectEqual(0, runPartTwo(testInput, 15, 100));
    try std.testing.expectEqual(3, runPartTwo(testInput, 15, 76));
    try std.testing.expectEqual(3 + 4, runPartTwo(testInput, 15, 74));
    try std.testing.expectEqual(3 + 4 + 22, runPartTwo(testInput, 15, 72));
    try std.testing.expectEqual(3 + 4 + 22 + 12, runPartTwo(testInput, 15, 70));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14, runPartTwo(testInput, 15, 68));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12, runPartTwo(testInput, 15, 66));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19, runPartTwo(testInput, 15, 64));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20, runPartTwo(testInput, 15, 62));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23, runPartTwo(testInput, 15, 60));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25, runPartTwo(testInput, 15, 58));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39, runPartTwo(testInput, 15, 56));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39 + 29, runPartTwo(testInput, 15, 54));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39 + 29 + 31, runPartTwo(testInput, 15, 52));
    try std.testing.expectEqual(3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39 + 29 + 31 + 32, runPartTwo(testInput, 15, 50));
}
