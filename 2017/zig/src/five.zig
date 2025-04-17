const std = @import("std");
const utils = @import("utils.zig");

const Instruction = struct {
    num: u11,
    forward: bool,

    fn increment(self: @This()) @This() {
        if (self.forward) {
            return Instruction{ .num = self.num + 1, .forward = true };
        }

        return Instruction{ .num = self.num - 1, .forward = self.num == 1 };
    }

    fn incrementP2(self: @This()) @This() {
        if (self.forward and self.num >= 3) {
            return Instruction{ .num = self.num - 1, .forward = true };
        }

        if (self.forward) {
            return Instruction{ .num = self.num + 1, .forward = true };
        }

        return Instruction{ .num = self.num - 1, .forward = self.num == 1 };
    }
};

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var instructions = std.ArrayList(Instruction).init(utils.allocator);
    defer instructions.deinit();
    var steps: u64 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const forward = line[0] != '-';
        const numToParse = if (forward) line else line[1..];
        const num = try std.fmt.parseInt(u11, numToParse, 10);
        try instructions.append(Instruction{ .num = num, .forward = forward });
    }

    var i: usize = 0;
    while (true) {
        steps += 1;
        const current = instructions.items[i];

        if ((current.forward and current.num >= instructions.items.len - i) or (!current.forward and current.num > i)) {
            break;
        }

        const next = if (current.forward) i + current.num else i - current.num;
        instructions.items[i] = current.increment();
        i = next;
    }

    return steps;
}

test "five part one" {
    const input =
        \\0
        \\3
        \\0
        \\1
        \\-3
    ;
    try std.testing.expectEqual(5, partOne(input));
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var instructions = std.ArrayList(Instruction).init(utils.allocator);
    defer instructions.deinit();
    var steps: u64 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const forward = line[0] != '-';
        const numToParse = if (forward) line else line[1..];
        const num = try std.fmt.parseInt(u11, numToParse, 10);
        try instructions.append(Instruction{ .num = num, .forward = forward });
    }

    var i: usize = 0;
    while (true) {
        steps += 1;
        const current = instructions.items[i];

        if ((current.forward and current.num >= instructions.items.len - i) or (!current.forward and current.num > i)) {
            break;
        }

        const next = if (current.forward) i + current.num else i - current.num;
        instructions.items[i] = current.incrementP2();
        i = next;
    }

    return steps;
}

test "five part two" {
    const input =
        \\0
        \\3
        \\0
        \\1
        \\-3
    ;
    try std.testing.expectEqual(10, partTwo(input));
}
