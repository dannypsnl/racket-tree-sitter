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

  (define-ffi-definer define-racket
    (ffi-lib "./zig-out/lib/libtree-sitter-racket" '(#f)))

  (define-racket rkt-language (_fun -> _TSLanguageRef)
    #:c-id tree_sitter_racket)

  (define p (parser-new))
  (set-language p (rkt-language))

  (define source-code "
(+ 1 2)
(define x 1)
(define (foo a b)
  (+ a b x))
")
  (define tree (parse-string p #f source-code))

  (define root (root-node tree))
  (displayln (node->string root))

  (tree-delete tree))
