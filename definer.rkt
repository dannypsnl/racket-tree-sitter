#lang racket/base
(provide define-treesitter
         custom-search-dirs)
(require ffi/unsafe
         ffi/unsafe/define
         setup/dirs)

(define custom-search-dirs (make-parameter '()))

(define (get-lib-dir)
  (append '("/usr/lib" "/usr/local/lib")
          (custom-search-dirs)
          (get-lib-search-dirs)))
(define-ffi-definer define-treesitter
  (ffi-lib "libtree-sitter" '(#f)
           #:get-lib-dirs get-lib-dir))
