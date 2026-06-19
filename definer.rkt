#lang racket/base
(provide define-treesitter
         custom-search-dirs)
(require ffi/unsafe
         ffi/unsafe/define
         setup/dirs)

(define custom-search-dirs (make-parameter '()))

(define (get-lib-dir)
  (append '("/usr/lib" "/usr/local/lib"
            ;; macOS Homebrew
            "/opt/homebrew/opt/tree-sitter/lib" "/opt/homebrew/lib"
            "/usr/local/opt/tree-sitter/lib")
          ;; from environment variable
          (let ([d (getenv "TREE_SITTER_LIB_DIR")]) (if d (list d) '()))
          (custom-search-dirs)
          (get-lib-search-dirs)))
;; `make-not-available` makes a binding for a missing C symbol fail only when
;; it is *called*, not at module load. tree-sitter's ABI drops/renames symbols
;; across versions (e.g. ts_language_version removed in 0.26), so binding every
;; symbol eagerly would break `require` on a mismatched libtree-sitter. With
;; this, only actual use of an absent function errors.
(define-ffi-definer define-treesitter
  (ffi-lib "libtree-sitter" '(#f)
           #:get-lib-dirs get-lib-dir)
  #:default-make-fail make-not-available)
