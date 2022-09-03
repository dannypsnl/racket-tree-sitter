const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const lib = b.addSharedLibrary("tree-sitter", null, .unversioned);
    const flags = [_][]const u8{
        "-std=c99",
        "-Wno-unused-parameter",
    };
    const cxx_flags = [_][]const u8{
        "-std=c++17",
        "-Wno-unused-parameter",
    };

    lib.addIncludeDir("./tree-sitter/lib/include/");
    lib.addIncludeDir("./tree-sitter/lib/src/");
    lib.addCSourceFile("./tree-sitter/lib/src/lib.c", &flags);
    lib.setBuildMode(mode);
    lib.install();

    const lib_racket = b.addSharedLibrary("tree-sitter-racket", null, .unversioned);
    lib_racket.addIncludeDir("./tree-sitter/lib/include/");
    lib_racket.linkLibCpp();
    lib_racket.addCSourceFiles(&[_][]const u8{
        "./tree-sitter-racket/src/parser.c",
    }, &flags);
    lib_racket.addCSourceFiles(&[_][]const u8{
        "./tree-sitter-racket/src/scanner.cc",
    }, &cxx_flags);
    lib_racket.setBuildMode(mode);
    lib_racket.install();
}
