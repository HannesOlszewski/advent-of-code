const std = @import("std");
const utils = @import("utils.zig");

const Result = struct {
    part1: usize,
    part2: usize,
    multiple: bool,
    count: usize,
};

fn countDigits(num: usize) usize {
    var digits: usize = 1;
    var tmp = num;

    while (tmp >= 10) {
        digits += 1;
        tmp /= 10;
    }

    return digits;
}

fn applyRules(num: usize) Result {
    if (num == 0) {
        return Result{
            .part1 = 1,
            .part2 = 0,
            .multiple = false,
            .count = 1,
        };
    }

    const numDigits = countDigits(num);

    if (numDigits % 2 == 0) {
        const div = std.math.pow(usize, 10, numDigits / 2);
        const part1 = num / div;
        const part2 = num % div;
        return Result{
            .part1 = part1,
            .part2 = part2,
            .multiple = true,
            .count = 1,
        };
    }

    return Result{
        .part1 = num * 2024,
        .part2 = 0,
        .multiple = false,
        .count = 1,
    };
}

fn runPartOne(input: []const u8, blinks: usize) !u64 {
    const lineInput = if (input[input.len - 1] == '\n') input[0 .. input.len - 1] else input;
    var line = std.mem.split(u8, lineInput, " ");
    var nums = std.AutoHashMap(usize, usize).init(utils.allocator);
    defer nums.deinit();
    var cache = std.AutoHashMap(usize, Result).init(utils.allocator);
    defer cache.deinit();
    var new = std.ArrayList(Result).init(utils.allocator);
    defer new.deinit();
    var total: u64 = 0;

    while (line.next()) |num| {
        const parsed = try std.fmt.parseInt(usize, num, 10);
        const count = nums.get(parsed) orelse 0;
        try nums.put(parsed, count + 1);
    }

    for (0..blinks) |_| {
        var numIter = nums.iterator();
        while (numIter.next()) |entry| {
            const num = entry.key_ptr.*;
            const count = entry.value_ptr.*;
            const cacheHit = cache.get(num);
            var res: Result = undefined;

            if (cacheHit) |hit| {
                res = hit;
            } else {
                res = applyRules(num);
                try cache.put(num, res);
            }

            res.count = count;

            try new.append(res);
        }

        nums.clearAndFree();
        total = 0;

        for (new.items) |res| {
            var prev = nums.get(res.part1) orelse 0;
            try nums.put(res.part1, prev + res.count);
            total += res.count;

            if (res.multiple) {
                prev = nums.get(res.part2) orelse 0;
                try nums.put(res.part2, prev + res.count);
                total += res.count;
            }
        }

        new.clearAndFree();
    }

    return total;
}

pub fn partOne(input: []const u8) !u64 {
    return runPartOne(input, 25);
}

pub fn partTwo(input: []const u8) !u64 {
    return runPartOne(input, 75);
}

test "eleven part one" {
    try std.testing.expectEqual(22, runPartOne("125 17", 6));
    try std.testing.expectEqual(55312, runPartOne("125 17", 25));
}
