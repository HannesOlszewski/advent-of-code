const std = @import("std");
const expectEqual = std.testing.expectEqual;

pub fn partOne(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var listOne = std.ArrayList(i32).init(std.heap.page_allocator);
    defer listOne.deinit();
    var listTwo = std.ArrayList(i32).init(std.heap.page_allocator);
    defer listTwo.deinit();
    var numItems: i32 = 0;
    var sum: i32 = 0;

    while (lines.next()) |line| {
        var first: i32 = 0;
        var l: usize = 0;

        while (l < line.len) {
            if (line[l] == ' ') {
                // there are always three spaces between the numbers, set l to the beginning of the next number
                l += 3;
                break;
            }

            const val = std.fmt.charToDigit(line[l], 10) catch continue;
            first = first * 10 + val;
            l += 1;
        }

        var inserted = false;
        for (0.., listOne.items) |i, item| {
            if (item >= first) {
                try listOne.insert(i, first);
                inserted = true;
                break;
            }
        }

        if (!inserted) {
            try listOne.append(first);
        }

        var last: i32 = 0;

        while (l < line.len) {
            const val = std.fmt.charToDigit(line[l], 10) catch continue;
            last = last * 10 + val;
            l += 1;
        }

        inserted = false;
        for (0.., listTwo.items) |i, item| {
            if (item >= last) {
                try listTwo.insert(i, last);
                inserted = true;
                break;
            }
        }

        if (!inserted) {
            try listTwo.append(last);
        }

        numItems += 1;
    }

    var i: usize = 0;

    while (i < numItems) {
        const a = listOne.items[i];
        const b = listTwo.items[i];

        if (a >= b) {
            sum += a - b;
        } else {
            sum += b - a;
        }

        i += 1;
    }

    return sum;
}

test "one part one" {
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    const expected = 11;
    const actual = partOne(input);

    try expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !i32 {
    var lines = std.mem.split(u8, input, "\n");
    var listOne = std.AutoHashMap(i32, i32).init(std.heap.page_allocator);
    defer listOne.deinit();
    var listTwo = std.AutoHashMap(i32, i32).init(std.heap.page_allocator);
    defer listTwo.deinit();
    var numItems: i32 = 0;
    var sum: i32 = 0;

    while (lines.next()) |line| {
        var first: i32 = 0;
        var l: usize = 0;

        while (l < line.len) {
            if (line[l] == ' ') {
                // there are always three spaces between the numbers, set l to the beginning of the next number
                l += 3;
                break;
            }

            const val = std.fmt.charToDigit(line[l], 10) catch continue;
            first = first * 10 + val;
            l += 1;
        }

        var prev = listOne.get(first) orelse 0;
        try listOne.put(first, prev + 1);

        var last: i32 = 0;

        while (l < line.len) {
            const val = std.fmt.charToDigit(line[l], 10) catch continue;
            last = last * 10 + val;
            l += 1;
        }

        prev = listTwo.get(last) orelse 0;
        try listTwo.put(last, prev + 1);

        numItems += 1;
    }

    var iterator = listOne.iterator();

    while (iterator.next()) |item| {
        const key = item.key_ptr.*;
        const times = item.value_ptr.*;
        const similarity = listTwo.get(key) orelse 0;
        sum += key * times * similarity;
    }

    return sum;
}

test "one part two" {
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    const expected = 31;
    const actual = partTwo(input);

    try expectEqual(expected, actual);
}
