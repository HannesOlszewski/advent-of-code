const std = @import("std");
const utils = @import("utils.zig");

const Robot = '@';
const Good = 'O';
const GoodLeft = '[';
const GoodRight = ']';
const Wall = '#';
const Empty = '.';

const Up = '^';
const Down = 'v';
const Left = '<';
const Right = '>';

const PlusOne = 2;
const Zero = 1;
const MinusOne = 0;

const Point = struct {
    x: u8,
    y: u8,
};

const Map = [50][50]u8;

const MapResult = struct {
    map: Map,
    robot: Point,
};

fn parseMap(mapInput: []const u8) MapResult {
    var map = [_][50]u8{[_]u8{Empty} ** 50} ** 50;
    var lines = std.mem.split(u8, mapInput, "\n");
    var robot = Point{ .x = 0, .y = 0 };

    var col: u8 = 0;
    while (lines.next()) |line| {
        var row: u8 = 0;

        for (line) |c| {
            map[col][row] = c;

            if (c == Robot) {
                robot.x = row;
                robot.y = col;
            }

            row += 1;
        }

        col += 1;
    }

    return MapResult{ .map = map, .robot = robot };
}

fn moveDir(dx: u2, dy: u2, robot: *Point, map: *Map) void {
    var x = robot.x + dx - 1;
    var y = robot.y + dy - 1;

    if (map[y][x] == Wall) {
        return;
    }

    if (map[y][x] == Empty) {
        const px = x - dx + 1;
        const py = y - dy + 1;

        map[y][x] = Robot;
        map[py][px] = Empty;

        robot.x = x;
        robot.y = y;

        return;
    }

    while (map[y][x] == Good) {
        x = x + dx - 1;
        y = y + dy - 1;
    }

    if (map[y][x] == Wall) {
        return;
    }

    map[y][x] = Good;
    map[robot.y][robot.x] = Empty;
    robot.x = robot.x + dx - 1;
    robot.y = robot.y + dy - 1;
    map[robot.y][robot.x] = Robot;
}

fn move(robot: *Point, dir: u8, map: *Map) void {
    switch (dir) {
        Up => moveDir(Zero, MinusOne, robot, map),
        Down => moveDir(Zero, PlusOne, robot, map),
        Left => moveDir(MinusOne, Zero, robot, map),
        Right => moveDir(PlusOne, Zero, robot, map),
        else => {},
    }
}

