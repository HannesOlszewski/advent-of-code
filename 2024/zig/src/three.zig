const std = @import("std");
const utils = @import("utils.zig");
const debug = utils.debug;

const State = enum {
    looking,
    m,
    u,
    l,
    mulOpen,
    first,
    second,
    d,
    o,
    n,
    apo,
    t,
    doOpen,
    dontOpen,
};

fn charToDigit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        else => 10,
    };
}

fn stateToString(s: State) u8 {
    return switch (s) {
        .looking => '.',
        .m => 'm',
        .u => 'u',
        .l => 'l',
        .mulOpen => '(',
        .first => '1',
        .second => '2',
        .d => 'd',
        .o => 'o',
        .n => 'n',
        .apo => '\'',
        .t => 't',
        .doOpen => '[',
        .dontOpen => '{',
    };
}

pub fn partOne(input: []const u8) !u32 {
    var result: u32 = 0;
    var state = State.looking;
    var first: u32 = 0;
    var second: u32 = 0;

    for (input) |c| {
        // debug("{c} {c} {d}*{d}", .{ c, stateToString(state), first, second });

        switch (state) {
            .looking => {
                state = if (c == 'm') .m else .looking;
            },
            .m => {
                state = if (c == 'u') .u else .looking;
            },
            .u => {
                state = if (c == 'l') .l else .looking;
            },
            .l => {
                state = if (c == '(') .mulOpen else .looking;
            },
            .mulOpen => {
                const digit = charToDigit(c);

                if (digit > 9) {
                    state = .looking;
                    continue;
                }

                first = digit;

                state = .first;
            },
            .first => {
                if (c == ',') {
                    state = .second;
                    continue;
                }

                const digit = charToDigit(c);

                if (digit > 9) {
                    first = 0;

                    state = .looking;
                    continue;
                }

                first = first * 10 + digit;

                state = .first;
            },
            .second => {
                if (c == ')') {
                    result += first * second;
                }

                const digit = charToDigit(c);

                if (digit > 9) {
                    first = 0;
                    second = 0;

                    state = .looking;
                    continue;
                }

                second = second * 10 + digit;

                state = .second;
            },
            else => {},
        }
    }

    return result;
}

test "three part one" {
    const input =
        \\mul(44,46)
        \\xyzmul(123,4)**12
        \\mul(4*mul(6,9!?(12,34)mul ( 2 , 4 )
        \\xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    ;

    const expected = (44 * 46) + (123 * 4) + (2 * 4) + (5 * 5) + (11 * 8) + (8 * 5);
    const actual = partOne(input);

    try std.testing.expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !u32 {
    var result: u32 = 0;
    var state = State.looking;
    var first: u32 = 0;
    var second: u32 = 0;
    var enabled = true;

    for (input) |c| {
        // debug("{c} {c} {d}*{d}", .{ c, stateToString(state), first, second });

        switch (c) {
            'm' => {
                state = if (enabled) .m else .looking;
            },
            'u' => {
                state = if (enabled and state == .m) .u else .looking;
            },
            'l' => {
                state = if (enabled and state == .u) .l else .looking;
            },
            '(' => {
                if (state == .l) {
                    state = .mulOpen;
                } else if (state == .o) {
                    state = .doOpen;
                } else if (state == .t) {
                    state = .dontOpen;
                } else {
                    state = .looking;
                }
            },
            '0'...'9' => {
                const val = c - '0';

                if (state == .mulOpen) {
                    state = .first;
                    first = val;
                } else if (state == .first) {
                    first = first * 10 + val;
                } else if (state == .second) {
                    second = second * 10 + val;
                } else {
                    state = .looking;
                }
            },
            ',' => {
                if (state == .first) {
                    state = .second;
                    second = 0;
                } else {
                    state = .looking;
                }
            },
            ')' => {
                if (state == .second) {
                    // debug("mul({d},{d})", .{ first, second });
                    result += first * second;
                    first = 0;
                    second = 0;
                } else if (state == .doOpen) {
                    // debug("do()", .{});
                    enabled = true;
                } else if (state == .dontOpen) {
                    // debug("don't()", .{});
                    enabled = false;
                }

                state = .looking;
            },
            'd' => {
                state = .d;
            },
            'o' => {
                state = if (state == .d) .o else .looking;
            },
            'n' => {
                state = if (state == .o) .n else .looking;
            },
            '\'' => {
                state = if (state == .n) .apo else .looking;
            },
            't' => {
                state = if (state == .apo) .t else .looking;
            },
            else => {
                state = .looking;
            },
        }
    }

    return result;
}

test "three part two" {
    const input =
        \\mul(44,46)
        \\xyzmul(123,4)**12
        \\mul(4*mul(6,9!?(12,34)mul ( 2 , 4 )
        \\xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
        \\xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    ;

    const expected = (44 * 46) + (123 * 4) + (2 * 4) + (5 * 5) + (11 * 8) + (8 * 5) + (2 * 4) + (8 * 5);
    const actual = partTwo(input);

    try std.testing.expectEqual(expected, actual);
}
