const std = @import("std");
const one = @import("one.zig");
const two = @import("two.zig");

pub const std_options = .{
    .log_level = .info,
};

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var buffer: [30000]u8 = undefined;
    var input = try std.fs.cwd().readFile("../inputs/one.txt", &buffer);
    var start: i64 = std.time.microTimestamp();
    var resultOne = try one.partOne(input);
    var mid: i64 = std.time.microTimestamp();
    var resultTwo = try one.partTwo(input);
    var end: i64 = std.time.microTimestamp();
    try stdout.print("Day 1: {d} in {d}us | {d} in {d}us\n", .{ resultOne, mid - start, resultTwo, end - mid });
    try bw.flush();

    buffer = undefined;
    input = try std.fs.cwd().readFile("../inputs/two.txt", &buffer);
    start = std.time.microTimestamp();
    resultOne = try two.partOne(input);
    mid = std.time.microTimestamp();
    resultTwo = try two.partTwo(input);
    end = std.time.microTimestamp();
    try stdout.print("Day 2: {d} in {d}us | {d} in {d}us\n", .{ resultOne, mid - start, resultTwo, end - mid });
    try bw.flush();
}
