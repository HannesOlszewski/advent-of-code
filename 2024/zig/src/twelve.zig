const std = @import("std");
const utils = @import("utils.zig");

const Tile = struct {
    plant: u8,
    region: usize,
};

const Region = struct {
    area: usize,
    perimeter: usize,
    sides: usize,
};

fn parseInput(input: []const u8) [140][140]Tile {
    var garden = [_][140]Tile{[_]Tile{Tile{ .plant = '.', .region = 0 }} ** 140} ** 140;
    var lines = std.mem.split(u8, input, "\n");
    var regionIndex: usize = 0;

    var row: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        for (0.., line) |col, plant| {
            garden[row][col].plant = plant;

            if (col > 0) {
                const left = garden[row][col - 1];

                if (left.plant == plant) {
                    garden[row][col].region = left.region;
                }
            }

            if (row > 0) {
                const above = garden[row - 1][col];

                if (above.plant == plant) {
                    garden[row][col].region = above.region;

                    if (col > 0) {
                        const left = garden[row][col - 1];

                        if (left.plant == plant and left.region != above.region) {
                            const regionToReplace = left.region;

                            for (0..garden.len) |col1| {
                                const other = garden[row][col1];

                                if (other.region == regionToReplace) {
                                    garden[row][col1].region = above.region;
                                }

                                for (0..garden.len) |row1| {
                                    const otherAbove = garden[row1][col1];

                                    if (otherAbove.region == regionToReplace) {
                                        garden[row1][col1].region = above.region;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if (garden[row][col].region == 0) {
                regionIndex += 1;
                garden[row][col].region = regionIndex;
            }
        }

        row += 1;
    }

    return garden;
}

fn calcPriceWithPerimeter(garden: [140][140]Tile) !u64 {
    var regions = std.AutoHashMap(usize, Region).init(utils.allocator);
    defer regions.deinit();
    var total: u64 = 0;

    for (0.., garden) |y, gardenRow| {
        for (0.., gardenRow) |x, tile| {
            if (tile.region == 0) {
                continue;
            }

            if (!regions.contains(tile.region)) {
                try regions.put(tile.region, Region{ .area = 0, .perimeter = 0, .sides = 0 });
            }

            var region = regions.getPtr(tile.region) orelse unreachable;

            region.area += 1;

            if (y == 0 or garden[y - 1][x].region != tile.region) {
                region.perimeter += 1;
            }
            if (x == 0 or garden[y][x - 1].region != tile.region) {
                region.perimeter += 1;
            }
            if (y == garden.len - 1 or garden[y + 1][x].region != tile.region) {
                region.perimeter += 1;
            }
            if (x == garden.len - 1 or garden[y][x + 1].region != tile.region) {
                region.perimeter += 1;
            }
        }
    }

    var regionIter = regions.valueIterator();

    while (regionIter.next()) |region| {
        total += region.*.area * region.*.perimeter;
    }

    return total;
}

fn calcPriceWithSides(garden: [140][140]Tile) !u64 {
    var regions = std.AutoHashMap(usize, Region).init(utils.allocator);
    defer regions.deinit();
    var total: u64 = 0;

    for (0.., garden) |y, gardenRow| {
        for (0.., gardenRow) |x, tile| {
            if (tile.region == 0) {
                continue;
            }

            if (!regions.contains(tile.region)) {
                try regions.put(tile.region, Region{ .area = 0, .perimeter = 0, .sides = 0 });
            }

            var region = regions.getPtr(tile.region) orelse unreachable;

            region.area += 1;

            const hasAbove = y > 0;
            const aboveSameRegion = hasAbove and garden[y - 1][x].region == tile.region;
            const hasLeft = x > 0;
            const leftSameRegion = hasLeft and garden[y][x - 1].region == tile.region;
            const hasBelow = y < garden.len - 1;
            const belowSameRegion = hasBelow and garden[y + 1][x].region == tile.region;
            const hasRight = x < garden.len - 1;
            const rightSameRegion = hasRight and garden[y][x + 1].region == tile.region;

            if (leftSameRegion and aboveSameRegion) {
                const isInnerCorner = garden[y - 1][x - 1].region != tile.region;

                if (isInnerCorner) {
                    region.sides += 1;
                }
            } else if (!leftSameRegion and !aboveSameRegion) {
                // outer corner
                region.sides += 1;
            }

            if (rightSameRegion and aboveSameRegion) {
                const isInnerCorner = garden[y - 1][x + 1].region != tile.region;

                if (isInnerCorner) {
                    region.sides += 1;
                }
            } else if (!rightSameRegion and !aboveSameRegion) {
                // outer corner
                region.sides += 1;
            }

            if (rightSameRegion and belowSameRegion) {
                const isInnerCorner = garden[y + 1][x + 1].region != tile.region;

                if (isInnerCorner) {
                    region.sides += 1;
                }
            } else if (!rightSameRegion and !belowSameRegion) {
                // outer corner
                region.sides += 1;
            }

            if (leftSameRegion and belowSameRegion) {
                const isInnerCorner = garden[y + 1][x - 1].region != tile.region;

                if (isInnerCorner) {
                    region.sides += 1;
                }
            } else if (!leftSameRegion and !belowSameRegion) {
                // outer corner
                region.sides += 1;
            }
        }
    }

    var regionIter = regions.valueIterator();

    while (regionIter.next()) |region| {
        total += region.*.area * region.*.sides;
    }

    return total;
}

pub fn partOne(input: []const u8) !u64 {
    const garden = parseInput(input);

    return calcPriceWithPerimeter(garden);
}

pub fn partTwo(input: []const u8) !u64 {
    const garden = parseInput(input);

    return calcPriceWithSides(garden);
}

const testInput1 =
    \\AAAA
    \\BBCD
    \\BBCC
    \\EEEC
;

const testInput2 =
    \\OOOOO
    \\OXOXO
    \\OOOOO
    \\OXOXO
    \\OOOOO
;

const testInput3 =
    \\RRRRIICCFF
    \\RRRRIICCCF
    \\VVRRRCCFFF
    \\VVRCCCJFFF
    \\VVVVCJJCFE
    \\VVIVCCJJEE
    \\VVIIICJJEE
    \\MIIIIIJJEE
    \\MIIISIJEEE
    \\MMMISSJEEE
;

const testInput4 =
    \\AAXXX
    \\AAXAX
    \\AAAAX
    \\AAXAX
    \\AAXXX
;

const testInput5 =
    \\AAXXX
    \\AXXAX
    \\AAAAX
    \\AAXAX
    \\AAXXX
;

const testInput6 =
    \\AAAAAAAA
    \\AACBBDDA
    \\AACBBAAA
    \\ABBAAAAA
    \\ABBADDDA
    \\AAAADADA
    \\AAAAAAAA
;

const testInput7 =
    \\EEEEE
    \\EXXXX
    \\EEEEE
    \\EXXXX
    \\EEEEE
;

const testInput8 =
    \\AAAAAA
    \\AAABBA
    \\AAABBA
    \\ABBAAA
    \\ABBAAA
    \\AAAAAA
;

test "twelve part one" {
    try std.testing.expectEqual(140, partOne(testInput1));
    try std.testing.expectEqual(772, partOne(testInput2));
    try std.testing.expectEqual(1930, partOne(testInput3));
    try std.testing.expectEqual(572, partOne(testInput4));
    try std.testing.expectEqual(624, partOne(testInput5));
    try std.testing.expectEqual(2566, partOne(testInput6));
    try std.testing.expectEqual(692, partOne(testInput7));
    try std.testing.expectEqual(1184, partOne(testInput8));
}

test "twelve part two" {
    try std.testing.expectEqual(80, partTwo(testInput1));
    try std.testing.expectEqual(436, partTwo(testInput2));
    try std.testing.expectEqual(1206, partTwo(testInput3));
    try std.testing.expectEqual(300, partTwo(testInput4));
    try std.testing.expectEqual(350, partTwo(testInput5));
    try std.testing.expectEqual(946, partTwo(testInput6));
    try std.testing.expectEqual(236, partTwo(testInput7));
    try std.testing.expectEqual(368, partTwo(testInput8));
}
