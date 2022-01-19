# tree-sitter

This is a racket binding to tree-sitter.

### Installation

1. compile out shared lib

   ```shell
   # local build
   zig build
   # install to system path, here is macOS /usr/local/lib
   sudo zig build install --prefix-lib-dir /usr/local/lib
   ```

2. install racket lib

   ```shell
   raco pkg install --auto
   ```

### Testing

```
clang test.c -I./tree-sitter/lib/include ../tree-sitter-commonlisp/src/parser.c -ltree-sitter
```

- [tree-sitter-commonlisp](https://github.com/theHamsta/tree-sitter-commonlisp)
