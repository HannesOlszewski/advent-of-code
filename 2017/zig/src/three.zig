const std = @import("std");
const utils = @import("utils.zig");

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const line = lines.next() orelse return 0;
    const square = try std.fmt.parseInt(u64, line, 10);

    if (square == 1) {
        return 0;
    }

    var i: usize = 3;

    while (i * i < square) {
        i += 2;
    }

    const diameter = (i - 1) / 2;
    const prevFourthQuarter = (i - 2) * (i - 2);
    const fourthQuarter = i * i;
    const singleQuarter = (fourthQuarter - prevFourthQuarter) / 4;
    const firstQuarter = singleQuarter + prevFourthQuarter;
    const secondQuarter = 2 * singleQuarter + prevFourthQuarter;
    const thirdQuarter = 3 * singleQuarter + prevFourthQuarter;
    var quarterMid: u64 = 0;

    if (square <= firstQuarter) {
        quarterMid = prevFourthQuarter + ((firstQuarter - prevFourthQuarter) / 2);
    } else if (square > firstQuarter and square <= secondQuarter) {
        quarterMid = firstQuarter + ((secondQuarter - firstQuarter) / 2);
    } else if (square > secondQuarter and square <= thirdQuarter) {
        quarterMid = secondQuarter + ((thirdQuarter - secondQuarter) / 2);
    } else {
        quarterMid = thirdQuarter + ((fourthQuarter - thirdQuarter) / 2);
    }

    var distanceFromQuarterMid: u64 = 0;
    if (square <= quarterMid) {
        distanceFromQuarterMid = quarterMid - square;
    } else {
        distanceFromQuarterMid = square - quarterMid;
    }

    return diameter + distanceFromQuarterMid;
}

const Point = struct {
    row: u7,
    col: u7,
};

const Direction = enum(u2) {
    up,
    right,
    down,
    left,
};

test "three part one" {
    try std.testing.expectEqual(0, partOne("1"));
    try std.testing.expectEqual(2, partOne("9"));
    try std.testing.expectEqual(3, partOne("12"));
    try std.testing.expectEqual(2, partOne("23"));
    try std.testing.expectEqual(31, partOne("1024"));
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const line = lines.next() orelse return 0;
    const square = try std.fmt.parseInt(u64, line, 10);
    var map = [_][101]u64{[_]u64{0} ** 101} ** 101;
    var pos: Point = .{ .row = 50, .col = 51 };
    var dir: Direction = .up;
    var val: u64 = 0;

    map[50][50] = 1;
    map[50][51] = 1;

    while (val <= square) {
        val = 0;

        if (dir == .up) {
            // Turn left if we can, continue forwards otherwise
            if (pos.col > 0 and map[pos.row][pos.col - 1] == 0) {
                pos.col -= 1;
                dir = .left;
            } else if (pos.row > 0) {
                pos.row -= 1;
            } else {
                break;
            }
        } else if (dir == .down) {
            // Turn left if we can, continue forwards otherwise
            if (pos.col < map.len - 1 and map[pos.row][pos.col + 1] == 0) {
                pos.col += 1;
                dir = .right;
            } else if (pos.row < map.len - 1) {
                pos.row += 1;
            } else {
                break;
            }
        } else if (dir == .right) {
            // Turn left if we can, continue forwards otherwise
            if (pos.row > 0 and map[pos.row - 1][pos.col] == 0) {
                pos.row -= 1;
                dir = .up;
            } else if (pos.col < map.len - 1) {
                pos.col += 1;
            } else {
                break;
            }
        } else if (dir == .left) {
            // Turn left if we can, continue forwards otherwise
            if (pos.row < map.len - 1 and map[pos.row + 1][pos.col] == 0) {
                pos.row += 1;
                dir = .down;
            } else if (pos.col > 0) {
                pos.col -= 1;
            } else {
                break;
            }
        }

        // Sum neighbors
        const hasLeftNeighbor = pos.row > 0;
        const hasRightNeighbor = pos.row < map.len - 1;
        const hasUpNeighbor = pos.col > 0;
        const hasDownNeighbor = pos.col < map.len - 1;

        if (hasLeftNeighbor) {
            val += map[pos.row - 1][pos.col];

            if (hasUpNeighbor) {
                val += map[pos.row - 1][pos.col - 1];
            }
            if (hasDownNeighbor) {
                val += map[pos.row - 1][pos.col + 1];
            }
        }
        if (hasRightNeighbor) {
            val += map[pos.row + 1][pos.col];

            if (hasUpNeighbor) {
                val += map[pos.row + 1][pos.col - 1];
            }
            if (hasDownNeighbor) {
                val += map[pos.row + 1][pos.col + 1];
            }
        }
        if (hasUpNeighbor) {
            val += map[pos.row][pos.col - 1];
        }
        if (hasDownNeighbor) {
            val += map[pos.row][pos.col + 1];
        }

        map[pos.row][pos.col] = val;
    }

    return val;
}

test "three part two" {
    try std.testing.expectEqual(2, partTwo("1"));
    try std.testing.expectEqual(4, partTwo("2"));
    try std.testing.expectEqual(5, partTwo("4"));
    try std.testing.expectEqual(10, partTwo("5"));
    try std.testing.expectEqual(11, partTwo("10"));
    try std.testing.expectEqual(23, partTwo("11"));
    try std.testing.expectEqual(25, partTwo("23"));
    try std.testing.expectEqual(806, partTwo("750"));
}
