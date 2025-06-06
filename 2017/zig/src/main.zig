const std = @import("std");
const one = @import("one.zig");
const two = @import("two.zig");
const three = @import("three.zig");
const four = @import("four.zig");
const five = @import("five.zig");
const six = @import("six.zig");
const seven = @import("seven.zig");
const eight = @import("eight.zig");
const nine = @import("nine.zig");
const ten = @import("ten.zig");
const eleven = @import("eleven.zig");
const twelve = @import("twelve.zig");
const thirteen = @import("thirteen.zig");
const fourteen = @import("fourteen.zig");
const fifteen = @import("fifteen.zig");
const sixteen = @import("sixteen.zig");
const seventeen = @import("seventeen.zig");
const eighteen = @import("eighteen.zig");
const nineteen = @import("nineteen.zig");
const twenty = @import("twenty.zig");
const twentyone = @import("twentyone.zig");
const twentytwo = @import("twentytwo.zig");
const twentythree = @import("twentythree.zig");
const twentyfour = @import("twentyfour.zig");
const twentyfive = @import("twentyfive.zig");
const utils = @import("utils.zig");

pub const std_options: std.Options = .{
    .log_level = .info,
};

const Day = struct {
    num: u5,
    file: []const u8,
    partOne: *const fn ([]const u8) anyerror!u64,
    partTwo: *const fn ([]const u8) anyerror!u64,
};

const days = [_]Day{
    Day{
        .num = 1,
        .file = "../inputs/one.txt",
        .partOne = one.partOne,
        .partTwo = one.partTwo,
    },
    Day{
        .num = 2,
        .file = "../inputs/two.txt",
        .partOne = two.partOne,
        .partTwo = two.partTwo,
    },
    Day{
        .num = 3,
        .file = "../inputs/three.txt",
        .partOne = three.partOne,
        .partTwo = three.partTwo,
    },
    Day{
        .num = 4,
        .file = "../inputs/four.txt",
        .partOne = four.partOne,
        .partTwo = four.partTwo,
    },
    Day{
        .num = 5,
        .file = "../inputs/five.txt",
        .partOne = five.partOne,
        .partTwo = five.partTwo,
    },
    Day{
        .num = 6,
        .file = "../inputs/six.txt",
        .partOne = six.partOne,
        .partTwo = six.partTwo,
    },
    Day{
        .num = 7,
        .file = "../inputs/seven.txt",
        .partOne = seven.partOne,
        .partTwo = seven.partTwo,
    },
    Day{
        .num = 8,
        .file = "../inputs/eight.txt",
        .partOne = eight.partOne,
        .partTwo = eight.partTwo,
    },
    Day{
        .num = 9,
        .file = "../inputs/nine.txt",
        .partOne = nine.partOne,
        .partTwo = nine.partTwo,
    },
    Day{
        .num = 10,
        .file = "../inputs/ten.txt",
        .partOne = ten.partOne,
        .partTwo = ten.partTwo,
    },
    Day{
        .num = 11,
        .file = "../inputs/eleven.txt",
        .partOne = eleven.partOne,
        .partTwo = eleven.partTwo,
    },
    Day{
        .num = 12,
        .file = "../inputs/twelve.txt",
        .partOne = twelve.partOne,
        .partTwo = twelve.partTwo,
    },
    Day{
        .num = 13,
        .file = "../inputs/thirteen.txt",
        .partOne = thirteen.partOne,
        .partTwo = thirteen.partTwo,
    },
    Day{
        .num = 14,
        .file = "../inputs/fourteen.txt",
        .partOne = fourteen.partOne,
        .partTwo = fourteen.partTwo,
    },
    Day{
        .num = 15,
        .file = "../inputs/fifteen.txt",
        .partOne = fifteen.partOne,
        .partTwo = fifteen.partTwo,
    },
    Day{
        .num = 16,
        .file = "../inputs/sixteen.txt",
        .partOne = sixteen.partOne,
        .partTwo = sixteen.partTwo,
    },
    Day{
        .num = 17,
        .file = "../inputs/seventeen.txt",
        .partOne = seventeen.partOne,
        .partTwo = seventeen.partTwo,
    },
    Day{
        .num = 18,
        .file = "../inputs/eighteen.txt",
        .partOne = eighteen.partOne,
        .partTwo = eighteen.partTwo,
    },
    Day{
        .num = 19,
        .file = "../inputs/nineteen.txt",
        .partOne = nineteen.partOne,
        .partTwo = nineteen.partTwo,
    },
    Day{
        .num = 20,
        .file = "../inputs/twenty.txt",
        .partOne = twenty.partOne,
        .partTwo = twenty.partTwo,
    },
    Day{
        .num = 21,
        .file = "../inputs/twentyone.txt",
        .partOne = twentyone.partOne,
        .partTwo = twentyone.partTwo,
    },
    Day{
        .num = 22,
        .file = "../inputs/twentytwo.txt",
        .partOne = twentytwo.partOne,
        .partTwo = twentytwo.partTwo,
    },
    Day{
        .num = 23,
        .file = "../inputs/twentythree.txt",
        .partOne = twentythree.partOne,
        .partTwo = twentythree.partTwo,
    },
    Day{
        .num = 24,
        .file = "../inputs/twentyfour.txt",
        .partOne = twentyfour.partOne,
        .partTwo = twentyfour.partTwo,
    },
    Day{
        .num = 25,
        .file = "../inputs/twentyfive.txt",
        .partOne = twentyfive.partOne,
        .partTwo = twentyfive.partTwo,
    },
};

