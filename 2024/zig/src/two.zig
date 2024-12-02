const std = @import("std");
const expectEqual = std.testing.expectEqual;

const ModeDebug = false;

const DirectionNotSet = 0;
const DirectionAsc = 1;
const DirectionDesc = 2;

const LvlThreshold = 3;

fn debug(comptime fmt: []const u8, args: anytype) void {
    if (ModeDebug) {
        std.debug.print(fmt, args);
    }
}

pub fn partOne(input: []const u8) !u32 {
    debug("\n", .{});
    debug("###############################\n", .{});
    debug("########### Part 1 ############\n", .{});
    debug("###############################\n", .{});
    var lines = std.mem.split(u8, input, "\n");
    var safeReports: u32 = 0;

    while (lines.next()) |report| {
        if (report.len == 0) {
            continue;
        }

        debug("\n{s}\n", .{report});
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
            debug("cur={d} pre={d} dir={d}\n", .{ currentLvl, prevLvl, direction });

            if (prevSet) {
                if (currentLvl == prevLvl) {
                    debug("{d} == {d}\n", .{ currentLvl, prevLvl });
                    isSafe = false;
                    break;
                }

                if (direction == DirectionNotSet) {
                    if ((currentLvl > prevLvl) and ((currentLvl - prevLvl) <= LvlThreshold)) {
                        direction = DirectionAsc;
                    } else if ((currentLvl < prevLvl) and ((prevLvl - currentLvl) <= LvlThreshold)) {
                        direction = DirectionDesc;
                    } else {
                        debug("Direction could not be set\n", .{});
                        isSafe = false;
                        break;
                    }
                } else if (direction == DirectionAsc) {
                    if ((currentLvl < prevLvl) or ((currentLvl - prevLvl) > LvlThreshold)) {
                        debug("Not ascending\n", .{});
                        isSafe = false;
                        break;
                    }
                } else if (direction == DirectionDesc) {
                    if ((currentLvl > prevLvl) or ((prevLvl - currentLvl) > LvlThreshold)) {
                        debug("Not descending\n", .{});
                        isSafe = false;
                        break;
                    }
                } else {
                    debug("Invalid direction\n", .{});
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
            debug("Safe++\n", .{});
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

pub fn partTwo(input: []const u8) !u32 {
    debug("\n", .{});
    debug("###############################\n", .{});
    debug("########### Part 2 ############\n", .{});
    debug("###############################\n", .{});
    var lines = std.mem.split(u8, input, "\n");
    var safeReports: u32 = 0;

    while (lines.next()) |report| {
        if (report.len == 0) {
            continue;
        }

        debug("\n{s}\n", .{report});
        var levels = std.mem.split(u8, report, " ");
        var levelsList = std.ArrayList(u32).init(std.heap.page_allocator);
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

                debug("cur={d} pre={d} dir={d}\n", .{ currentLvl, prevLvl, direction });

                if (prevSet) {
                    if (currentLvl == prevLvl) {
                        debug("{d} == {d}\n", .{ currentLvl, prevLvl });
                        isSafe = false;
                        break;
                    }

                    if (direction == DirectionNotSet) {
                        if ((currentLvl > prevLvl) and ((currentLvl - prevLvl) <= LvlThreshold)) {
                            direction = DirectionAsc;
                        } else if ((currentLvl < prevLvl) and ((prevLvl - currentLvl) <= LvlThreshold)) {
                            direction = DirectionDesc;
                        } else {
                            debug("Direction could not be set\n", .{});
                            isSafe = false;
                            break;
                        }
                    } else if (direction == DirectionAsc) {
                        if ((currentLvl < prevLvl) or ((currentLvl - prevLvl) > LvlThreshold)) {
                            debug("Not ascending\n", .{});
                            isSafe = false;
                            break;
                        }
                    } else if (direction == DirectionDesc) {
                        if ((currentLvl > prevLvl) or ((prevLvl - currentLvl) > LvlThreshold)) {
                            debug("Not descending\n", .{});
                            isSafe = false;
                            break;
                        }
                    } else {
                        debug("Invalid direction\n", .{});
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
            debug("Safe++\n", .{});
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

    // TODO:
    // - [ ] add index counter to result for loop
    // - [ ] if the first and second nums don't work, check 1.+3. as well as 2.+3., might bring a direction change

    const expected = 9;
    const actual = partTwo(input);

    try expectEqual(expected, actual);
}
