const std = @import("std");
const utils = @import("utils.zig");

const GateType = enum {
    AND,
    OR,
    XOR,

    fn fromString(str: []const u8) @This() {
        if (str[0] == 'A') {
            return .AND;
        }
        if (str[0] == 'O') {
            return .OR;
        }
        return .XOR;
    }
};

fn isInitialInput(str: []const u8) bool {
    if (str[0] != 'x' and str[0] != 'y') {
        return false;
    }

    _ = std.fmt.charToDigit(str[1], 10) catch return false;
    _ = std.fmt.charToDigit(str[2], 10) catch return false;

    return true;
}

fn isFinalOutput(str: []const u8) bool {
    if (str[0] != 'z') {
        return false;
    }

    _ = std.fmt.charToDigit(str[1], 10) catch return false;
    _ = std.fmt.charToDigit(str[2], 10) catch return false;

    return true;
}

const Gate = struct {
    type: GateType,
    in0: []const u8,
    in1: []const u8,
    out: []const u8,

    fn countInitialInputs(self: @This()) u2 {
        var ins: u2 = 0;
        if (isInitialInput(self.in0)) ins += 1;
        if (isInitialInput(self.in1)) ins += 1;
        return ins;
    }

    fn calc(self: @This(), wires: *std.StringHashMap(u1)) !u1 {
        const in0 = wires.get(self.in0) orelse return error{x}.x;
        const in1 = wires.get(self.in1) orelse return error{x}.x;

        return switch (self.type) {
            .AND => in0 & in1,
            .OR => in0 | in1,
            .XOR => in0 ^ in1,
        };
    }
};

fn sortByInitialInputCout(_: void, a: Gate, b: Gate) bool {
    const aIns = a.countInitialInputs();
    const bIns = b.countInitialInputs();

    return aIns < bIns;
}

fn runPartOne(input: []const u8, numFinalOuts: comptime_int) !u64 {
    var wires = std.StringHashMap(u1).init(utils.allocator);
    defer wires.deinit();
    var gates = std.ArrayList(Gate).init(utils.allocator);
    defer gates.deinit();
    var parts = std.mem.split(u8, input, "\n\n");
    var wireLines = std.mem.split(u8, parts.next() orelse unreachable, "\n");
    var gateLines = std.mem.split(u8, parts.next() orelse unreachable, "\n");
    var calculatedFinalOuts: u6 = 0;

    while (wireLines.next()) |line| {
        const wire = line[0..3];
        const val: u1 = @truncate(try std.fmt.charToDigit(line[line.len - 1], 10));
        try wires.put(wire, val);
    }

    while (gateLines.next()) |line| {
        var lineParts = std.mem.split(u8, line, " ");
        const in0 = lineParts.next() orelse unreachable;
        const gateType = GateType.fromString(lineParts.next() orelse unreachable);
        const in1 = lineParts.next() orelse unreachable;
        _ = lineParts.next() orelse unreachable; // -> part
        const out = lineParts.next() orelse unreachable;

        try gates.append(Gate{ .type = gateType, .in0 = in0, .in1 = in1, .out = out });
    }

    std.mem.sort(Gate, gates.items, {}, sortByInitialInputCout);

    while (calculatedFinalOuts < numFinalOuts) {
        var calculatedGates = try utils.allocator.alloc(usize, gates.items.len);
        defer utils.allocator.free(calculatedGates);
        var cgi: usize = 0;

        for (0.., gates.items) |i, gate| {
            if (wires.contains(gate.out) or !wires.contains(gate.in0) or !wires.contains(gate.in0)) {
                continue;
            }

            const out = gate.calc(&wires) catch continue;
            try wires.put(gate.out, out);
            calculatedGates[cgi] = i;
            cgi += 1;

            if (isFinalOutput(gate.out)) {
                calculatedFinalOuts += 1;
            }
        }

        if (cgi > 0) {
            for (0..cgi) |i| {
                _ = gates.swapRemove(calculatedGates[cgi - i - 1]);
            }
        }
    }

    var res: u64 = 0;
    var key = try utils.allocator.alloc(u8, 3);
    defer utils.allocator.free(key);
    key[0] = 'z';

    for (0..numFinalOuts) |i| {
        key[1] = '0' + @as(u8, @truncate(i / 10));
        key[2] = '0' + @as(u8, @truncate(i % 10));
        const val = wires.get(key) orelse unreachable;

        res += std.math.shl(usize, val, i);
    }

    return res;
}

pub fn partOne(input: []const u8) !u64 {
    return runPartOne(input, 46);
}

pub fn partTwo(input: []const u8) !u64 {
    if (input.len == 0) {
        return 0;
    }

    return 0;
}

const testInput1 =
    \\x00: 1
    \\x01: 1
    \\x02: 1
    \\y00: 0
    \\y01: 1
    \\y02: 0
    \\
    \\x00 AND y00 -> z00
    \\x01 XOR y01 -> z01
    \\x02 OR y02 -> z02
;
const testInput2 =
    \\x00: 1
    \\x01: 0
    \\x02: 1
    \\x03: 1
    \\x04: 0
    \\y00: 1
    \\y01: 1
    \\y02: 1
    \\y03: 1
    \\y04: 1
    \\
    \\ntg XOR fgs -> mjb
    \\y02 OR x01 -> tnw
    \\kwq OR kpj -> z05
    \\x00 OR x03 -> fst
    \\tgd XOR rvg -> z01
    \\vdt OR tnw -> bfw
    \\bfw AND frj -> z10
    \\ffh OR nrd -> bqk
    \\y00 AND y03 -> djm
    \\y03 OR y00 -> psh
    \\bqk OR frj -> z08
    \\tnw OR fst -> frj
    \\gnj AND tgd -> z11
    \\bfw XOR mjb -> z00
    \\x03 OR x00 -> vdt
    \\gnj AND wpb -> z02
    \\x04 AND y00 -> kjc
    \\djm OR pbm -> qhw
    \\nrd AND vdt -> hwm
    \\kjc AND fst -> rvg
    \\y04 OR y02 -> fgs
    \\y01 AND x02 -> pbm
    \\ntg OR kjc -> kwq
    \\psh XOR fgs -> tgd
    \\qhw XOR tgd -> z09
    \\pbm OR djm -> kpj
    \\x03 XOR y03 -> ffh
    \\x00 XOR y04 -> ntg
    \\bfw OR bqk -> z06
    \\nrd XOR fgs -> wpb
    \\frj XOR qhw -> z04
    \\bqk OR frj -> z07
    \\y03 OR x01 -> nrd
    \\hwm AND bqk -> z03
    \\tgd XOR rvg -> z12
    \\tnw OR pbm -> gnj
;

test "twentyfour part one" {
    try std.testing.expectEqual(4, runPartOne(testInput1, 3));
    try std.testing.expectEqual(2024, runPartOne(testInput2, 13));
}

test "twentyfour part two" {
    try std.testing.expectEqual(0, partTwo(testInput1));
    try std.testing.expectEqual(0, partTwo(testInput2));
}
