const std = @import("std");
const utils = @import("utils.zig");

fn hash(str: []const u8) u32 {
    var res: u32 = 0;

    for (0.., str) |i, c| {
        res += (c - 'a' + 1) * std.math.pow(u32, 10, @truncate(i));
    }

    return res;
}

fn hashSimple(str: []const u8) u32 {
    var res: u32 = 0;

    for (str) |char| {
        // Don't take the letters position into account anymore (the i in the function above)
        // but use char^2 for each char to avoid false positive collisions
        // If the char values were simply summed up, there is the chance that two letters sum up to the value of another letter
        // (e.g. with a=1 and b=2, ab=3, but also c=3, so ab and c would hash to the same value)
        res += std.math.pow(u32, @as(u32, char), 2);
    }

    return res;
}

// https://gist.github.com/JosephTLyons/343d337296bb03ffa6881471ea52d412
fn factorial(n: u32) u32 {
    var result: u32 = 1;
    var i: u32 = 1;

    while (i <= n) : (i += 1)
        result *= i;

    return result;
}

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var numValid: u64 = 0;
    var visitedWords = std.AutoHashMap(u32, void).init(utils.allocator);
    defer visitedWords.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var words = std.mem.splitScalar(u8, line, ' ');
        var valid = true;

        while (words.next()) |word| {
            const hashedWord = hash(word);
            if (visitedWords.contains(hashedWord)) {
                valid = false;
                break;
            }

            try visitedWords.put(hashedWord, {});
        }

        if (valid) {
            numValid += 1;
        }

        visitedWords.clearRetainingCapacity();
    }

    return numValid;
}

test "four part one" {
    const input =
        \\aa bb cc dd ee
        \\aa bb cc dd aa
        \\aa bb cc dd aaa
    ;
    try std.testing.expectEqual(2, partOne(input));
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var numValid: u64 = 0;
    var visitedWords = std.AutoHashMap(u32, void).init(utils.allocator);
    defer visitedWords.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var words = std.mem.splitScalar(u8, line, ' ');
        var valid = true;

        while (words.next()) |word| {
            const hashedWord = hashSimple(word);
            if (visitedWords.contains(hashedWord)) {
                valid = false;
                break;
            }

            try visitedWords.put(hashedWord, {});
        }

        if (valid) {
            numValid += 1;
        }

        visitedWords.clearRetainingCapacity();
    }

    return numValid;
}

test "four part two" {
    const input =
        \\abcde fghij
        \\abcde xyz ecdab
        \\a ab abc abd abf abj
        \\iiii oiii ooii oooi oooo
        \\oiii ioii iioi iiio
        \\abc bc
    ;
    try std.testing.expectEqual(4, partTwo(input));
}
