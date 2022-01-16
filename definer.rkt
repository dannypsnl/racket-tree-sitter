#lang racket/base
(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-treesitter
  (ffi-lib "./zig-out/lib/libtree-sitter" '(#f)))

(define _TSParserRef (_cpointer 'TSParser))
(define _TSLanguageRef (_cpointer 'TSLanguage))

(define-treesitter parser-new (_fun -> _TSParserRef)
  #:c-id ts_parser_new)
(define-treesitter parser-delete (_fun _TSParserRef -> _void)
  #:c-id ts_parser_delete)
(define-treesitter set-language (_fun _TSParserRef _TSLanguageRef -> _bool)
  #:c-id ts_parser_set_language)
(define-treesitter get-language (_fun _TSParserRef -> _TSLanguageRef)
  #:c-id ts_parser_language)
