const std = @import("std");
const utils = @import("utils.zig");

fn compareLength(_: void, a: []const u8, b: []const u8) bool {
    return a.len < b.len;
}

fn parseAvailablePatterns(line: []const u8, cache: *std.StringHashMap(usize)) ![][]const u8 {
    var patterns = std.ArrayList([]const u8).init(utils.allocator);
    var parts = std.mem.split(u8, line, ", ");

    while (parts.next()) |pattern| {
        try patterns.append(pattern);
    }

    const slice = try patterns.toOwnedSlice();
    std.mem.sort([]const u8, slice, {}, compareLength);

    // warmup cache
    for (slice) |p| {
        _ = try match(p, slice, cache);
    }

    return slice;
}

fn match(str: []const u8, available: [][]const u8, cache: *std.StringHashMap(usize)) !usize {
    if (str.len == 0) {
        return 1;
    }

    const cachedResult = cache.get(str);

    if (cachedResult) |result| {
        return result;
    }

    var result: usize = 0;

    for (available) |pattern| {
        const isShortEnough = pattern.len <= str.len;
        const isMatch = isShortEnough and std.mem.startsWith(u8, str, pattern);

        if (isMatch) {
            const res = try match(str[pattern.len..], available, cache);

            if (res > 0) {
                result += res;
            }
        }
    }

    try cache.put(str, result);

    return result;
}

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    const firstLine = lines.next() orelse unreachable;
    var cache = std.StringHashMap(usize).init(utils.allocator);
    defer cache.deinit();
    const available = try parseAvailablePatterns(firstLine, &cache);
    defer utils.allocator.free(available);
    var matchablePatterns: u64 = 0;

    var possibleFits = std.ArrayList([]const u8).init(utils.allocator);
    defer possibleFits.deinit();

    while (lines.next()) |pattern| {
        if (pattern.len == 0) {
            continue;
        }

        possibleFits.clearAndFree();

        for (available) |p| {
            if (std.mem.containsAtLeast(u8, pattern, 1, p)) {
                try possibleFits.append(p);
            }
        }

        if (0 < try match(pattern, possibleFits.items, &cache)) {
            matchablePatterns += 1;
        }
    }

    return matchablePatterns;
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    const firstLine = lines.next() orelse unreachable;
    var cache = std.StringHashMap(usize).init(utils.allocator);
    defer cache.deinit();
    const available = try parseAvailablePatterns(firstLine, &cache);
    defer utils.allocator.free(available);
    var matchablePatterns: u64 = 0;

    var possibleFits = std.ArrayList([]const u8).init(utils.allocator);
    defer possibleFits.deinit();

    while (lines.next()) |pattern| {
        if (pattern.len == 0) {
            continue;
        }

        possibleFits.clearAndFree();

        for (available) |p| {
            if (std.mem.containsAtLeast(u8, pattern, 1, p)) {
                try possibleFits.append(p);
            }
        }

        matchablePatterns += try match(pattern, possibleFits.items, &cache);
    }

    return matchablePatterns;
}

const testInput =
    \\r, wr, b, g, bwu, rb, gb, br
    \\
    \\brwrr
    \\bggr
    \\gbbr
    \\rrbgbr
    \\ubwu
    \\bwurrg
    \\brgr
    \\bbrgwb
;

test "nineteen part one" {
    try std.testing.expectEqual(6, partOne(testInput));
}

test "nineteen part two" {
    try std.testing.expectEqual(16, partTwo(testInput));
}
