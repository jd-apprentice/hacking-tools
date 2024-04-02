const std = @import("std");
const fs = std.fs;

const folders_to_create: [3][]const u8 = [3][]const u8{ "scripts", "scans", "files" };
const file_to_create: *const [9]u8 = "README.md";

fn makeDir(cwd: fs.Dir, folderName: []const u8) !void {
    try cwd.makeDir(folderName);
}

fn getFolderName(allocator: std.mem.Allocator) ![]const u8 {
    const args: [][]u8 = try std.process.argsAlloc(allocator);

    if (args.len < 2) {
        std.debug.print("{s}", .{"Missing folder name \n"});
        std.process.exit(1);
    }

    return args[1];
}

fn createFile(cwd: fs.Dir, fileName: []const u8) !fs.File {
    return try cwd.createFile(fileName, .{});
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator: std.mem.Allocator = arena.allocator();
    defer arena.deinit();

    const folderName: []const u8 = try getFolderName(allocator);
    const cwd: fs.Dir = fs.cwd();
    try makeDir(cwd, folderName);

    var newDir: fs.Dir = try cwd.openDir(folderName, .{});
    defer newDir.close();
    try newDir.setAsCwd();

    const newFile = try createFile(cwd, file_to_create);
    defer newFile.close();

    for (&folders_to_create) |folder| {
        try makeDir(cwd, folder);
    }
}
