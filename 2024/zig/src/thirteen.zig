const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: usize,
    y: usize,
};

const Machine = struct {
    a: Point,
    b: Point,
    prize: Point,
};

fn parseInput(input: []const u8, prizeIncrease: usize) !std.ArrayList(Machine) {
    var machines = std.ArrayList(Machine).init(utils.allocator);
    var parts = std.mem.split(u8, input, "\n\n");

    while (parts.next()) |part| {
        var lines = std.mem.split(u8, part, "\n");
        var machine = Machine{ .a = Point{ .x = 0, .y = 0 }, .b = Point{ .x = 0, .y = 0 }, .prize = Point{ .x = 0, .y = 0 } };

        while (lines.next()) |line| {
            if (line.len == 0) {
                continue;
            }

            var lineParts = std.mem.split(u8, line, ": ");
            const first = lineParts.next() orelse unreachable;
            var point = std.mem.split(u8, lineParts.rest(), ", ");
            var xPart = point.next() orelse unreachable;
            const x = try std.fmt.parseInt(usize, xPart[2..], 10);
            var yPart = point.next() orelse unreachable;
            const y = try std.fmt.parseInt(usize, yPart[2..], 10);

            if (first.len == "Prize".len) {
                machine.prize.x = x + prizeIncrease;
                machine.prize.y = y + prizeIncrease;
            } else if (first[first.len - 1] == 'A') {
                machine.a.x = x;
                machine.a.y = y;
            } else {
                machine.b.x = x;
                machine.b.y = y;
            }
        }

        std.debug.assert(machine.a.x > 0);
        std.debug.assert(machine.a.y > 0);
        std.debug.assert(machine.b.x > 0);
        std.debug.assert(machine.b.y > 0);
        std.debug.assert(machine.prize.x > 0);
        std.debug.assert(machine.prize.y > 0);
        try machines.append(machine);
    }

    return machines;
}

fn cramer(machines: []Machine, limitTo100: bool) !u64 {
    var total: u64 = 0;

    for (machines) |machine| {
        var a = machine.a;
        var aCost: u2 = 3;
        var b = machine.b;
        var bCost: u2 = 1;
        const c = machine.prize;
        var denum1 = a.x * b.y;
        var denum2 = b.x * a.y;

        if (denum2 > denum1) {
            a = machine.b;
            aCost = 1;
            b = machine.a;
            bCost = 3;
            denum1 = a.x * b.y;
            denum2 = b.x * a.y;
        }

        if (denum2 > denum1) {
            continue;
        }

        const denumerator = denum1 - denum2;

        if (denumerator == 0) {
            continue;
        }

        const iNum1 = c.x * b.y;
        const iNum2 = b.x * c.y;
        const jNum1 = a.x * c.y;
        const jNum2 = c.x * a.y;

        if (iNum2 > iNum1 or jNum2 > jNum1) {
            continue;
        }

        const iNumerator = iNum1 - iNum2;
        const jNumerator = jNum1 - jNum2;

        if (iNumerator % denumerator != 0 or jNumerator % denumerator != 0) {
            continue;
        }

        const i = iNumerator / denumerator;
        const j = jNumerator / denumerator;

        if (!limitTo100 or (i <= 100 and j <= 100)) {
            total += i * aCost + j * bCost;
        }
    }

    return total;
}

pub fn partOne(input: []const u8) !u64 {
    const machines = try parseInput(input, 0);
    defer machines.deinit();

    return cramer(machines.items, true);
}

pub fn partTwo(input: []const u8) !u64 {
    const machines = try parseInput(input, 10000000000000);
    defer machines.deinit();

    return cramer(machines.items, false);
}

const testInput =
    \\Button A: X+94, Y+34
    \\Button B: X+22, Y+67
    \\Prize: X=8400, Y=5400
    \\
    \\Button A: X+26, Y+66
    \\Button B: X+67, Y+21
    \\Prize: X=12748, Y=12176
    \\
    \\Button A: X+17, Y+86
    \\Button B: X+84, Y+37
    \\Prize: X=7870, Y=6450
    \\
    \\Button A: X+69, Y+23
    \\Button B: X+27, Y+71
    \\Prize: X=18641, Y=10279
;

test "thirteen part one" {
    try std.testing.expectEqual(480, partOne(testInput));
}
