const std = @import("std");
const builtin = @import("builtin");

const TestDebugOutput = true;

pub fn debug(comptime fmt: []const u8, args: anytype) void {
    if (builtin.is_test and TestDebugOutput) {
        std.debug.print(fmt ++ "\n", args);
    } else {
        std.log.debug(fmt, args);
    }
}

pub const allocator = if (builtin.is_test) std.testing.allocator else std.heap.page_allocator;

pub fn Table() type {
    return struct {
        const Self = @This();

        headers: [][]u8,
        data: std.ArrayList([][]u8),
        columnWidths: []usize,
        width: usize,
        alloc: std.mem.Allocator,

        pub fn init(alloc: std.mem.Allocator) Self {
            return Self{
                .headers = &.{},
                .data = std.ArrayList([][]u8).init(alloc),
                .columnWidths = &.{},
                .width = 1,
                .alloc = alloc,
            };
        }

        pub fn deinit(self: Self) void {
            if (self.headers.len > 0) {
                self.alloc.free(self.headers);
            }

            if (self.columnWidths.len > 0) {
                self.alloc.free(self.columnWidths);
            }

            self.data.deinit();
        }

        pub fn setHeaders(self: *Self, headers: [][]const u8) !void {
            self.headers = try self.alloc.alloc([]u8, headers.len);
            self.columnWidths = try self.alloc.alloc(usize, headers.len);

            self.width = 1;
            for (0.., headers) |i, header| {
                self.headers[i] = try self.alloc.alloc(u8, header.len);
                std.mem.copyForwards(u8, self.headers[i], header);
                self.columnWidths[i] = header.len;
                // 3 = 2 for whitespace padding and 1 for column separator
                self.width += header.len + 3;
            }
        }

        pub fn addRow(self: *Self, row: [][]u8) !void {
            std.debug.assert(row.len == self.headers.len);
            std.debug.assert(row.len == self.columnWidths.len);
            try self.data.append(row);

            self.width = 1;
            for (0.., row) |i, cell| {
                if (self.columnWidths[i] < cell.len) {
                    self.columnWidths[i] = cell.len;
                }

                // 3 = 2 for whitespace padding and 1 for column separator
                self.width += self.columnWidths[i] + 3;
            }
        }

        pub fn print(self: *Self) !void {
            const stdout_file = std.io.getStdOut().writer();
            var bw = std.io.bufferedWriter(stdout_file);
            const stdout = bw.writer();

            // Top edge
            try stdout.print("┌", .{});
            for (0.., self.columnWidths) |i, w| {
                if (i > 0) {
                    try stdout.print("┬", .{});
                }

                for (0..w + 2) |_| {
                    try stdout.print("─", .{});
                }
            }
            try stdout.print("┐\n", .{});

            // Headers
            for (0.., self.columnWidths) |i, w| {
                try stdout.print("\x1b[0m│\x1b[1m", .{});

                for (0..w + 2) |j| {
                    if (j == 0 or j == w + 1) {
                        try stdout.print(" ", .{});
                    } else {
                        const strIndex = j - 1;

                        if (strIndex < self.headers[i].len) {
                            try stdout.print("{c}", .{self.headers[i][strIndex]});
                        } else {
                            try stdout.print(" ", .{});
                        }
                    }
                }
            }
            try stdout.print("\x1b[0m│\n", .{});

            // Mid edge
            try stdout.print("├", .{});
            for (0.., self.columnWidths) |i, w| {
                if (i > 0) {
                    try stdout.print("┼", .{});
                }

                for (0..w + 2) |_| {
                    try stdout.print("─", .{});
                }
            }
            try stdout.print("┤\n", .{});

            // Rows
            for (self.data.items) |row| {
                for (0.., self.columnWidths) |i, w| {
                    try stdout.print("│", .{});

                    for (0..w + 2) |j| {
                        if (j == 0) {
                            const color: u3 = if (i == 0) 7 else 3;
                            try stdout.print(" \x1b[3{d}m", .{color});
                        } else if (j == w + 1) {
                            try stdout.print("\x1b[0m ", .{});
                        } else {
                            const strIndex = j - 1;

                            if (strIndex < w - row[i].len) {
                                try stdout.print(" ", .{});
                            } else {
                                try stdout.print("{c}", .{row[i][strIndex - (w - row[i].len)]});
                            }
                        }
                    }
                }
                try stdout.print("│\n", .{});
            }

            // Bottom edge
            try stdout.print("└", .{});
            for (0.., self.columnWidths) |i, w| {
                if (i > 0) {
                    try stdout.print("┴", .{});
                }

                for (0..w + 2) |_| {
                    try stdout.print("─", .{});
                }
            }
            try stdout.print("┘\n", .{});

            try bw.flush();
        }
    };
}
