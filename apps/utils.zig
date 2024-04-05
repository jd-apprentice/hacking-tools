const std = @import("std");

pub fn printLine() !void {
    std.debug.print("{s}", .{"\n"});
}

pub fn about(logo: [1][]const u8, message: []const u8) !void {
    try printLine();
    for (logo) |line| {
        std.debug.print("{s}\n", .{line});
    }
    std.debug.print("{s}", .{message});
    std.debug.print("{s}", .{"Made by jd-apprentice\n"});
}
