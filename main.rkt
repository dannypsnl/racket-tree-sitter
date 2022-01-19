#lang racket/base
(require ffi/unsafe
         ffi/unsafe/alloc
         "definer.rkt")

(define-treesitter commonlisp (_fun -> _TSLanguageRef)
  #:c-id tree_sitter_commonlisp)

(define make-parser ((allocator parser-delete) parser-new))

(define p (make-parser))
(set-language p (commonlisp))

(define source-code "(+ 1 2)")
(define tree (parse-string p #f source-code))

(define root (root-node tree))
(displayln (node->string root))

(tree-delete tree)
