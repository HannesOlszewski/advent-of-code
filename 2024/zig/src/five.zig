const std = @import("std");
const utils = @import("utils.zig");

fn createEmptyRule() [100]bool {
    return .{
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
    };
}

pub fn partOne(input: []const u8) !u32 {
    var sum: u32 = 0;
    var parts = std.mem.split(u8, input, "\n\n");
    // All numbers are < 100
    var rules = std.AutoHashMap(u8, [100]bool).init(utils.allocator);
    defer rules.deinit();

    if (parts.next()) |rulesPart| {
        var ruleLines = std.mem.split(u8, rulesPart, "\n");

        while (ruleLines.next()) |rule| {
            var pages = std.mem.split(u8, rule, "|");
            var key: u8 = 0;
            var value: u8 = 0;

            if (pages.next()) |first| {
                key = try std.fmt.parseInt(u8, first, 10);
            }

            if (pages.next()) |second| {
                value = try std.fmt.parseInt(u8, second, 10);
            }

            var list = rules.get(key) orelse createEmptyRule();
            list[value] = true;
            try rules.put(key, list);
        }
    }

    if (parts.next()) |updatesPart| {
        var updates = std.mem.split(u8, updatesPart, "\n");

        while (updates.next()) |update| {
            var pages = std.mem.split(u8, update, ",");
            var pageNums = std.ArrayList(u8).init(utils.allocator);
            defer pageNums.deinit();
            var goodUpdate = true;

            while (pages.next()) |page| {
                if (page.len == 0) {
                    goodUpdate = false;
                    continue;
                }

                const pageNum = try std.fmt.parseInt(u8, page, 10);
                try pageNums.append(pageNum);

                if (!rules.contains(pageNum)) {
                    continue;
                }

                const rule = rules.get(pageNum) orelse unreachable;

                for (pageNums.items) |prevNum| {
                    if (rule[prevNum]) {
                        goodUpdate = false;
                        break;
                    }
                }

                if (!goodUpdate) {
                    break;
                }
            }

            if (goodUpdate) {
                const middle: u8 = pageNums.items[(pageNums.items.len) / 2];
                sum += middle;
            }
        }
    }

    return sum;
}

test "five part one" {
    const input =
        \\47|53
        \\97|13
        \\97|61
        \\97|47
        \\75|29
        \\61|13
        \\75|53
        \\29|13
        \\97|29
        \\53|29
        \\61|53
        \\97|53
        \\61|29
        \\47|13
        \\75|47
        \\97|75
        \\47|61
        \\75|61
        \\47|29
        \\75|13
        \\53|13
        \\
        \\75,47,61,53,29
        \\97,61,53,29,13
        \\75,29,13
        \\75,97,47,61,53
        \\61,13,29
        \\97,13,75,29,47
    ;

    const expected = 143;
    const actual = partOne(input);

    try std.testing.expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !u32 {
    var sum: u32 = 0;
    var parts = std.mem.split(u8, input, "\n\n");
    // All numbers are < 100
    var rules = std.AutoHashMap(u8, [100]bool).init(utils.allocator);
    defer rules.deinit();

    if (parts.next()) |rulesPart| {
        var ruleLines = std.mem.split(u8, rulesPart, "\n");

        while (ruleLines.next()) |rule| {
            var pages = std.mem.split(u8, rule, "|");
            var key: u8 = 0;
            var value: u8 = 0;

            if (pages.next()) |first| {
                key = try std.fmt.parseInt(u8, first, 10);
            }

            if (pages.next()) |second| {
                value = try std.fmt.parseInt(u8, second, 10);
            }

            var list = rules.get(key) orelse createEmptyRule();
            list[value] = true;
            try rules.put(key, list);
        }
    }

    if (parts.next()) |updatesPart| {
        var updates = std.mem.split(u8, updatesPart, "\n");

        while (updates.next()) |update| {
            var pages = std.mem.split(u8, update, ",");
            var pageNums = std.ArrayList(u8).init(utils.allocator);
            defer pageNums.deinit();
            var goodUpdate = true;

            while (pages.next()) |page| {
                if (page.len == 0) {
                    goodUpdate = false;
                    continue;
                }

                const pageNum = try std.fmt.parseInt(u8, page, 10);
                try pageNums.append(pageNum);

                if (!rules.contains(pageNum)) {
                    continue;
                }

                const rule = rules.get(pageNum) orelse unreachable;

                for (pageNums.items) |prevNum| {
                    if (rule[prevNum]) {
                        goodUpdate = false;
                    }
                }
            }

            if (goodUpdate or pageNums.items.len == 0) {
                continue;
            }

            var i: usize = 0;

            while (i < pageNums.items.len) {
                const pageNum = pageNums.items[i];

                if (!rules.contains(pageNum)) {
                    i += 1;
                    continue;
                }

                const rule = rules.get(pageNum) orelse unreachable;

                for (0.., pageNums.items) |j, prevNum| {
                    if (j >= i) {
                        break;
                    }

                    if (rule[prevNum]) {
                        pageNums.items[i] = prevNum;
                        pageNums.items[j] = pageNum;
                        i = j;
                    }
                }

                i += 1;
            }

            const middle: u8 = pageNums.items[pageNums.items.len / 2];
            sum += middle;
        }
    }

    return sum;
}

test "five part two" {
    const input =
        \\47|53
        \\97|13
        \\97|61
        \\97|47
        \\75|29
        \\61|13
        \\75|53
        \\29|13
        \\97|29
        \\53|29
        \\61|53
        \\97|53
        \\61|29
        \\47|13
        \\75|47
        \\97|75
        \\47|61
        \\75|61
        \\47|29
        \\75|13
        \\53|13
        \\
        \\75,47,61,53,29
        \\97,61,53,29,13
        \\75,29,13
        \\75,97,47,61,53
        \\61,13,29
        \\97,13,75,29,47
    ;

    const expected = 123;
    const actual = partTwo(input);

    try std.testing.expectEqual(expected, actual);
}
