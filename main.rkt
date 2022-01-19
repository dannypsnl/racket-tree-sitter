#lang racket/base
(require ffi/unsafe
         "definer.rkt")

(define-treesitter commonlisp (_fun -> _TSLanguageRef)
  #:c-id tree_sitter_commonlisp)

(define p (parser-new))
(set-language p (commonlisp))

(define source-code "(+ 1 2)")
(define tree (parse-string p #f source-code))

(define root (root-node tree))
(displayln (node->string root))

(tree-delete tree)
