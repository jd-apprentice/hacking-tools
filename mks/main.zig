const std = @import("std");
const fs = std.fs;

const folders_to_create = [_][]const u8{
    "scripts",
    "scans",
    "files",
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const folderName: [:0]u8 = args[1];
    const cwd = fs.cwd();
    try cwd.makeDir(folderName);

    // Move into the new directory
    var newDir = try cwd.openDir(folderName, .{});
    defer newDir.close();
    try newDir.setAsCwd();

    // Create the folders
    for (&folders_to_create) |folder| {
        try cwd.makeDir(folder);
    }
}
