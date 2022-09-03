# tree-sitter

This is a racket binding to tree-sitter.

### Installation

The installation is a little complicated, but this is normal because this is a FFI library.

#### Racket library

For Racket part, you just need below command.

```shell
raco pkg install --auto racket-tree-sitter
```

#### tree-sitter

For tree-sitter shared library, you can install it manually or follow the following steps.

1. clone repo and init submodules

   ```shell
   git clone https://github.com/dannypsnl/racket-tree-sitter.git
   git submodule update --init
   ```

2. compile out shared lib

   ```shell
   # local build
   zig build
   # install to somewhere, here I choose macOS /usr/local/lib
   sudo zig build install --prefix-lib-dir /usr/local/lib
   ```

### Development

If you interest about developing this tree-sitter binding, once you clone repo and init submodules, the code in `main.rkt` should have an example that uses [tree-sitter-racket](https://github.com/6cdh/tree-sitter-racket).
