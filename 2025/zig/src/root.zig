const std = @import("std");

fn partNotImplementYet(_: []const u8) ![]const u8 {
    return "not implemented yet";
}

pub const Day = struct {
    name: []const u8,
    part_one: *const fn ([]const u8) error{}![]const u8,
    part_two: *const fn ([]const u8) error{}![]const u8,
};

const DayRunResult = struct {
    skipped: bool = false,
    part_one_result: []const u8 = "",
    part_one_time: [8]u8 = .{0} ** 8,
    part_two_result: []const u8 = "",
    part_two_time: [8]u8 = .{0} ** 8,
};

const TIME_UNITS = [_][]const u8{ "ns", "μs", "ms", "s" };

pub const days = [_]Day{
    .{ .name = "1", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "2", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "3", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "4", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "5", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "6", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "7", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "8", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "9", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "10", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "11", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
    .{ .name = "12", .part_one = partNotImplementYet, .part_two = partNotImplementYet },
};

pub fn runDayWithMetrics(allocator: std.mem.Allocator, day: Day) !DayRunResult {
    const input = loadInputFile(allocator, day) catch {
        return .{ .skipped = true };
    };
    defer allocator.free(input);

    const timestamp_start_ns = std.time.nanoTimestamp();
    const result_part_one = day.part_one(input) catch "";
    const timestamp_after_part_one_ns = std.time.nanoTimestamp();
    const result_part_two = day.part_two(input) catch "";
    const timestamp_after_part_two_ns = std.time.nanoTimestamp();

    const part_one_time_ns = timestamp_after_part_one_ns - timestamp_start_ns;
    var part_one_time: f32 = @floatFromInt(part_one_time_ns);
    var part_one_unit_index: u4 = 0;
    while (part_one_time >= 1000 and part_one_unit_index < TIME_UNITS.len - 1) {
        part_one_time /= 1000;
        part_one_unit_index += 1;
    }
    std.debug.assert(part_one_unit_index >= 0 and part_one_unit_index < TIME_UNITS.len);

    var part_one_time_with_unit: [8]u8 = undefined;
    const tmp_part_one_time = std.fmt.bufPrint(&part_one_time_with_unit, "{d}{s}", .{ part_one_time, TIME_UNITS[part_one_unit_index] }) catch "?s";
    // Overwrite all non-written bytes with 0 so they won't be printed
    for (tmp_part_one_time.len..part_one_time_with_unit.len) |i| {
        part_one_time_with_unit[i] = 0;
    }

    const part_two_time_ns = timestamp_after_part_two_ns - timestamp_after_part_one_ns;
    var part_two_time: f32 = @floatFromInt(part_two_time_ns);
    var part_two_unit_index: u4 = 0;
    while (part_two_time >= 1000 and part_two_unit_index < TIME_UNITS.len - 1) {
        part_two_time /= 1000;
        part_two_unit_index += 1;
    }
    std.debug.assert(part_two_unit_index >= 0 and part_two_unit_index < TIME_UNITS.len);

    var part_two_time_with_unit: [8]u8 = undefined;
    const tmp_part_two_time = std.fmt.bufPrint(&part_two_time_with_unit, "{d}{s}", .{ part_two_time, TIME_UNITS[part_two_unit_index] }) catch "?s";
    // Overwrite all non-written bytes with 0 so they won't be printed
    for (tmp_part_two_time.len..part_two_time_with_unit.len) |i| {
        part_two_time_with_unit[i] = 0;
    }

    return .{
        .part_one_result = result_part_one,
        .part_one_time = part_one_time_with_unit,
        .part_two_result = result_part_two,
        .part_two_time = part_two_time_with_unit,
    };
}

test "runDayWithMetrics" {
    const day: Day = .{ .name = "1", .part_one = partNotImplementYet, .part_two = partNotImplementYet };

    const result = runDayWithMetrics(std.testing.allocator, day);

    try std.testing.expectEqualStrings("not implemented yet", result.part_one_result);
    try std.testing.expectEqualStrings("not implemented yet", result.part_two_result);
}

pub fn loadInputFile(allocator: std.mem.Allocator, day: Day) ![]const u8 {
    const file_path = try std.fmt.allocPrint(allocator, "../shared/{s}.txt", .{day.name});
    const file_content = try std.fs.cwd().readFileAlloc(allocator, file_path, 1024);

    return file_content;
}
