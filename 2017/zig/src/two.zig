const std = @import("std");
const utils = @import("utils.zig");

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var checksum: u64 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        // All numbers in the input are smaller than 2^14, so u14 is sufficient
        var min: u14 = 0;
        var max: u14 = 0;

        var numbers = std.mem.splitScalar(u8, line, '\t');

        while (numbers.next()) |number| {
            if (number.len == 0) {
                continue;
            }

            const value = try std.fmt.parseInt(u14, number, 10);

            if (min == 0 or min > value) {
                min = value;
            }

            if (max == 0 or max < value) {
                max = value;
            }
        }

        checksum += max - min;
    }

    return checksum;
}

test "two part one" {
    const input = "5\t1\t9\t5\n7\t5\t3\n2\t4\t6\t8";
    try std.testing.expectEqual(18, partOne(input));
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var checksum: u64 = 0;
    // All numbers in the input are smaller than 2^14, so u14 is sufficient
    // Also input lines have a maximum of 16 elements per line
    var prevNumbers = [_]u14{0} ** 16;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var numbers = std.mem.splitScalar(u8, line, '\t');
        // prevNumbers has 16=2^4 elements, so u4 is sufficient
        var i: u4 = 0;

        while (numbers.next()) |number| {
            if (number.len == 0) {
                continue;
            }

            const value = try std.fmt.parseInt(u14, number, 10);

            prevNumbers[i] = value;

            // prevNumbers has 16=2^4 elements, so u4 is sufficient
            var j: u4 = 0;

            while (j < i) {
                if (prevNumbers[j] >= value and prevNumbers[j] % value == 0) {
                    checksum += prevNumbers[j] / value;
                    break;
                } else if (prevNumbers[j] < value and value % prevNumbers[j] == 0) {
                    checksum += value / prevNumbers[j];
                    break;
                }

                j += 1;
            }

            if (j != i) {
                // Values were found in the above while loop, no need to look further for this line
                break;
            }

            i += 1;
        }
    }

    return checksum;
}

test "two part two" {
    const input = "5\t9\t2\t8\n9\t4\t7\t3\n3\t8\t6\t5";
    try std.testing.expectEqual(9, partTwo(input));
}
