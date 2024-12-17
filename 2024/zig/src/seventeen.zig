const std = @import("std");
const utils = @import("utils.zig");

const Instruction = enum(u3) {
    adv = 0,
    bxl = 1,
    bst = 2,
    jnz = 3,
    bxc = 4,
    out = 5,
    bdv = 6,
    cdv = 7,
};

const Computer = struct {
    program: *[]u3,
    end: *u3,
    ip: *u3,
    registers: *[3]usize,
    stdout: *[]u3,
    stdoutEnd: *u5,

    fn init(self: @This(), input: []const u8) !void {
        var lines = std.mem.split(u8, input, "\n");
        var i: u2 = 0;

        self.ip.* = 0;

        for (0..self.stdout.*.len) |o| {
            self.stdout.*[o] = 0;
        }
        self.stdoutEnd.* = 0;

        while (lines.next()) |line| {
            if (line.len == 0) {
                continue;
            }

            var parts = std.mem.split(u8, line, ": ");
            _ = parts.next();
            const str = parts.next() orelse unreachable;

            if (i < 3) {
                const num = try std.fmt.parseInt(usize, str, 10);
                self.registers.*[i] = num;
            } else {
                for (0.., str) |j, num| {
                    if (num == ',') {
                        continue;
                    }

                    self.program.*[j / 2] = parseDigit(num);

                    if (j % 4 == 0) {
                        self.end.* = @truncate(j / 4);
                    }
                }
            }

            if (i < 3) {
                i += 1;
            }
        }
    }

    fn combo(self: @This(), operand: u3) usize {
        return if (operand < 4) operand else self.registers.*[operand - 4];
    }

    fn exec(self: @This(), opcode: Instruction, operand: u3) bool {
        switch (opcode) {
            .adv => {
                const num = self.registers.*[0];
                const exponent = self.combo(operand);
                const denom = std.math.pow(usize, 2, exponent);
                self.registers.*[0] = num / denom;
            },
            .bxl => {
                self.registers.*[1] ^= operand;
            },
            .bst => {
                self.registers.*[1] = self.combo(operand) % 8;
            },
            .jnz => {
                if (self.registers.*[0] != 0) {
                    self.ip.* = operand;
                    return false;
                }
            },
            .bxc => {
                self.registers.*[1] ^= self.registers.*[2];
            },
            .out => {
                const val = self.combo(operand) % 8;
                self.print(@truncate(val));
            },
            .bdv => {
                const num = self.registers.*[0];
                const exponent = self.combo(operand);
                const denom = std.math.pow(usize, 2, exponent);
                self.registers.*[1] = num / denom;
            },
            .cdv => {
                const num = self.registers.*[0];
                const exponent = self.combo(operand);
                const denom = std.math.pow(usize, 2, exponent);
                self.registers.*[2] = num / denom;
            },
        }

        return true;
    }

    fn print(self: @This(), val: u3) void {
        self.stdout.*[self.stdoutEnd.*] = val;
        self.stdoutEnd.* += 1;
    }

    fn run(self: @This()) void {
        while (true) {
            const ip = @as(u4, self.ip.*) * 2;
            const opcode: Instruction = @enumFromInt(self.program.*[ip]);
            const operand = self.program.*[ip + 1];

            // utils.debug("{d}: {d} {d}", .{ ip, @intFromEnum(opcode), operand });
            const increaseIp = self.exec(opcode, operand);

            if (increaseIp) {
                const nextIp = @addWithOverflow(self.ip.*, 1);

                if (nextIp[1] == 1 or nextIp[0] > self.end.*) {
                    break;
                }

                self.ip.* = nextIp[0];
            }
        }
    }
};

fn parseDigit(c: u8) u3 {
    const d = c - '0';
    return @truncate(d % 8);
}

pub fn partOne(input: []const u8) !u64 {
    var program = try utils.allocator.alloc(u3, 16);
    defer utils.allocator.free(program);
    var end: u3 = 0;
    var ip: u3 = 0;
    var registers = [_]usize{ 0, 0, 0 };
    var stdout = try utils.allocator.alloc(u3, 20);
    defer utils.allocator.free(stdout);
    var stdoutEnd: u5 = 0;

    var computer = Computer{ .program = &program, .end = &end, .ip = &ip, .registers = &registers, .stdout = &stdout, .stdoutEnd = &stdoutEnd };
    try computer.init(input);
    computer.run();

    var result: u64 = 0;

    for (stdout[0..stdoutEnd]) |num| {
        result = result * 10 + num;
    }

    return result;
}

pub fn partTwo(input: []const u8) !u64 {
    var program = try utils.allocator.alloc(u3, 16);
    defer utils.allocator.free(program);
    var end: u3 = 0;
    var ip: u3 = 0;
    var registers = [_]usize{ 0, 0, 0 };
    var stdout = try utils.allocator.alloc(u3, 20);
    defer utils.allocator.free(stdout);
    var stdoutEnd: u5 = 0;
    var computer = Computer{ .program = &program, .end = &end, .ip = &ip, .registers = &registers, .stdout = &stdout, .stdoutEnd = &stdoutEnd };
    try computer.init(input);
    computer.run();
    const programEnd = @as(u5, end) * 2 + 2;
    var results = std.ArrayList(u64).init(utils.allocator);
    defer results.deinit();
    try results.append(0);

    // props to https://github.com/tymscar/Advent-Of-Code/blob/eb537226b0b4c4e1b99cf5150822938a09b0035c/2024/kotlin/src/main/kotlin/com/tymscar/day17/part2/part2.kt
    for (0..programEnd) |i| {
        const instruction = @as(u64, program[programEnd - i - 1]);
        var nextResults = std.ArrayList(u64).init(utils.allocator);
        defer nextResults.deinit();

        for (results.items) |a| {
            for (0..8) |v| {
                const registerA = std.math.shl(u64, a, 3) | v;
                try computer.init(input);
                registers[0] = registerA;
                computer.run();

                if (stdout[0] == instruction) {
                    try nextResults.append(registerA);
                }
            }
        }

        results.clearRetainingCapacity();

        for (nextResults.items) |item| {
            try results.append(item);
        }
    }

    return std.sort.min(u64, results.items, {}, std.sort.asc(u64)) orelse 0;
}

const testInput1 =
    \\Register A: 729
    \\Register B: 0
    \\Register C: 0
    \\
    \\Program: 0,1,5,4,3,0
;

const testInput2 =
    \\Register A: 2024
    \\Register B: 0
    \\Register C: 0
    \\
    \\Program: 0,3,5,4,3,0
;

test "seventeen part one" {
    try std.testing.expectEqual(4635635210, partOne(testInput1));
}

test "seventeen part two" {
    try std.testing.expectEqual(117440, partTwo(testInput2));
}
