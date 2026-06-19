const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const c_flags = [_][]const u8{
        "-std=c99",
        "-Wno-unused-parameter",
    };
    const cxx_flags = [_][]const u8{
        "-std=c++17",
        "-Wno-unused-parameter",
    };

    // libtree-sitter
    const ts_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    ts_mod.addIncludePath(b.path("tree-sitter/lib/include"));
    ts_mod.addIncludePath(b.path("tree-sitter/lib/src"));
    ts_mod.addCSourceFile(.{
        .file = b.path("tree-sitter/lib/src/lib.c"),
        .flags = &c_flags,
    });
    const lib = b.addLibrary(.{
        .name = "tree-sitter",
        .linkage = .dynamic,
        .root_module = ts_mod,
    });
    b.installArtifact(lib);

    // libtree-sitter-racket grammar
    const racket_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });
    racket_mod.addIncludePath(b.path("tree-sitter/lib/include"));
    racket_mod.addCSourceFile(.{
        .file = b.path("tree-sitter-racket/src/parser.c"),
        .flags = &c_flags,
    });
    racket_mod.addCSourceFile(.{
        .file = b.path("tree-sitter-racket/src/scanner.cc"),
        .flags = &cxx_flags,
    });
    const lib_racket = b.addLibrary(.{
        .name = "tree-sitter-racket",
        .linkage = .dynamic,
        .root_module = racket_mod,
    });
    b.installArtifact(lib_racket);
}
