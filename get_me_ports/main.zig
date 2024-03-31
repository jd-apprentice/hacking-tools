const std = @import("std");

const ignoredPhrases = [_][]const u8{
    "#",
    "Nmap scan report for",
    "Host is up",
    "Other addresses for",
    "Not shown:",
};

pub fn getFile() !std.fs.File {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const filename: [:0]u8 = args[1];
    const file = try std.fs.cwd().openFile(filename, .{});

    return file;
}

pub fn main() !void {
    var file = try getFile();
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            continue;
        }

        var shouldSkip = false;
        for (ignoredPhrases) |phrase| {
            if (std.mem.indexOf(u8, line, phrase) != null) {
                shouldSkip = true;
                break;
            }
        }

        if (shouldSkip) {
            continue;
        }

        std.debug.print("{s}\n", .{line});
    }
}
