#lang racket/base
(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-treesitter
  (ffi-lib "./zig-out/lib/libtree-sitter" '(#f)))

(define _TSParserRef (_cpointer 'TSParser))

(define-treesitter parser-new (_fun -> _TSParserRef)
  #:c-id ts_parser_new)
