const std = @import("std");
const builtin = @import("builtin");

const TestDebugOutput = false;

pub fn debug(comptime fmt: []const u8, args: anytype) void {
    if (builtin.is_test and TestDebugOutput) {
        std.debug.print(fmt ++ "\n", args);
    } else {
        std.log.debug(fmt, args);
    }
}
