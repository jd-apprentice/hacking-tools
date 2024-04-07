const std = @import("std");
const utils = @import("utils.zig");

const ignoredPhrases = [_][]const u8{ "#", "Nmap scan report for", "Host is up", "Other addresses for", "Not shown:", "Service Info: ", "Service detection performed", "filtered", "warning" };
const logo = [_][]const u8{
    \\   ▄████ ▓█████▄▄▄█████▓    ███▄ ▄███▓▓█████     ██▓███   ▒█████   ██▀███  ▄▄▄█████▓  ██████
    \\  ██▒ ▀█▒▓█   ▀▓  ██▒ ▓▒   ▓██▒▀█▀ ██▒▓█   ▀    ▓██░  ██▒▒██▒  ██▒▓██ ▒ ██▒▓  ██▒ ▓▒▒██    ▒
    \\ ▒██░▄▄▄░▒███  ▒ ▓██░ ▒░   ▓██    ▓██░▒███      ▓██░ ██▓▒▒██░  ██▒▓██ ░▄█ ▒▒ ▓██░ ▒░░ ▓██▄
    \\ ░▓█  ██▓▒▓█  ▄░ ▓██▓ ░    ▒██    ▒██ ▒▓█  ▄    ▒██▄█▓▒ ▒▒██   ██░▒██▀▀█▄  ░ ▓██▓ ░   ▒   ██▒
    \\ ░▒▓███▀▒░▒████▒ ▒██▒ ░    ▒██▒   ░██▒░▒████▒   ▒██▒ ░  ░░ ████▓▒░░██▓ ▒██▒  ▒██▒ ░ ▒██████▒▒
    \\  ░▒   ▒ ░░ ▒░ ░ ▒ ░░      ░ ▒░   ░  ░░░ ▒░ ░   ▒▓▒░ ░  ░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░  ▒ ░░   ▒ ▒▓▒ ▒ ░
    \\   ░   ░  ░ ░  ░   ░       ░  ░      ░ ░ ░  ░   ░▒ ░       ░ ▒ ▒░   ░▒ ░ ▒░    ░    ░ ░▒  ░ ░
    \\ ░ ░   ░    ░    ░         ░      ░      ░      ░░       ░ ░ ░ ▒    ░░   ░   ░      ░  ░  ░
    \\       ░    ░  ░                  ░      ░  ░                ░ ░     ░                    ░
};

fn getFile() !std.fs.File {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator: std.mem.Allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("{s}", .{"Usage: get-me-ports <filename>\n"});
        std.process.exit(1);
    }

    const filename: [:0]u8 = args[1];
    const file: std.fs.File = try std.fs.cwd().openFile(filename, .{});

    return file;
}

pub fn main() !void {
    try utils.about(logo, "\nUtility tool to parse nmap files and get open ports\n");
    try utils.printLine();

    var file: std.fs.File = try getFile();
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            continue;
        }

        var shouldSkip: bool = false;
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
