const std = @import("std");
const _2025 = @import("_2025");

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    const gpa = std.heap.page_allocator;

    for (_2025.days) |day| {
        const result = try _2025.runDayWithMetrics(gpa, day);

        if (!result.skipped) {
            try stdout.print("Day {s} part {s}: {s} (took {s})\n", .{ day.name, "1", result.part_one_result, result.part_one_time });
            try stdout.print("Day {s} part {s}: {s} (took {s})\n", .{ day.name, "2", result.part_two_result, result.part_two_time });
            try stdout.flush();
        }
    }
}
