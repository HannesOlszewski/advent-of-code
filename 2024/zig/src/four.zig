const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    row: usize,
    col: usize,
};

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var row: usize = 0;
    var xmasCount: u64 = 0;
    var rows = std.ArrayList([]const u8).init(utils.allocator);
    defer rows.deinit();
    var xPoints = std.ArrayList(Point).init(utils.allocator);
    defer xPoints.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        try rows.append(line);

        for (0.., line) |col, char| {
            if (char == 'X') {
                try xPoints.append(Point{
                    .row = row,
                    .col = col,
                });
            }
        }

        row += 1;
    }

    const numRows = rows.items.len;
    const numCols = rows.items[0].len;

    for (xPoints.items) |x| {
        const tl = x.row >= 3 and x.col >= 3 and rows.items[x.row - 1][x.col - 1] == 'M' and rows.items[x.row - 2][x.col - 2] == 'A' and rows.items[x.row - 3][x.col - 3] == 'S';
        const t = x.row >= 3 and rows.items[x.row - 1][x.col] == 'M' and rows.items[x.row - 2][x.col] == 'A' and rows.items[x.row - 3][x.col] == 'S';
        const tr = x.row >= 3 and x.col < numCols - 3 and rows.items[x.row - 1][x.col + 1] == 'M' and rows.items[x.row - 2][x.col + 2] == 'A' and rows.items[x.row - 3][x.col + 3] == 'S';
        const l = x.col >= 3 and rows.items[x.row][x.col - 1] == 'M' and rows.items[x.row][x.col - 2] == 'A' and rows.items[x.row][x.col - 3] == 'S';
        const r = x.col < numCols - 3 and rows.items[x.row][x.col + 1] == 'M' and rows.items[x.row][x.col + 2] == 'A' and rows.items[x.row][x.col + 3] == 'S';
        const bl = x.row < numRows - 3 and x.col >= 3 and rows.items[x.row + 1][x.col - 1] == 'M' and rows.items[x.row + 2][x.col - 2] == 'A' and rows.items[x.row + 3][x.col - 3] == 'S';
        const b = x.row < numRows - 3 and rows.items[x.row + 1][x.col] == 'M' and rows.items[x.row + 2][x.col] == 'A' and rows.items[x.row + 3][x.col] == 'S';
        const br = x.row < numRows - 3 and x.col < numCols - 3 and rows.items[x.row + 1][x.col + 1] == 'M' and rows.items[x.row + 2][x.col + 2] == 'A' and rows.items[x.row + 3][x.col + 3] == 'S';

        if (tl) {
            xmasCount += 1;
        }

        if (t) {
            xmasCount += 1;
        }

        if (tr) {
            xmasCount += 1;
        }

        if (l) {
            xmasCount += 1;
        }

        if (r) {
            xmasCount += 1;
        }

        if (bl) {
            xmasCount += 1;
        }

        if (b) {
            xmasCount += 1;
        }

        if (br) {
            xmasCount += 1;
        }
    }

    return xmasCount;
}

test "four part one" {
    const input =
        \\MMMSXXMASM
        \\MSAMXMSMSA
        \\AMXSXMAAMM
        \\MSAMASMSMX
        \\XMASAMXAMM
        \\XXAMMXXAMA
        \\SMSMSASXSS
        \\SAXAMASAAA
        \\MAMMMXMMMM
        \\MXMXAXMASX
    ;

    const expected = 18;
    const actual = partOne(input);

    try std.testing.expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var row: usize = 0;
    var xmasCount: u64 = 0;
    var rows = std.ArrayList([]const u8).init(utils.allocator);
    defer rows.deinit();
    var aPoints = std.ArrayList(Point).init(utils.allocator);
    defer aPoints.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        try rows.append(line);

        for (0.., line) |col, char| {
            if (char == 'A') {
                try aPoints.append(Point{
                    .row = row,
                    .col = col,
                });
            }
        }

        row += 1;
    }

    const numRows = rows.items.len;
    const numCols = rows.items[0].len;

    for (aPoints.items) |a| {
        if (a.row < 1 or a.col < 1 or a.row == numRows - 1 or a.col == numCols - 1) {
            continue;
        }

        const t = rows.items[a.row - 1][a.col - 1] == 'M' and rows.items[a.row - 1][a.col + 1] == 'M' and rows.items[a.row + 1][a.col - 1] == 'S' and rows.items[a.row + 1][a.col + 1] == 'S';
        const l = rows.items[a.row - 1][a.col - 1] == 'M' and rows.items[a.row - 1][a.col + 1] == 'S' and rows.items[a.row + 1][a.col - 1] == 'M' and rows.items[a.row + 1][a.col + 1] == 'S';
        const r = rows.items[a.row - 1][a.col - 1] == 'S' and rows.items[a.row - 1][a.col + 1] == 'M' and rows.items[a.row + 1][a.col - 1] == 'S' and rows.items[a.row + 1][a.col + 1] == 'M';
        const b = rows.items[a.row - 1][a.col - 1] == 'S' and rows.items[a.row - 1][a.col + 1] == 'S' and rows.items[a.row + 1][a.col - 1] == 'M' and rows.items[a.row + 1][a.col + 1] == 'M';

        if (t) {
            xmasCount += 1;
        }

        if (l) {
            xmasCount += 1;
        }

        if (r) {
            xmasCount += 1;
        }

        if (b) {
            xmasCount += 1;
        }
    }

    return xmasCount;
}

test "four part two" {
    const input =
        \\MMMSXXMASM
        \\MSAMXMSMSA
        \\AMXSXMAAMM
        \\MSAMASMSMX
        \\XMASAMXAMM
        \\XXAMMXXAMA
        \\SMSMSASXSS
        \\SAXAMASAAA
        \\MAMMMXMMMM
        \\MXMXAXMASX
    ;

    const expected = 9;
    const actual = partTwo(input);

    try std.testing.expectEqual(expected, actual);
}
