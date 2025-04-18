const std = @import("std");
const utils = @import("utils.zig");

fn parseMemoryBanks(input: []const u8) ![]u8 {
    var numbers = std.mem.splitAny(u8, input, "\t\n");
    var memoryBanks = std.ArrayList(u8).init(utils.allocator);

    while (numbers.next()) |num| {
        if (num.len == 0) {
            continue;
        }

        const blocks = try std.fmt.parseInt(u8, num, 10);
        try memoryBanks.append(blocks);
    }

    return try memoryBanks.toOwnedSlice();
}

fn reallocateRound(memoryBanks: *[]u8) void {
    var i = std.mem.indexOfMax(u8, memoryBanks.*);
    var blocksToReallocate = memoryBanks.*[i];
    memoryBanks.*[i] = 0;

    while (blocksToReallocate > 0) {
        i = (i + 1) % memoryBanks.*.len;
        blocksToReallocate -= 1;
        memoryBanks.*[i] += 1;
    }
}

fn identifyBanksState(memoryBanks: []u8) u64 {
    var state: u64 = 0;

    for (1.., memoryBanks) |i, blocks| {
        state += @as(u64, blocks) * std.math.pow(u64, 10, i);
    }

    return state;
}

pub fn partOne(input: []const u8) !u64 {
    var memoryBanks = try parseMemoryBanks(input);
    defer utils.allocator.free(memoryBanks);
    var steps: u64 = 0;
    var encounteredStates = std.AutoHashMap(u64, void).init(utils.allocator);
    defer encounteredStates.deinit();
    try encounteredStates.put(identifyBanksState(memoryBanks), {});

    while (true) {
        steps += 1;
        reallocateRound(&memoryBanks);
        const newState = identifyBanksState(memoryBanks);

        if (encounteredStates.contains(newState)) {
            break;
        }

        try encounteredStates.put(newState, {});
    }

    return steps;
}

test "six part one" {
    try std.testing.expectEqual(5, partOne("0\t2\t7\t0"));
}

pub fn partTwo(input: []const u8) !u64 {
    var memoryBanks = try parseMemoryBanks(input);
    defer utils.allocator.free(memoryBanks);
    var steps: u64 = 0;
    var encounteredStates = std.AutoHashMap(u64, u64).init(utils.allocator);
    defer encounteredStates.deinit();
    try encounteredStates.put(identifyBanksState(memoryBanks), 0);
    var loopLength: u64 = 0;

    while (true) {
        steps += 1;
        reallocateRound(&memoryBanks);
        const newState = identifyBanksState(memoryBanks);

        if (encounteredStates.contains(newState)) {
            loopLength = steps - (encounteredStates.get(newState) orelse 0);
            break;
        }

        try encounteredStates.put(newState, steps);
    }

    return loopLength;
}

test "six part two" {
    try std.testing.expectEqual(4, partTwo("0\t2\t7\t0"));
}
