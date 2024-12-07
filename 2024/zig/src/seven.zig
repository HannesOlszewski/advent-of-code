const std = @import("std");
const utils = @import("utils.zig");

const Equation = struct {
    left: u64,
    right: []u64,
};

fn solvable(equation: Equation, withConcat: bool) bool {
    const left = equation.left;
    const right = equation.right;

    if (right.len == 0) {
        return false;
    }

    const num = right[0];

    if (right.len == 1) {
        return left == num;
    }

    const rest = right[1..];
    const prev = rest[0];

    rest[0] = prev + num;
    const add = Equation{
        .left = left,
        .right = rest,
    };

    if (solvable(add, withConcat)) {
        return true;
    }

    rest[0] = prev * num;
    const mult = Equation{
        .left = left,
        .right = rest,
    };

    if (solvable(mult, withConcat)) {
        return true;
    }

    if (withConcat) {
        var numLen: usize = 1;
        var tmpNum: usize = prev;

        while (tmpNum > 0) {
            numLen *= 10;
            tmpNum /= 10;
        }

        const shifted = @mulWithOverflow(num, numLen);

        if (shifted[1] == 1) {
            return false;
        }

        rest[0] = shifted[0] + prev;

        const concat = Equation{
            .left = left,
            .right = rest,
        };

        if (solvable(concat, withConcat)) {
            return true;
        }
    }

    rest[0] = prev;

    return false;
}

pub fn partOne(input: []const u8) !u64 {
    var sum: u64 = 0;
    var lines = std.mem.split(u8, input, "\n");
    var equations = std.ArrayList(Equation).init(utils.allocator);
    defer equations.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var parts = std.mem.split(u8, line, ": ");
        const leftStr = parts.next() orelse unreachable;
        const left = try std.fmt.parseInt(u64, leftStr, 10);

        const rightStr = parts.next() orelse unreachable;
        parts = std.mem.split(u8, rightStr, " ");
        var right = std.ArrayList(u64).init(utils.allocator);
        defer right.deinit();

        while (parts.next()) |part| {
            if (part.len == 0) {
                continue;
            }

            const num = try std.fmt.parseInt(u64, part, 10);
            try right.append(num);
        }

        try equations.append(Equation{
            .left = left,
            .right = try utils.allocator.dupe(u64, right.items),
        });
    }

    for (equations.items) |equation| {
        if (solvable(equation, false)) {
            sum += equation.left;
        }

        utils.allocator.free(equation.right);
    }

    return sum;
}

test "seven part one" {
    const input =
        \\190: 10 19
        \\3267: 81 40 27
        \\83: 17 5
        \\156: 15 6
        \\7290: 6 8 6 15
        \\161011: 16 10 13
        \\192: 17 8 14
        \\21037: 9 7 18 13
        \\292: 11 6 16 20
    ;

    const expected = 3749;
    const actual = partOne(input);

    try std.testing.expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !u64 {
    var sum: u64 = 0;
    var lines = std.mem.split(u8, input, "\n");
    var equations = std.ArrayList(Equation).init(utils.allocator);
    defer equations.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var parts = std.mem.split(u8, line, ": ");
        const leftStr = parts.next() orelse unreachable;
        const left = try std.fmt.parseInt(u64, leftStr, 10);

        const rightStr = parts.next() orelse unreachable;
        parts = std.mem.split(u8, rightStr, " ");
        var right = std.ArrayList(u64).init(utils.allocator);
        defer right.deinit();

        while (parts.next()) |part| {
            if (part.len == 0) {
                continue;
            }

            const num = try std.fmt.parseInt(u64, part, 10);
            try right.append(num);
        }

        try equations.append(Equation{
            .left = left,
            .right = try utils.allocator.dupe(u64, right.items),
        });
    }

    for (equations.items) |equation| {
        if (solvable(equation, true)) {
            sum += equation.left;
        }

        utils.allocator.free(equation.right);
    }

    return sum;
}

test "seven part two" {
    const input =
        \\190: 10 19
        \\3267: 81 40 27
        \\83: 17 5
        \\156: 15 6
        \\7290: 6 8 6 15
        \\161011: 16 10 13
        \\192: 17 8 14
        \\21037: 9 7 18 13
        \\292: 11 6 16 20
    ;

    const expected = 11387;
    const actual = partTwo(input);

    try std.testing.expectEqual(expected, actual);
}
