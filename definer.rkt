#lang racket/base
(provide define-treesitter)
(require ffi/unsafe
         ffi/unsafe/define)

(define (get-lib-dir)
  (list "/usr/local/lib"))
(define-ffi-definer define-treesitter
  (ffi-lib "libtree-sitter" '(#f)
           #:get-lib-dirs get-lib-dir))
