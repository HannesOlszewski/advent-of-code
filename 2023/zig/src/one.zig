const std = @import("std");
const expectEqual = std.testing.expectEqual;

pub fn partOne(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: i32 = 0;

    while (lines.next()) |line| {
        var first: u8 = 0;
        var last: u8 = 0;

        for (line[0..]) |char| {
            const val = std.fmt.charToDigit(char, 10) catch continue;

            if (first == 0) first = val;
            last = val;
        }

        sum += 10 * first + last;
    }

    return sum;
}

test "one part one" {
    const input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;

    const expected = 142;
    const actual = partOne(input);

    try expectEqual(expected, actual);
}

fn replaceAll(arr: []const u8, needle: []const u8, replacement: []const u8) ![]const u8 {
    const size = std.mem.replacementSize(u8, arr, needle, replacement);
    const adjustedArr = try std.heap.page_allocator.alloc(u8, size);
    _ = std.mem.replace(u8, arr, needle, replacement, adjustedArr);

    return adjustedArr;
}

pub fn partTwo(input: []const u8) !i32 {
    var adjustedInput = try replaceAll(input, "one", "o1e");
    adjustedInput = try replaceAll(adjustedInput, "two", "t2e");
    adjustedInput = try replaceAll(adjustedInput, "three", "t3e");
    adjustedInput = try replaceAll(adjustedInput, "four", "f4r");
    adjustedInput = try replaceAll(adjustedInput, "five", "f5e");
    adjustedInput = try replaceAll(adjustedInput, "six", "s6x");
    adjustedInput = try replaceAll(adjustedInput, "seven", "s7n");
    adjustedInput = try replaceAll(adjustedInput, "eight", "e8t");
    adjustedInput = try replaceAll(adjustedInput, "nine", "n9e");

    return partOne(adjustedInput);
}

test "one part two" {
    const input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;

    const expected = 281;
    const actual = partTwo(input);

    try expectEqual(expected, actual);
}