const Result = struct {
    day: u64,
    partOne: u64,
    timeOne: u64,
    partTwo: u64,
    timeTwo: u64,
};

fn printResultsTable(results: []const Result) !void {
    var tbl = utils.Table().init(utils.allocator);
    defer tbl.deinit();
    var headers = [_][]const u8{""} ** 5;
    headers[0] = "Day";
    headers[1] = "Part 1";
    headers[2] = "Time";
    headers[3] = "Part 2";
    headers[4] = "Time";
    try tbl.setHeaders(&headers);

    for (results) |result| {
        var row = try utils.allocator.alloc([]u8, 5);
        row[0] = try std.fmt.allocPrint(utils.allocator, "{}", .{result.day});
        row[1] = try std.fmt.allocPrint(utils.allocator, "{}", .{result.partOne});
        row[2] = try std.fmt.allocPrint(utils.allocator, "{}", .{std.fmt.fmtDuration(result.timeOne)});
        row[3] = try std.fmt.allocPrint(utils.allocator, "{}", .{result.partTwo});
        row[4] = try std.fmt.allocPrint(utils.allocator, "{}", .{std.fmt.fmtDuration(result.timeTwo)});
        try tbl.addRow(row);
    }

    try tbl.print();
}

pub fn main() !void {
    var buffer: [30000]u8 = undefined;
    var results = std.ArrayList(Result).init(utils.allocator);
    defer results.deinit();
    var args = std.process.args();
    _ = args.skip();
    var daysToShow = std.AutoHashMap(u64, void).init(utils.allocator);
    defer daysToShow.deinit();

    while (args.next()) |str| {
        const num = try std.fmt.parseInt(u64, str, 10);
        try daysToShow.put(num, {});
    }

    for (days) |day| {
        if (daysToShow.count() > 0 and !daysToShow.contains(day.num)) {
            continue;
        }

        const input = try std.fs.cwd().readFile(day.file, &buffer);
        const start: i128 = std.time.nanoTimestamp();
        const resultOne = try day.partOne(input);
        const mid: i128 = std.time.nanoTimestamp();
        const resultTwo = try day.partTwo(input);
        const end: i128 = std.time.nanoTimestamp();

        const timeOne: i64 = @truncate(mid - start);
        const timeTwo: i64 = @truncate(end - mid);

        try results.append(Result{
            .day = @as(u64, day.num),
            .partOne = resultOne,
            .timeOne = @bitCast(timeOne),
            .partTwo = resultTwo,
            .timeTwo = @bitCast(timeTwo),
        });
    }

    try printResultsTable(results.items);
}
