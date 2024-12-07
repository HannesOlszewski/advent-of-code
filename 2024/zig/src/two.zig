const std = @import("std");
const expectEqual = std.testing.expectEqual;
const utils = @import("utils.zig");
const debug = utils.debug;

const DirectionNotSet = 0;
const DirectionAsc = 1;
const DirectionDesc = 2;

const LvlThreshold = 3;

pub fn partOne(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var safeReports: u64 = 0;

    while (lines.next()) |report| {
        if (report.len == 0) {
            continue;
        }

        debug("{s}", .{report});
        var levels = std.mem.split(u8, report, " ");
        var prevSet = false;
        var prevLvl: u32 = 0;
        var currentLvl: u32 = 0;
        var direction: u2 = 0;
        var isSafe = true;

        while (levels.next()) |lvl| {
            if (lvl.len == 0) {
                continue;
            }

            currentLvl = try std.fmt.parseInt(u32, lvl, 10);
            debug("cur={d} pre={d} dir={d}", .{ currentLvl, prevLvl, direction });

            if (prevSet) {
                if (currentLvl == prevLvl) {
                    debug("{d} == {d}", .{ currentLvl, prevLvl });
                    isSafe = false;
                    break;
                }

                if (direction == DirectionNotSet) {
                    if ((currentLvl > prevLvl) and ((currentLvl - prevLvl) <= LvlThreshold)) {
                        direction = DirectionAsc;
                    } else if ((currentLvl < prevLvl) and ((prevLvl - currentLvl) <= LvlThreshold)) {
                        direction = DirectionDesc;
                    } else {
                        debug("Direction could not be set", .{});
                        isSafe = false;
                        break;
                    }
                } else if (direction == DirectionAsc) {
                    if ((currentLvl < prevLvl) or ((currentLvl - prevLvl) > LvlThreshold)) {
                        debug("Not ascending", .{});
                        isSafe = false;
                        break;
                    }
                } else if (direction == DirectionDesc) {
                    if ((currentLvl > prevLvl) or ((prevLvl - currentLvl) > LvlThreshold)) {
                        debug("Not descending", .{});
                        isSafe = false;
                        break;
                    }
                } else {
                    debug("Invalid direction", .{});
                    isSafe = false;
                    break;
                }
            }

            prevLvl = currentLvl;
            currentLvl = 0;
            prevSet = true;
        }

        if (isSafe) {
            safeReports += 1;
            debug("Safe++", .{});
        }
    }

    return safeReports;
}

test "two part one" {
    const input =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;

    const expected = 2;
    const actual = partOne(input);

    try expectEqual(expected, actual);
}

pub fn partTwo(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var safeReports: u64 = 0;

    while (lines.next()) |report| {
        if (report.len == 0) {
            continue;
        }

        debug("{s}", .{report});
        var levels = std.mem.split(u8, report, " ");
        var levelsList = std.ArrayList(u32).init(utils.allocator);
        defer levelsList.deinit();
        var hasSavePermutation = false;

        while (levels.next()) |levelStr| {
            const lvl = try std.fmt.parseInt(u32, levelStr, 10);
            try levelsList.append(lvl);
        }

        for (0.., levelsList.items) |i, _| {
            var cpy = try levelsList.clone();
            defer cpy.deinit();
            _ = cpy.orderedRemove(i);
            var prevSet = false;
            var prevLvl: u32 = 0;
            var currentLvl: u32 = 0;
            var direction: u2 = 0;
            var isSafe = true;

            for (cpy.items) |lvl| {
                currentLvl = lvl;

                debug("cur={d} pre={d} dir={d}", .{ currentLvl, prevLvl, direction });

                if (prevSet) {
                    if (currentLvl == prevLvl) {
                        debug("{d} == {d}", .{ currentLvl, prevLvl });
                        isSafe = false;
                        break;
                    }

                    if (direction == DirectionNotSet) {
                        if ((currentLvl > prevLvl) and ((currentLvl - prevLvl) <= LvlThreshold)) {
                            direction = DirectionAsc;
                        } else if ((currentLvl < prevLvl) and ((prevLvl - currentLvl) <= LvlThreshold)) {
                            direction = DirectionDesc;
                        } else {
                            debug("Direction could not be set", .{});
                            isSafe = false;
                            break;
                        }
                    } else if (direction == DirectionAsc) {
                        if ((currentLvl < prevLvl) or ((currentLvl - prevLvl) > LvlThreshold)) {
                            debug("Not ascending", .{});
                            isSafe = false;
                            break;
                        }
                    } else if (direction == DirectionDesc) {
                        if ((currentLvl > prevLvl) or ((prevLvl - currentLvl) > LvlThreshold)) {
                            debug("Not descending", .{});
                            isSafe = false;
                            break;
                        }
                    } else {
                        debug("Invalid direction", .{});
                        isSafe = false;
                        break;
                    }
                }

                prevLvl = currentLvl;
                currentLvl = 0;
                prevSet = true;
            }

            if (isSafe) {
                hasSavePermutation = true;
                break;
            }
        }

        if (hasSavePermutation) {
            safeReports += 1;
            debug("Safe++", .{});
        }
    }

    return safeReports;
}

test "two part two" {
    const input =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\9 7 6 2 1 0
        \\1 3 2 4 5
        \\1 1 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
        \\1 3 6 7 1
        \\5 2 3 4 5 7
        \\8 3 2 1 0
        \\2 6 7 8 9
    ;

    const expected = 9;
    const actual = partTwo(input);

    try expectEqual(expected, actual);
}
