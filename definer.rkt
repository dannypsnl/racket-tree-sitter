#lang racket/base
(provide (all-defined-out))

(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-treesitter
  (ffi-lib "./zig-out/lib/libtree-sitter" '(#f)))

(define _TSParserRef (_cpointer 'TSParser))
(define _TSTreeRef (_cpointer 'TSTree))
(define _TSLanguageRef (_cpointer 'TSLanguage))
(define _TSRangeRef (_cpointer 'TSRange))
(define-cstruct _TSPoint ([row _uint32] [column _uint32]))
(define _TSInputEncoding
  (_enum '(TSInputEncodingUTF8 TSInputEncodingUTF16)))
(define-cstruct _TSInput
  ([payload _pointer]
   [read (_fun (payload byte-index position bytes-read) ::
               (payload : _pointer)
               (byte-index : _uint32)
               (position : _TSPoint)
               (bytes-read : _uint32)
               -> _bytes)]
   [encoding _TSInputEncoding]))

(define-treesitter parser-new (_fun -> _TSParserRef)
  #:c-id ts_parser_new)
(define-treesitter parser-delete (_fun _TSParserRef -> _void)
  #:c-id ts_parser_delete)
(define-treesitter set-language (_fun _TSParserRef _TSLanguageRef -> _bool)
  #:c-id ts_parser_set_language)
(define-treesitter get-language (_fun _TSParserRef -> _TSLanguageRef)
  #:c-id ts_parser_language)
(define-treesitter set-included-ranges (_fun _TSParserRef _TSRangeRef _uint32 -> _bool)
  #:c-id ts_parser_set_included_ranges)
(define-treesitter get-included-ranges (_fun _TSParserRef (_cpointer _uint32) -> _TSRangeRef)
  #:c-id ts_parser_included_ranges)
(define-treesitter parse (_fun _TSParserRef _TSTreeRef _TSInput -> _TSTreeRef)
  #:c-id ts_parser_parse)
(define-treesitter parse-string (_fun _TSParserRef _TSTreeRef _bytes _uint32 -> _TSTreeRef)
  #:c-id ts_parser_parse_string)
(define-treesitter parse-string-encoding (_fun _TSParserRef _TSTreeRef _bytes _uint32 _TSInputEncoding -> _TSTreeRef)
  #:c-id ts_parser_parse_string_encoding)
(define-treesitter reset (_fun _TSParserRef -> _void)
  #:c-id ts_parser_reset)
