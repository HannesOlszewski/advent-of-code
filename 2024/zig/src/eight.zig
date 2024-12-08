const std = @import("std");
const utils = @import("utils.zig");

const Tile = struct {
    freq: u8 = '.',
    antinode: bool = false,
};

const Key = struct {
    x1: usize,
    x2: usize,
    y1: usize,
    y2: usize,
};

pub fn partOne(input: []const u8) !u64 {
    var map = [_][50]Tile{[_]Tile{Tile{}} ** 50} ** 50;
    var lineLen: usize = 0;
    var lines = std.mem.split(u8, input, "\n");
    var occurrences = [_]u8{0} ** 128;
    var checked = std.AutoHashMap(Key, void).init(utils.allocator);
    defer checked.deinit();

    if (lines.peek()) |line| {
        lineLen = line.len;
    } else {
        return 0;
    }

    var row: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |col, c| {
            if (c != '.') {
                map[row][col].freq = c;

                if (c < 128) {
                    occurrences[c] += 1;
                }
            }
        }

        row += 1;
    }

    var antinodes: u64 = 0;

    for (0.., map) |y, mapRow| {
        for (0.., mapRow) |x, tile| {
            const c = tile.freq;
            if (c >= 128 or occurrences[c] <= 1) {
                continue;
            }

            for (0.., map) |y1, mapRow1| {
                for (0.., mapRow1) |x1, tile1| {
                    if (tile1.freq != c or (x1 == x and y1 == y)) {
                        continue;
                    }

                    const key1 = Key{ .x1 = x, .x2 = x1, .y1 = y, .y2 = y1 };
                    const key2 = Key{ .x1 = x1, .x2 = x, .y1 = y1, .y2 = y };

                    if (checked.contains(key1) or checked.contains(key2)) {
                        continue;
                    }

                    try checked.put(key1, {});
                    try checked.put(key2, {});

                    const dx = if (x >= x1) x - x1 else x1 - x;
                    const dxPos = x > x1;
                    const dy = if (y >= y1) y - y1 else y1 - y;
                    const dyPos = y > y1;

                    var x2 = x;
                    var y2 = y;
                    var x3 = x;
                    var y3 = y;

                    if (dxPos and dyPos) {
                        if (dx <= x1 and dy <= y1) {
                            x2 = x1 - dx;
                            y2 = y1 - dy;
                        }

                        if ((dx + x) < lineLen and (dy + y) < lineLen) {
                            x3 = x + dx;
                            y3 = y + dy;
                        }
                    } else if (dxPos and !dyPos) {
                        if (dx <= x1 and (dy + y1) < lineLen) {
                            x2 = x1 - dx;
                            y2 = y1 + dy;
                        }

                        if ((dx + x) < lineLen and dy <= y) {
                            x3 = x + dx;
                            y3 = y - dy;
                        }
                    } else if (!dxPos and dyPos) {
                        if ((dx + x1) < lineLen and dy <= y1) {
                            x2 = x1 + dx;
                            y2 = y1 - dy;
                        }

                        if (dx <= x and (dy + y) < lineLen) {
                            x3 = x - dx;
                            y3 = y + dy;
                        }
                    } else {
                        if ((dx + x1) < lineLen and (dy + y1) < lineLen) {
                            x2 = x1 + dx;
                            y2 = y1 + dy;
                        }

                        if (dx <= x and dy <= y) {
                            x3 = x - dx;
                            y3 = y - dy;
                        }
                    }

                    if (x2 != x and y2 != y) {
                        if (!map[y2][x2].antinode) {
                            antinodes += 1;
                        }

                        map[y2][x2].antinode = true;
                    }

                    if (x3 != x and y3 != y) {
                        if (!map[y3][x3].antinode) {
                            antinodes += 1;
                        }

                        map[y3][x3].antinode = true;
                    }
                }
            }
        }
    }

    return antinodes;
}

