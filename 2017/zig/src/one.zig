const std = @import("std");
const utils = @import("utils.zig");

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const str = lines.next() orelse return 0;
    var sum: u64 = 0;

    for (0.., str) |i, digit| {
        if (str[(i + 1) % str.len] == digit) {
            sum += digit - '0';
        }
    }

    return sum;
}

test "one part one" {
    try std.testing.expectEqual(3, partOne("1122"));
    try std.testing.expectEqual(4, partOne("1111"));
    try std.testing.expectEqual(0, partOne("1234"));
    try std.testing.expectEqual(9, partOne("91212129"));
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const str = lines.next() orelse return 0;
    var sum: u64 = 0;

    for (0.., str) |i, digit| {
        if (str[(i + (str.len / 2)) % str.len] == digit) {
            sum += digit - '0';
        }
    }

    return sum;
}

test "one part two" {
    try std.testing.expectEqual(6, partTwo("1212"));
    try std.testing.expectEqual(0, partTwo("1221"));
    try std.testing.expectEqual(4, partTwo("123425"));
    try std.testing.expectEqual(12, partTwo("123123"));
    try std.testing.expectEqual(4, partTwo("12131415"));
}
