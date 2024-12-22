const std = @import("std");
const utils = @import("utils.zig");

fn next(secret: u64) u64 {
    var res = (secret ^ std.math.shl(u64, secret, 6)) % 16777216;
    res = (res ^ std.math.shr(u64, res, 5)) % 16777216;

    return (res ^ std.math.shl(u64, res, 11)) % 16777216;
}

// in 000000000000000000000001 000000000000000000001010
//
// << 000000000000000001000000 000000000000001010000000
//  ^ 000000000000000001000001 000000000000001010001010
// >> 000000000000000000000010 000000000000000000010100
//  ^ 000000000000000000000011 000000000000001010011110
// << 000000000001100000000000 000101001111000000000000
//  ^ 000000000001100000000001 000101001111001010011110
//
// << 000001100000000001000000 000000000000000000000000
//  ^ 000001100001100001000001 000000000000000000000000
// >> 000000000011000011000010 000000000000000000000000
//  ^ 000000000011000011000011 000000000000000000000000
// << 100001100001100000000000 000000000000000000000000
//  ^ 100001100111100011000011 000000000000000000000000

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var secrets = std.ArrayList(u64).init(utils.allocator);
    defer secrets.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        try secrets.append(try std.fmt.parseInt(u64, line, 10));
    }

    for (0..2000) |_| {
        for (0.., secrets.items) |i, secret| {
            secrets.items[i] = next(secret);
        }
    }

    var sum: u64 = 0;

    for (secrets.items) |secret| {
        sum += secret;
    }

    return sum;
}

const Buyer = struct {
    initial: u64,
    prices: *std.ArrayList(u4),
    changes: *std.ArrayList(i5),
};

fn getPrice(secret: u64) u4 {
    return @truncate(secret % 10);
}

fn runPartTwo(input: []const u8, numBuyers: comptime_int) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var initialPrices = [_]u64{0} ** numBuyers;
    var prices = [_][2000]u4{[_]u4{0} ** 2000} ** numBuyers;
    var changes = [_][2000]i5{[_]i5{0} ** 2000} ** numBuyers;

    var buyer: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        initialPrices[buyer] = try std.fmt.parseInt(u64, line, 10);
        buyer += 1;
    }

    buyer = 0;
    for (initialPrices) |initialPrice| {
        var secret = initialPrice;
        var price = getPrice(secret);

        for (0..2000) |i| {
            secret = next(secret);
            const nextPrice = getPrice(secret);
            const change = @as(i5, @intCast(nextPrice)) - @as(i5, @intCast(price));
            price = nextPrice;

            prices[buyer][i] = nextPrice;
            changes[buyer][i] = change;
        }

        buyer += 1;
    }

    var max: u64 = 0;

    for (0..19) |a| {
        for (0..19) |b| {
            for (0..19) |c| {
                for (0..19) |d| {
                    const a1: i5 = @as(i5, @intCast(@as(u4, @truncate(a)))) - 9;
                    const b1: i5 = @as(i5, @intCast(@as(u4, @truncate(b)))) - 9;
                    const c1: i5 = @as(i5, @intCast(@as(u4, @truncate(c)))) - 9;
                    const d1: i5 = @as(i5, @intCast(@as(u4, @truncate(d)))) - 9;
                    const seq = [_]i5{ a1, b1, c1, d1 };
                    var sum: u64 = 0;

                    for (0..numBuyers) |buyer1| {
                        const ch = changes[buyer1];
                        const p = prices[buyer1];

                        for (3..2000) |i| {
                            if (ch[i - 3] == seq[0] and ch[i - 2] == seq[1] and ch[i - 1] == seq[2] and ch[i] == seq[3]) {
                                sum += p[i];
                                break;
                            }
                        }
                    }

                    if (sum > max) {
                        max = sum;
                    }
                }
            }
        }
    }

    return max;
}

pub fn partTwo(input: []const u8) !u64 {
    return runPartTwo(input, 1685);
}

const testInput =
    \\1
    \\10
    \\100
    \\2024
;

test "twentytwo part one" {
    try std.testing.expectEqual(37327623, partOne(testInput));
}

test "twentytwo part two" {
    try std.testing.expectEqual(23, runPartTwo(testInput, 4));
}
