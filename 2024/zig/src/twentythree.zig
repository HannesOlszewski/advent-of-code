const std = @import("std");
const utils = @import("utils.zig");

fn hash(str: []const u8) u10 {
    var i: u10 = 0;

    for ('a'..'z' + 1) |a| {
        for ('a'..'z' + 1) |b| {
            if (str[0] == a and str[1] == b) {
                return i;
            }

            i += 1;
        }
    }

    return i;
}

fn hashNetwork(c1: usize, c2: usize, c3: usize) usize {
    var tmp = [_]usize{ c1, c2, c3 };
    std.mem.sort(usize, &tmp, {}, std.sort.asc(usize));

    return std.math.shl(usize, tmp[0], 20) | std.math.shl(usize, tmp[1], 10) | tmp[2];
}

fn unhash(num: usize) [2]u8 {
    var i: usize = 0;

    for ('a'..'z' + 1) |a| {
        for ('a'..'z' + 1) |b| {
            if (i == num) {
                return [_]u8{ @truncate(a), @truncate(b) };
            }

            i += 1;
        }
    }

    return [_]u8{ '.', '.' };
}

const size = 26 * 26;

pub fn partOne(input: []const u8) !u64 {
    var connections = [_][size]bool{[_]bool{false} ** size} ** size;
    var lines = std.mem.split(u8, input, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const a = hash(line[0..2]);
        const b = hash(line[3..]);
        connections[a][b] = true;
        connections[b][a] = true;
    }

    var networks = std.AutoHashMap(usize, void).init(utils.allocator);
    defer networks.deinit();
    const base = hash("ta");

    for (0..26) |i| {
        const c1 = base + i;
        const conns1 = connections[c1];

        for (0..size) |c2| {
            if (conns1[c2]) {
                const conns2 = connections[c2];
                for (0..size) |c3| {
                    if (conns2[c3] and conns1[c3]) {
                        const key = hashNetwork(c1, c2, c3);
                        if (!networks.contains(key)) {
                            try networks.put(key, {});
                        }
                    }
                }
            }
        }
    }

    return networks.count();
}

fn buildNetwork(computer: u10, network: *std.AutoHashMap(u10, void), connections: *[size][size]bool) !void {
    if (network.contains(computer)) {
        return;
    }

    try network.put(computer, {});

    for (0..size) |i| {
        var connectedToNetwork = true;
        var iter = network.keyIterator();

        while (iter.next()) |other| {
            if (!connections[i][other.*]) {
                connectedToNetwork = false;
                break;
            }
        }

        if (connectedToNetwork) {
            try buildNetwork(@truncate(i), network, connections);
        }
    }
}

fn asc(_: void, a: [2]u8, b: [2]u8) bool {
    if (a[0] < b[0]) {
        return true;
    }

    if (b[0] < a[0]) {
        return false;
    }

    return a[1] < b[1];
}

pub fn partTwo(input: []const u8) !u64 {
    var connections = [_][size]bool{[_]bool{false} ** size} ** size;
    var lines = std.mem.split(u8, input, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const a = hash(line[0..2]);
        const b = hash(line[3..]);
        connections[a][b] = true;
        connections[b][a] = true;
    }

    var network = std.AutoHashMap(u10, void).init(utils.allocator);
    defer network.deinit();
    var max: u64 = 0;
    var maxNetwork = std.ArrayList([2]u8).init(utils.allocator);
    defer maxNetwork.deinit();

    for (0..size) |computer| {
        try buildNetwork(@truncate(computer), &network, &connections);

        const count = network.count();
        if (count > max) {
            max = count;

            var iter = network.keyIterator();
            maxNetwork.clearRetainingCapacity();

            while (iter.next()) |key| {
                try maxNetwork.append(unhash(key.*));
            }
        }

        network.clearRetainingCapacity();
    }

    // Print password (the flag of this part)
    // std.mem.sort([2]u8, maxNetwork.items, {}, asc);
    // for (0.., maxNetwork.items) |i, c| {
    //     std.debug.print("{s}", .{c});
    //
    //     if (i != maxNetwork.items.len - 1) {
    //         std.debug.print(",", .{});
    //     } else {
    //         std.debug.print("\n", .{});
    //     }
    // }

    return max;
}

const testInput =
    \\kh-tc
    \\qp-kh
    \\de-cg
    \\ka-co
    \\yn-aq
    \\qp-ub
    \\cg-tb
    \\vc-aq
    \\tb-ka
    \\wh-tc
    \\yn-cg
    \\kh-ub
    \\ta-co
    \\de-co
    \\tc-td
    \\tb-wq
    \\wh-td
    \\ta-ka
    \\td-qp
    \\aq-cg
    \\wq-ub
    \\ub-vc
    \\de-ta
    \\wq-aq
    \\wq-vc
    \\wh-yn
    \\ka-de
    \\kh-ta
    \\co-tc
    \\wh-qp
    \\tb-vc
    \\td-yn
;

test "twentythree part one" {
    try std.testing.expectEqual(7, partOne(testInput));
}

test "twentythree part two" {
    try std.testing.expectEqual(4, partTwo(testInput));
}
