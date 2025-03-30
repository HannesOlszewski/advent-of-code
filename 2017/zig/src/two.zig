const std = @import("std");
const utils = @import("utils.zig");

pub fn partOne(input: []const u8) !u64 {
    // var lines = std.mem.splitScalar(u8, input, '\n');

    if (input.len == 0) {
        return 0;
    }

    return 0;
}

test "two part one" {
    const input =
        \\5 1 9 5
        \\7 5 3
        \\2 4 6 8
    ;
    try std.testing.expectEqual(0, partOne(input));
}

pub fn partTwo(input: []const u8) !u64 {
    // var lines = std.mem.splitScalar(u8, input, '\n');

    if (input.len == 0) {
        return 0;
    }

    return 0;
}

test "two part two" {
    const input =
        \\5 1 9 5
        \\7 5 3
        \\2 4 6 8
    ;
    try std.testing.expectEqual(0, partTwo(input));
}
