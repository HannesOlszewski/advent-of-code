const std = @import("std");
const utils = @import("utils.zig");

const Block = struct {
    fileIndex: usize,
    size: usize,
    defragmented: bool = false,
};

fn parseDiskMap(input: []const u8) !std.ArrayList(Block) {
    var disk = std.ArrayList(Block).init(utils.allocator);

    for (0.., input) |i, char| {
        if (char == '\n') {
            continue;
        }

        const fileIndex = if (i % 2 == 0) i / 2 else 0;
        const size = char - '0';
        const block = Block{
            .fileIndex = fileIndex,
            .size = size,
        };
        try disk.append(block);
    }

    return disk;
}

fn calcChecksum(disk: std.ArrayList(Block), moveFileParts: bool) !u64 {
    var checksum: u64 = 0;
    var last: usize = if (disk.items.len % 2 == 0) disk.items.len - 2 else disk.items.len - 1;
    var numBlocks: usize = 0;

    for (0.., disk.items) |i, block| {
        const space = block.size;

        if (space == 0) {
            continue;
        }

        const isFree = i % 2 == 1;

        if (isFree) {
            for (0..space) |_| {
                if (moveFileParts) {
                    while (disk.items[last].size == 0) {
                        last -= 2;
                    }

                    if (last < i) {
                        break;
                    }

                    const fileIndex = disk.items[last].fileIndex;
                    checksum += numBlocks * fileIndex;
                    disk.items[last].size -= 1;
                }

                numBlocks += 1;
            }
        } else {
            const fileIndex = block.fileIndex;

            for (0..space) |_| {
                checksum += numBlocks * fileIndex;
                numBlocks += 1;
            }
        }
    }

    return checksum;
}

pub fn partOne(input: []const u8) !u64 {
    var disk = try parseDiskMap(input);
    defer disk.deinit();

    return calcChecksum(disk, true);
}

fn defragment(disk: *std.ArrayList(Block)) !void {
    var last: usize = if (disk.items.len % 2 == 0) disk.items.len - 2 else disk.items.len - 1;

    while (last > 0) {
        if (disk.items[last].defragmented) {
            last -= 2;
            continue;
        }

        disk.items[last].defragmented = true;

        var i: usize = 1;

        while (i < last and disk.items[i].size < disk.items[last].size) {
            i += 2;
        }

        if (i < last) {
            const freeSize = disk.items[i].size;
            const fileSize = disk.items[last].size;
            const hasFreeSpaceEntryAfterFile = last != disk.items.len - 1;

            if (hasFreeSpaceEntryAfterFile) {
                disk.items[last - 1].size += disk.items[last + 1].size;
                _ = disk.orderedRemove(last + 1);
            }

            if (i == last - 1) {
                try disk.insert(last + 1, Block{
                    .fileIndex = 0,
                    .size = disk.items[i].size,
                });
                disk.items[i].size = 0;
            } else {
                disk.items[i].size = 0;
                disk.items[last - 1].size += fileSize;
                const fileBlock = disk.orderedRemove(last);
                try disk.insert(i + 1, fileBlock);
                try disk.insert(i + 2, Block{
                    .fileIndex = 0,
                    .size = freeSize - fileSize,
                });
                last += 2;
            }
        }

        last -= 2;
        std.debug.assert(last % 2 == 0);
    }
}

fn printDisk(disk: std.ArrayList(Block)) void {
    std.debug.print("\n", .{});

    for (0.., disk.items) |i, block| {
        for (0..block.size) |_| {
            if (i % 2 == 0) {
                std.debug.print("{d}", .{block.fileIndex});
            } else {
                std.debug.print(".", .{});
            }
        }
    }

    std.debug.print("\n", .{});
}

pub fn partTwo(input: []const u8) !u64 {
    // TODO: some weird edge case that I cannot figure out makes this part not work with the main input albeit working for all examples in the test
    var disk = try parseDiskMap(input);
    defer disk.deinit();

    try defragment(&disk);

    return calcChecksum(disk, false);
}

test "nine part one" {
    try std.testing.expectEqual(60, partOne("12345"));
    try std.testing.expectEqual(1928, partOne("2333133121414131402"));
}

test "nine part two" {
    try std.testing.expectEqual(132, partTwo("12345"));
    try std.testing.expectEqual(31, partTwo("54321"));
    try std.testing.expectEqual(2858, partTwo("2333133121414131402"));
    try std.testing.expectEqual(1, partTwo("111"));
    try std.testing.expectEqual(1, partTwo("1110"));
    try std.testing.expectEqual(16, partTwo("14113"));
    try std.testing.expectEqual(5, partTwo("252"));
    try std.testing.expectEqual(1325, partTwo("354631466260"));
}