fn printMap(map: *Map) void {
    for (map) |row| {
        for (row) |c| {
            std.debug.print("{c}", .{c});
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n", .{});
}

pub fn partOne(input: []const u8) !u64 {
    var parts = std.mem.split(u8, input, "\n\n");
    const mapPart = parts.next() orelse unreachable;
    const mapResult = parseMap(mapPart);
    var map = mapResult.map;
    var robot = mapResult.robot;
    const instructions = parts.next() orelse unreachable;

    for (instructions) |instruction| {
        move(&robot, instruction, &map);
        // printMap(&map);
    }

    var total: u64 = 0;

    for (0.., map) |y, row| {
        for (0.., row) |x, c| {
            if (c == Good) {
                total += 100 * y + x;
            }
        }
    }

    return total;
}

const Map2 = [50][100]u8;

const MapResult2 = struct {
    map: Map2,
    robot: Point,
};

fn parseMap2(mapInput: []const u8) MapResult2 {
    var map = [_][100]u8{[_]u8{Empty} ** 100} ** 50;
    var lines = std.mem.split(u8, mapInput, "\n");
    var robot = Point{ .x = 0, .y = 0 };

    var col: u8 = 0;
    while (lines.next()) |line| {
        var row: u8 = 0;

        for (line) |c| {
            switch (c) {
                Robot => {
                    map[col][row * 2] = Robot;
                    map[col][row * 2 + 1] = Empty;
                    robot.x = row * 2;
                    robot.y = col;
                },
                Empty => {
                    map[col][row * 2] = Empty;
                    map[col][row * 2 + 1] = Empty;
                },
                Wall => {
                    map[col][row * 2] = Wall;
                    map[col][row * 2 + 1] = Wall;
                },
                Good => {
                    map[col][row * 2] = GoodLeft;
                    map[col][row * 2 + 1] = GoodRight;
                },
                else => {},
            }

            row += 1;
        }

        col += 1;
    }

    return MapResult2{ .map = map, .robot = robot };
}

fn forward(n: u8, d: u2) u8 {
    return n + d - 1;
}

fn backward(n: u8, d: u2) u8 {
    return n - d + 1;
}

fn moveDirHorizontal(dx: u2, robot: *Point, map: *Map2) void {
    var x = forward(robot.x, dx);
    const y = robot.y;

    if (map[y][x] == Wall) {
        return;
    }

    if (map[y][x] == Empty) {
        map[y][x] = Robot;
        map[y][robot.x] = Empty;

        robot.x = x;

        return;
    }

    var steps: u8 = 1;

    while (map[y][x] == GoodLeft or map[y][x] == GoodRight) {
        x = forward(x, dx);
        steps += 1;
    }

    if (map[y][x] == Wall) {
        return;
    }

    while (steps > 0) {
        if (steps == 1) {
            map[y][x] = Robot;
            robot.x = x;
        } else if (steps % 2 == 0) {
            map[y][x] = if (dx == MinusOne) GoodRight else GoodLeft;
        } else {
            map[y][x] = if (dx == MinusOne) GoodLeft else GoodRight;
        }

        x = backward(x, dx);
        steps -= 1;
    }

    map[y][x] = Empty;
}

fn canMoveGoods(dy: u2, next: Point, goods: *std.ArrayList(Point), map: *Map2) !bool {
    const y = forward(next.y, dy);

    if (map[y][next.x] == Wall or map[y][next.x + 1] == Wall) {
        return false;
    }

    if (map[y][next.x] == Empty and map[y][next.x + 1] == Empty) {
        try goods.append(next);

        return true;
    }

    if (map[y][next.x] == GoodLeft) {
        const canMove = try canMoveGoods(dy, Point{ .x = next.x, .y = y }, goods, map);

        if (!canMove) {
            return false;
        }

        try goods.append(next);

        return true;
    }

    var add = false;

    if (map[y][next.x] == GoodRight) {
        const canMove = try canMoveGoods(dy, Point{ .x = next.x - 1, .y = y }, goods, map);

        if (!canMove) {
            return false;
        }

        add = true;
    }

    if (map[y][next.x + 1] == GoodLeft) {
        const canMove = try canMoveGoods(dy, Point{ .x = next.x + 1, .y = y }, goods, map);

        if (!canMove) {
            return false;
        }

        add = true;
    }

    if (add) {
        try goods.append(next);
    }

    return add;
}

fn yLessUp(_: void, lhs: Point, rhs: Point) bool {
    return lhs.y <= rhs.y;
}

fn yLessDown(_: void, lhs: Point, rhs: Point) bool {
    return lhs.y > rhs.y;
}

fn moveDirVertical(dy: u2, robot: *Point, map: *Map2) !void {
    var x = robot.x;
    var y = forward(robot.y, dy);

    if (map[y][x] == Wall) {
        return;
    }

    if (map[y][x] == Empty) {
        map[y][x] = Robot;
        map[robot.y][robot.x] = Empty;

        robot.y = y;

        return;
    }

    var goods = std.ArrayList(Point).init(utils.allocator);
    defer goods.deinit();

    var next = Point{ .x = x, .y = y };

    if (map[y][x] == GoodRight) {
        next.x -= 1;
    }

    const canMove = try canMoveGoods(dy, next, &goods, map);

    if (!canMove) {
        return;
    }

    const items = try goods.toOwnedSlice();
    defer utils.allocator.free(items);

    if (dy == PlusOne) {
        std.sort.insertion(Point, items, {}, yLessDown);
    } else {
        std.sort.insertion(Point, items, {}, yLessUp);
    }

    for (items) |good| {
        x = good.x;
        y = forward(good.y, dy);

        map[good.y][x] = Empty;
        map[good.y][x + 1] = Empty;
        map[y][x] = GoodLeft;
        map[y][x + 1] = GoodRight;
    }

    y = forward(robot.y, dy);
    map[y][robot.x] = Robot;
    map[robot.y][robot.x] = Empty;
    robot.y = y;
}

fn move2(robot: *Point, dir: u8, map: *Map2) !void {
    switch (dir) {
        Up => try moveDirVertical(MinusOne, robot, map),
        Down => try moveDirVertical(PlusOne, robot, map),
        Left => moveDirHorizontal(MinusOne, robot, map),
        Right => moveDirHorizontal(PlusOne, robot, map),
        else => {},
    }
}

fn printMap2(map: *Map2, width: u8, height: u8) void {
    for (map[0..height]) |row| {
        for (row[0..width]) |c| {
            std.debug.print("{c}", .{c});
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n", .{});
}

pub fn partTwo(input: []const u8) !u64 {
    var parts = std.mem.split(u8, input, "\n\n");
    const mapPart = parts.next() orelse unreachable;
    const mapResult = parseMap2(mapPart);
    var map = mapResult.map;
    var robot = mapResult.robot;
    const instructions = parts.next() orelse unreachable;

    for (instructions) |instruction| {
        try move2(&robot, instruction, &map);
        // utils.debug("{d}: {c}", .{ i, instruction });
        // printMap2(&map, 14, 7);
    }
    // printMap2(&map, 100, 50);

    var total: u64 = 0;

    for (0.., map) |y, row| {
        for (0.., row) |x, c| {
            if (c == GoodLeft) {
                total += 100 * y + x;
            }
        }
    }

    return total;
}

const testInput1 =
    \\########
    \\#..O.O.#
    \\##@.O..#
    \\#...O..#
    \\#.#.O..#
    \\#...O..#
    \\#......#
    \\########
    \\
    \\<^^>>>vv<v>>v<<
;

const testInput2 =
    \\##########
    \\#..O..O.O#
    \\#......O.#
    \\#.OO..O.O#
    \\#..O@..O.#
    \\#O#..O...#
    \\#O..O..O.#
    \\#.OO.O.OO#
    \\#....O...#
    \\##########
    \\
    \\<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    \\vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    \\><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    \\<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    \\^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    \\^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    \\>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    \\<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    \\^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    \\v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
;

const testInput3 =
    \\#######
    \\#.....#
    \\#.OO@.#
    \\#.....#
    \\#######
    \\
    \\<<
;

const testInput4 =
    \\#######
    \\#.....#
    \\#.O#..#
    \\#..O@.#
    \\#.....#
    \\#######
    \\
    \\<v<<^
;

const testInput5 =
    \\#######
    \\#.....#
    \\#.O.O@#
    \\#..O..#
    \\#..O..#
    \\#.....#
    \\#######
    \\
    \\<v<<>vv<^^
;

test "fifteen part one" {
    try std.testing.expectEqual(2028, partOne(testInput1));
    try std.testing.expectEqual(10092, partOne(testInput2));
}

test "fifteen part two" {
    try std.testing.expectEqual(9021, partTwo(testInput2));
    try std.testing.expectEqual(406, partTwo(testInput3));
    try std.testing.expectEqual(509, partTwo(testInput4));
    try std.testing.expectEqual(822, partTwo(testInput5));
}
