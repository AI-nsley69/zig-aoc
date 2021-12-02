const std = @import("std");

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});
}

pub fn hasIncrement(a: u32, b: u32) u32 {
    return @boolToInt(a > b);
}

test "test against example results" {
    const results = [_]u32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    var i: u32 = 1;
    var total_increments: u32 = 0;
    while (i <= results.len - 1) : (i += 1) {
        total_increments += hasIncrement(results[i], results[i - 1]);
    }
    try std.testing.expect(7 == total_increments);
}
