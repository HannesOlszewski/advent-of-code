const std = @import("std");
const utils = @import("utils.zig");

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const str = lines.next() orelse return 0;

    var i: usize = 1;
    while (true) {
        var hashInput = [_]u8{0} ** 16;
        var numDigits: usize = 0;
        var tmp = i;

        while (tmp > 0) {
            numDigits += 1;
            tmp /= 10;
        }

        var j: usize = 0;
        for (str) |c| {
            hashInput[j] = c;
            j += 1;
        }

        var k = numDigits;
        tmp = i;
        while (k > 0) {
            hashInput[j + k - 1] = @truncate((tmp % 10) + '0');
            tmp /= 10;
            k -= 1;
        }

        var hash = [_]u8{0} ** 16;
        std.crypto.hash.Md5.hash(hashInput[0..(j + numDigits)], &hash, .{});

        if (hash[0] == 0 and hash[1] == 0 and hash[2] <= 15) {
            return i;
        }

        i += 1;
    }

    return 0;
}

test "four part one" {
    try std.testing.expectEqual(609043, partOne("abcdef"));
    try std.testing.expectEqual(1048970, partOne("pqrstuv"));
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const str = lines.next() orelse return 0;

    var i: usize = 1;
    while (true) {
        var hashInput = [_]u8{0} ** 16;
        var numDigits: usize = 0;
        var tmp = i;

        while (tmp > 0) {
            numDigits += 1;
            tmp /= 10;
        }

        var j: usize = 0;
        for (str) |c| {
            hashInput[j] = c;
            j += 1;
        }

        var k = numDigits;
        tmp = i;
        while (k > 0) {
            hashInput[j + k - 1] = @truncate((tmp % 10) + '0');
            tmp /= 10;
            k -= 1;
        }

        var hash = [_]u8{0} ** 16;
        std.crypto.hash.Md5.hash(hashInput[0..(j + numDigits)], &hash, .{});

        if (hash[0] == 0 and hash[1] == 0 and hash[2] == 0) {
            return i;
        }

        i += 1;
    }

    return 0;
}

test "four part two" {
    try std.testing.expectEqual(6742839, partTwo("abcdef"));
    try std.testing.expectEqual(5714438, partTwo("pqrstuv"));
}
