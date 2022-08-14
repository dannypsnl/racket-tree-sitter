# tree-sitter

This is a racket binding to tree-sitter.

### Installation

1. clone

   ```shell
   git clone https://github.com/dannypsnl/racket-tree-sitter.git
   ```

2. compile out shared lib

   ```shell
   # local build
   zig build
   # install to system path, here is macOS /usr/local/lib
   sudo zig build install --prefix-lib-dir /usr/local/lib
   ```

3. install racket lib

   ```shell
   raco pkg install --auto
   ```

### Testing

- [tree-sitter-commonlisp](https://github.com/theHamsta/tree-sitter-commonlisp)