pub fn partTwo(input: []const u8) !u64 {
    var map = [_][50]Tile{[_]Tile{Tile{}} ** 50} ** 50;
    var lineLen: usize = 0;
    var lines = std.mem.split(u8, input, "\n");
    var occurrences = [_]u8{0} ** 128;
    var checked = std.AutoHashMap(Key, void).init(utils.allocator);
    defer checked.deinit();

    if (lines.peek()) |line| {
        lineLen = line.len;
    } else {
        return 0;
    }

    var row: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |col, c| {
            if (c != '.') {
                map[row][col].freq = c;

                if (c < 128) {
                    occurrences[c] += 1;
                }
            }
        }

        row += 1;
    }

    var antinodes: u64 = 0;

    for (0.., map) |origY, mapRow| {
        for (0.., mapRow) |origX, tile| {
            const c = tile.freq;
            if (c >= 128 or occurrences[c] <= 1) {
                continue;
            }

            for (0.., map) |origY1, mapRow1| {
                for (0.., mapRow1) |origX1, tile1| {
                    var x = origX;
                    var y = origY;
                    var x1 = origX1;
                    var y1 = origY1;

                    if (tile1.freq != c or (x1 == x and y1 == y)) {
                        continue;
                    }

                    const key1 = Key{ .x1 = x, .x2 = x1, .y1 = y, .y2 = y1 };
                    const key2 = Key{ .x1 = x1, .x2 = x, .y1 = y1, .y2 = y };

                    if (checked.contains(key1) or checked.contains(key2)) {
                        continue;
                    }

                    try checked.put(key1, {});
                    try checked.put(key2, {});

                    if (!map[y][x].antinode) {
                        antinodes += 1;
                    }
                    map[y][x].antinode = true;

                    if (!map[y1][x1].antinode) {
                        antinodes += 1;
                    }
                    map[y1][x1].antinode = true;

                    const dx = if (x >= x1) x - x1 else x1 - x;
                    const dxPos = x > x1;
                    const dy = if (y >= y1) y - y1 else y1 - y;
                    const dyPos = y > y1;

                    var x2 = x;
                    var y2 = y;
                    var x3 = x;
                    var y3 = y;

                    if (dxPos and dyPos) {
                        while (dx <= x1 and dy <= y1) {
                            x2 = x1 - dx;
                            y2 = y1 - dy;

                            if (!map[y2][x2].antinode) {
                                antinodes += 1;
                            }

                            map[y2][x2].antinode = true;

                            x1 = x2;
                            y1 = y2;
                        }

                        while ((dx + x) < lineLen and (dy + y) < lineLen) {
                            x3 = x + dx;
                            y3 = y + dy;

                            if (!map[y3][x3].antinode) {
                                antinodes += 1;
                            }

                            map[y3][x3].antinode = true;

                            x = x3;
                            y = y3;
                        }
                    } else if (dxPos and !dyPos) {
                        while (dx <= x1 and (dy + y1) < lineLen) {
                            x2 = x1 - dx;
                            y2 = y1 + dy;

                            if (!map[y2][x2].antinode) {
                                antinodes += 1;
                            }

                            map[y2][x2].antinode = true;

                            x1 = x2;
                            y1 = y2;
                        }

                        while ((dx + x) < lineLen and dy <= y) {
                            x3 = x + dx;
                            y3 = y - dy;

                            if (!map[y3][x3].antinode) {
                                antinodes += 1;
                            }

                            map[y3][x3].antinode = true;

                            x = x3;
                            y = y3;
                        }
                    } else if (!dxPos and dyPos) {
                        while ((dx + x1) < lineLen and dy <= y1) {
                            x2 = x1 + dx;
                            y2 = y1 - dy;

                            if (!map[y2][x2].antinode) {
                                antinodes += 1;
                            }

                            map[y2][x2].antinode = true;

                            x1 = x2;
                            y1 = y2;
                        }

                        while (dx <= x and (dy + y) < lineLen) {
                            x3 = x - dx;
                            y3 = y + dy;

                            if (!map[y3][x3].antinode) {
                                antinodes += 1;
                            }

                            map[y3][x3].antinode = true;

                            x = x3;
                            y = y3;
                        }
                    } else {
                        while ((dx + x1) < lineLen and (dy + y1) < lineLen) {
                            x2 = x1 + dx;
                            y2 = y1 + dy;

                            if (!map[y2][x2].antinode) {
                                antinodes += 1;
                            }

                            map[y2][x2].antinode = true;

                            x1 = x2;
                            y1 = y2;
                        }

                        while (dx <= x and dy <= y) {
                            x3 = x - dx;
                            y3 = y - dy;

                            if (!map[y3][x3].antinode) {
                                antinodes += 1;
                            }

                            map[y3][x3].antinode = true;

                            x = x3;
                            y = y3;
                        }
                    }
                }
            }
        }
    }

    return antinodes;
}

const testInput =
    \\............
    \\........0...
    \\.....0......
    \\.......0....
    \\....0.......
    \\......A.....
    \\............
    \\............
    \\........A...
    \\.........A..
    \\............
    \\............
;

test "eight part one" {
    const expected = 14;
    const actual = partOne(testInput);

    try std.testing.expectEqual(expected, actual);
}

test "eight part two" {
    const expected = 34;
    const actual = partTwo(testInput);

    try std.testing.expectEqual(expected, actual);
}
