const std = @import("std");
const utils = @import("utils.zig");

const rows = 7;
const cols = 5;

const Lock = [cols]u3;
const Key = [cols]u3;

pub fn partOne(input: []const u8) !u64 {
    var blocks = std.mem.split(u8, input, "\n\n");
    var locks = std.ArrayList(Lock).init(utils.allocator);
    defer locks.deinit();
    var keys = std.ArrayList(Key).init(utils.allocator);
    defer keys.deinit();

    while (blocks.next()) |block| {
        var isLock = true;

        for (0..cols) |i| {
            if (block[i] != '#') {
                isLock = false;
                break;
            }
        }

        var lines = std.mem.split(u8, block, "\n");
        var heights = [_]u3{0} ** cols;

        var i: u3 = 0;
        while (lines.next()) |line| {
            if ((isLock and i == 0) or (!isLock and i == rows - 1)) {
                i += 1;
                continue;
            }

            for (0.., line) |col, c| {
                if (c == '#') {
                    heights[col] += 1;
                }
            }

            i += 1;
        }

        if (isLock) {
            try locks.append(heights);
        } else {
            try keys.append(heights);
        }
    }

    var numUniqueCombinations: u64 = 0;

    for (locks.items) |lock| {
        for (keys.items) |key| {
            var fits = true;

            for (0..cols) |col| {
                const sum = @addWithOverflow(lock[col], key[col]);

                if (sum[1] == 1 or sum[0] >= 6) {
                    fits = false;
                    break;
                }
            }

            if (fits) {
                numUniqueCombinations += 1;
            }
        }
    }

    return numUniqueCombinations;
}

pub fn partTwo(input: []const u8) !u64 {
    if (input.len == 0) {
        return 0;
    }

    return 0;
}

const testInput =
    \\#####
    \\.####
    \\.####
    \\.####
    \\.#.#.
    \\.#...
    \\.....
    \\
    \\#####
    \\##.##
    \\.#.##
    \\...##
    \\...#.
    \\...#.
    \\.....
    \\
    \\.....
    \\#....
    \\#....
    \\#...#
    \\#.#.#
    \\#.###
    \\#####
    \\
    \\.....
    \\.....
    \\#.#..
    \\###..
    \\###.#
    \\###.#
    \\#####
    \\
    \\.....
    \\.....
    \\.....
    \\#....
    \\#.#..
    \\#.#.#
    \\#####
;

test "twentyfive part one" {
    try std.testing.expectEqual(3, partOne(testInput));
}

test "twentyfive part two" {
    try std.testing.expectEqual(0, partTwo(testInput));
}
