const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: u9,
    y: u9,
};

const Velocity = struct {
    x: u9,
    xReverse: bool,
    y: u9,
    yReverse: bool,
};

fn runPartOne(input: []const u8, width: comptime_int, height: comptime_int, iterations: comptime_int) !u64 {
    var lines = std.mem.split(u8, input, "\n");
    var quadrants = [4]usize{ 0, 0, 0, 0 };
    var positions = std.ArrayList(Point).init(utils.allocator);
    defer positions.deinit();

    const middleX = (width - 1) / 2;
    const middleY = (height - 1) / 2;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var parts = std.mem.split(u8, line, " ");
        var pPart = parts.next() orelse unreachable;
        var vPart = parts.next() orelse unreachable;

        var pParts = std.mem.split(u8, pPart[2..], ",");
        const pxStr = pParts.next() orelse unreachable;
        const pyStr = pParts.next() orelse unreachable;
        var px = try std.fmt.parseInt(u9, pxStr, 10);
        var py = try std.fmt.parseInt(u9, pyStr, 10);

        var vParts = std.mem.split(u8, vPart[2..], ",");
        const vxStr = vParts.next() orelse unreachable;
        const vyStr = vParts.next() orelse unreachable;
        const vxTmp = try std.fmt.parseInt(i9, vxStr, 10);
        const vyTmp = try std.fmt.parseInt(i9, vyStr, 10);

        const vx = @abs(vxTmp);
        const vy = @abs(vyTmp);

        positions.clearAndFree();
        try positions.append(Point{ .x = px, .y = py });

        for (0..iterations) |_| {
            if (vxTmp >= 0) {
                px += vx;

                if (px >= width) {
                    px %= width;
                }
            } else {
                if (vx <= px) {
                    px -= vx;
                } else {
                    px = width - (vx - px);
                }
            }

            if (vyTmp >= 0) {
                py += vy;

                if (py >= height) {
                    py %= height;
                }
            } else {
                if (vy <= py) {
                    py -= vy;
                } else {
                    py = height - (vy - py);
                }
            }

            if (px != positions.items[0].x or py != positions.items[0].y) {
                try positions.append(Point{ .x = px, .y = py });
                continue;
            }

            const loopLen = positions.items.len;
            const final = positions.items[iterations % loopLen];
            px = final.x;
            py = final.y;

            break;
        }

        var i: u4 = 0;

        if (px == middleX or py == middleY) {
            continue;
        }

        if (px > middleX) {
            i += 1;
        }

        if (py > middleY) {
            i += 2;
        }

        quadrants[i] += 1;
    }

    return quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3];
}

pub fn partOne(input: []const u8) !u64 {
    return runPartOne(input, 101, 103, 100);
}

const Robot = struct {
    p: Point,
    v: Velocity,
};

fn printMap(map: [103][101]usize, second: usize) void {
    std.debug.print("Second: {d}\n", .{second});
    for (0..103) |y| {
        for (0..101) |x| {
            if (map[y][x] == 0) {
                std.debug.print(".", .{});
            } else {
                std.debug.print("#", .{});
            }
        }

        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}

fn hasBox(map: [103][101]usize, robots: std.ArrayList(Robot)) bool {
    for (robots.items) |robot| {
        const p = robot.p;
        var width: u9 = 0;
        var height: u9 = 0;

        var px = p.x;

        while (map[p.y][px] > 0) {
            width += 1;
            px += 1;

            if (px >= 101) {
                break;
            }
        }

        if (width < 5) {
            continue;
        }

        var py = p.y;

        while (map[py][p.x] > 0) {
            height += 1;
            py += 1;

            if (py >= 103) {
                break;
            }
        }

        if (height < 5) {
            continue;
        }

        px = p.x;
        py -= 1;
        var width2: u9 = 0;

        while (map[py][px] > 0 and width2 < width) {
            width2 += 1;
            px += 1;
        }

        py = p.y;
        px -= 1;
        var height2: u9 = 0;

        while (map[py][px] > 0 and height2 < height) {
            height2 += 1;
            py += 1;
        }

        if (width != width2 or height != height2) {
            continue;
        }

        return true;
    }

    return false;
}

pub fn partTwo(input: []const u8) !u64 {
    const width = 101;
    const height = 103;
    var lines = std.mem.split(u8, input, "\n");
    var robots = std.ArrayList(Robot).init(utils.allocator);
    defer robots.deinit();
    var second: u64 = 0;
    var map = [_][width]usize{[_]usize{0} ** width} ** height;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var parts = std.mem.split(u8, line, " ");
        var pPart = parts.next() orelse unreachable;
        var vPart = parts.next() orelse unreachable;

        var pParts = std.mem.split(u8, pPart[2..], ",");
        const pxStr = pParts.next() orelse unreachable;
        const pyStr = pParts.next() orelse unreachable;
        const px = try std.fmt.parseInt(u9, pxStr, 10);
        const py = try std.fmt.parseInt(u9, pyStr, 10);

        var vParts = std.mem.split(u8, vPart[2..], ",");
        const vxStr = vParts.next() orelse unreachable;
        const vyStr = vParts.next() orelse unreachable;
        const vxTmp = try std.fmt.parseInt(i9, vxStr, 10);
        const vyTmp = try std.fmt.parseInt(i9, vyStr, 10);

        const vx = @abs(vxTmp);
        const vy = @abs(vyTmp);

        const p = Point{ .x = px, .y = py };
        const v = Velocity{ .x = vx, .xReverse = vxTmp < 0, .y = vy, .yReverse = vyTmp < 0 };

        try robots.append(Robot{ .p = p, .v = v });
        map[py][px] += 1;
    }

    while (true) {
        if (hasBox(map, robots)) {
            // printMap(map, second);
            break;
        }

        for (0.., robots.items) |i, robot| {
            var p = robot.p;
            const v = robot.v;

            map[p.y][p.x] -= 1;

            if (v.xReverse) {
                if (v.x <= p.x) {
                    p.x -= v.x;
                } else {
                    p.x = width - (v.x - p.x);
                }
            } else {
                p.x += v.x;

                if (p.x >= width) {
                    p.x %= width;
                }
            }

            if (v.yReverse) {
                if (v.y <= p.y) {
                    p.y -= v.y;
                } else {
                    p.y = height - (v.y - p.y);
                }
            } else {
                p.y += v.y;

                if (p.y >= height) {
                    p.y %= height;
                }
            }

            map[p.y][p.x] += 1;
            robots.items[i].p = p;
        }

        second += 1;
    }

    return second;
}

const testInput =
    \\p=0,4 v=3,-3
    \\p=6,3 v=-1,-3
    \\p=10,3 v=-1,2
    \\p=2,0 v=2,-1
    \\p=0,0 v=1,3
    \\p=3,0 v=-2,-2
    \\p=7,6 v=-1,-3
    \\p=3,0 v=-1,-2
    \\p=9,3 v=2,3
    \\p=7,3 v=-1,2
    \\p=2,4 v=2,-3
    \\p=9,5 v=-3,-3
;

test "fourteen part one" {
    try std.testing.expectEqual(12, runPartOne(testInput, 11, 7, 100));
}
