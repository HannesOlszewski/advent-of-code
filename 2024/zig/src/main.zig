const std = @import("std");
const one = @import("one.zig");
const two = @import("two.zig");
const three = @import("three.zig");
const four = @import("four.zig");
const five = @import("five.zig");
const six = @import("six.zig");
const seven = @import("seven.zig");
const eight = @import("eight.zig");
const utils = @import("utils.zig");

pub const std_options = .{
    .log_level = .info,
};

const Day = struct {
    file: []const u8,
    partOne: *const fn ([]const u8) anyerror!u64,
    partTwo: *const fn ([]const u8) anyerror!u64,
};

const days = [_]Day{ Day{
    .file = "../inputs/one.txt",
    .partOne = one.partOne,
    .partTwo = one.partTwo,
}, Day{
    .file = "../inputs/two.txt",
    .partOne = two.partOne,
    .partTwo = two.partTwo,
}, Day{
    .file = "../inputs/three.txt",
    .partOne = three.partOne,
    .partTwo = three.partTwo,
}, Day{
    .file = "../inputs/four.txt",
    .partOne = four.partOne,
    .partTwo = four.partTwo,
}, Day{
    .file = "../inputs/five.txt",
    .partOne = five.partOne,
    .partTwo = five.partTwo,
}, Day{
    .file = "../inputs/six.txt",
    .partOne = six.partOne,
    .partTwo = six.partTwo,
}, Day{
    .file = "../inputs/seven.txt",
    .partOne = seven.partOne,
    .partTwo = seven.partTwo,
}, Day{
    .file = "../inputs/eight.txt",
    .partOne = eight.partOne,
    .partTwo = eight.partTwo,
} };

const Result = struct {
    partOne: u64,
    timeOne: i64,
    partTwo: u64,
    timeTwo: i64,
};

fn printResultsTable(results: []const Result) !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var resOneLen: usize = 0;
    var timeOneLen: usize = 0;
    var resTwoLen: usize = 0;
    var timeTwoLen: usize = 0;

    for (results) |result| {
        var buf: [256]u8 = undefined;
        var len = (try std.fmt.bufPrint(&buf, "{}", .{result.partOne})).len;
        if (resOneLen < len) {
            resOneLen = len;
        }

        len = (try std.fmt.bufPrint(&buf, "{}", .{result.timeOne})).len;
        if (timeOneLen < len) {
            timeOneLen = len;
        }

        len = (try std.fmt.bufPrint(&buf, "{}", .{result.partTwo})).len;
        if (resTwoLen < len) {
            resTwoLen = len;
        }

        len = (try std.fmt.bufPrint(&buf, "{}", .{result.timeTwo})).len;
        if (timeTwoLen < len) {
            timeTwoLen = len;
        }
    }

    try stdout.print("+-----+-----------------+-----------+-----------------+-----------+\n", .{});
    try stdout.print("| Day | Part One Result | Time (μs) | Part Two Result | Time (μs) |\n", .{});
    try stdout.print("+-----+-----------------+-----------+-----------------+-----------+\n", .{});

    for (0.., results) |i, result| {
        const dayNum = i + 1;

        if (dayNum < 10) {
            try stdout.print("|   {} | ", .{dayNum});
        } else {
            try stdout.print("|  {} | ", .{dayNum});
        }

        var buf: [256]u8 = undefined;
        var len = (try std.fmt.bufPrint(&buf, "{}", .{result.partOne})).len;
        while (len < resOneLen or len < "Part One Result".len) {
            try stdout.print(" ", .{});
            len += 1;
        }
        try stdout.print("{} | ", .{result.partOne});

        len = (try std.fmt.bufPrint(&buf, "{}", .{result.timeOne})).len;
        while (len < timeOneLen or len < "Time (μs)".len - 1) {
            try stdout.print(" ", .{});
            len += 1;
        }
        try stdout.print("{} | ", .{result.timeOne});

        len = (try std.fmt.bufPrint(&buf, "{}", .{result.partTwo})).len;
        while (len < resTwoLen or len < "Part Two Result".len) {
            try stdout.print(" ", .{});
            len += 1;
        }
        try stdout.print("{} | ", .{result.partTwo});

        len = (try std.fmt.bufPrint(&buf, "{}", .{result.timeTwo})).len;
        while (len < timeTwoLen or len < "Time (μs)".len - 1) {
            try stdout.print(" ", .{});
            len += 1;
        }
        try stdout.print("{} |\n", .{result.timeTwo});
    }

    try stdout.print("+-----+-----------------+-----------+-----------------+-----------+\n", .{});
    try bw.flush();
}

pub fn main() !void {
    var buffer: [30000]u8 = undefined;
    var results = std.ArrayList(Result).init(utils.allocator);
    defer results.deinit();

    for (days) |day| {
        const input = try std.fs.cwd().readFile(day.file, &buffer);
        const start: i64 = std.time.microTimestamp();
        const resultOne = try day.partOne(input);
        const mid: i64 = std.time.microTimestamp();
        const resultTwo = try day.partTwo(input);
        const end: i64 = std.time.microTimestamp();

        try results.append(Result{
            .partOne = resultOne,
            .timeOne = mid - start,
            .partTwo = resultTwo,
            .timeTwo = end - mid,
        });
    }

    try printResultsTable(results.items);
}
