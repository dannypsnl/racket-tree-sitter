const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const lib = b.addSharedLibrary("tree-sitter", null, .unversioned);
    const flags = [_][]const u8{
        "-std=c99",
        "-Wno-unused-parameter",
    };
    lib.addIncludeDir("./tree-sitter/lib/include/");
    lib.addIncludeDir("./tree-sitter/lib/src/");
    lib.addCSourceFile("./tree-sitter/lib/src/lib.c", &flags);
    // lib.addCSourceFile("../tree-sitter-commonlisp/src/parser.c", &flags);
    lib.setBuildMode(mode);

    lib.install();
}
