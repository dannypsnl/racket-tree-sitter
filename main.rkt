#lang racket/base
(require ffi/unsafe
         ffi/unsafe/define
         "definer.rkt")

(define-ffi-definer define-ts-racket
  (ffi-lib "./zig-out/lib/libtree-sitter" '(#f)))
(define-ts-racket racket (_fun -> _TSLanguageRef)
  #:c-id tree_sitter_racket)

(define p (parser-new))
(set-language p (racket))

(define source-code "#lang racket
(+ 1 2)
")
(define tree (parse-string p #f source-code))

(define root (root-node tree))
(displayln (node->string root))

(tree-delete tree)
