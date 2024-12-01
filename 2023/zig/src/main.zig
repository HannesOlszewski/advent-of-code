const std = @import("std");
const one = @import("one.zig");

pub fn main() !void {
    const start: i64 = std.time.milliTimestamp();
    var buffer: [30000]u8 = undefined;
    const input = try std.fs.cwd().readFile("../shared/one.txt", &buffer);
    const resultOne = try one.partOne(input);
    const resultTwo = try one.partTwo(input);
    const end: i64 = std.time.milliTimestamp();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Day 1: {d} | {d} | in {d}ms\n", .{ resultOne, resultTwo, end - start });

    try bw.flush();
}
