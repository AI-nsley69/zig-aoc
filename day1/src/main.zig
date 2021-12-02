const std = @import("std");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const value_file = try std.fs.cwd().readFileAlloc(allocator, "./results.json", 1 << 24);
    var token_stream = std.json.TokenStream.init(value_file);
    const data = try std.json.parse(JsonData, &token_stream, .{ .allocator = allocator });
    std.debug.print("{s}\n", .{data});

    var i: u32 = 1;
    var total_increments: u32 = 0;
    while (i <= data.values.len - 1) : (i += 1) {
        total_increments += hasIncrement(data.values[i], data.values[i - 1]);
    }

    std.debug.print("{d} measurements larger than the previous.\n", .{total_increments});
}

pub fn hasIncrement(a: u32, b: u32) u32 {
    return @boolToInt(a > b);
}

const JsonData = struct {
    values: []const u32,
};

test "test against example results" {
    const results = [_]u32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    var i: u32 = 1;
    var total_increments: u32 = 0;
    while (i <= results.len - 1) : (i += 1) {
        total_increments += hasIncrement(results[i], results[i - 1]);
    }
    try std.testing.expect(7 == total_increments);
}
