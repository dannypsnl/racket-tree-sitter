#lang racket/base
(provide (all-from-out
          "types.rkt"
          "language.rkt"
          "parser.rkt"
          "node.rkt"
          "tree.rkt"
          "tree-cursor.rkt"
          "query.rkt"
          "query-cursor.rkt"))
(require "types.rkt"
         "language.rkt"
         "parser.rkt"
         "node.rkt"
         "tree.rkt"
         "tree-cursor.rkt"
         "query.rkt"
         "query-cursor.rkt")

(module+ main
  (require ffi/unsafe
           ffi/unsafe/define)

  (define-ffi-definer define-commonlisp
    (ffi-lib "./zig-out/lib/libtree-sitter-commonlisp" '(#f)))

  (define-commonlisp cl-language (_fun -> _TSLanguageRef)
    #:c-id tree_sitter_commonlisp)

  (define p (parser-new))
  (set-language p (cl-language))

  (define source-code "
(+ 1 2)
")
  (define tree (parse-string p #f source-code))

  (define root (root-node tree))
  (displayln (node->string root))

  (tree-delete tree))
