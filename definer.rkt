#lang racket/base
(provide (all-defined-out))

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc)

(define-ffi-definer define-treesitter
  (ffi-lib "./zig-out/lib/libtree-sitter" '(#f)))

(define _TSParserRef (_cpointer 'TSParser))
(define _TSTreeRef (_cpointer 'TSTree))
(define _TSLanguageRef (_cpointer 'TSLanguage))
(define _TSRangeRef (_cpointer 'TSRange))
(define-cstruct _TSPoint ([row _uint32] [column _uint32]))
(define _TSInputEncoding
  (_enum '(TSInputEncodingUTF8 TSInputEncodingUTF16)))
(define _TSLogType
  (_enum '(TSLogTypeParse TSLogTypeLex)))
(define-cstruct _TSInput
  ([payload _pointer]
   [read (_fun (payload byte-index position bytes-read) ::
               (payload : _pointer)
               (byte-index : _uint32)
               (position : _TSPoint)
               (bytes-read : _uint32)
               -> _bytes)]
   [encoding _TSInputEncoding]))
(define-cstruct _TSNode
  ([context (_array _uint32 4)]
   [id _pointer]
   [tree _TSTreeRef]))
(define-cstruct _TSLogger
  ([payload _pointer]
   [log (_fun (payload typ message) ::
              (payload : _pointer)
              (typ : _TSLogType)
              (message : _string)
              -> _void)]))

; parser
(define-treesitter parser-delete (_fun _TSParserRef -> _void)
  #:c-id ts_parser_delete
  #:wrap (deallocator))
(define-treesitter parser-new (_fun -> _TSParserRef)
  #:c-id ts_parser_new
  #:wrap (allocator parser-delete))
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
(define-treesitter parse-string (_fun (parser old-tree source-code) ::
                                      (parser : _TSParserRef)
                                      (old-tree : (_cpointer/null 'TSTree))
                                      (source-code : _string)
                                      (_uint32 = (string-length source-code))
                                      -> _TSTreeRef)
  #:c-id ts_parser_parse_string)
(define-treesitter parse-string-encoding (_fun (parser old-tree source-code encoding) ::
                                               (parser : _TSParserRef)
                                               (old-tree : (_cpointer/null 'TSTree))
                                               (source-code : _string)
                                               (_uint32 = (string-length source-code))
                                               (encoding : _TSInputEncoding)
                                               -> _TSTreeRef)
  #:c-id ts_parser_parse_string_encoding)
(define-treesitter reset (_fun _TSParserRef -> _void)
  #:c-id ts_parser_reset)
(define-treesitter set-timeout-micros (_fun _TSParserRef _uint64 -> _void)
  #:c-id ts_parser_set_timeout_micros)
(define-treesitter get-timeout-micros (_fun _TSParserRef -> _uint64)
  #:c-id ts_parser_timeout_micros)
(define-treesitter set-cancellation-flag (_fun _TSParserRef (_cpointer _size) -> _void)
  #:c-id ts_parser_set_cancellation_flag)
(define-treesitter get-cancellation-flag (_fun _TSParserRef -> (_cpointer _size))
  #:c-id ts_parser_cancellation_flag)
(define-treesitter set-logger (_fun _TSParserRef _TSLogger -> _void)
  #:c-id ts_parser_set_logger)
(define-treesitter get-logger (_fun _TSParserRef -> _TSLogger)
  #:c-id ts_parser_logger)
(define-treesitter print-dot-graphs (_fun (parser file-descriptor) ::
                                          (parser : _TSParserRef)
                                          (file-descriptor : _int)
                                          -> _void)
  #:c-id ts_parser_print_dot_graphs)

; tree
(define-treesitter tree-delete (_fun _TSTreeRef -> _void)
  #:c-id ts_tree_delete
  #:wrap (deallocator))
(define-treesitter root-node (_fun _TSTreeRef -> _TSNode)
  #:c-id ts_tree_root_node)
(define-treesitter tree-copy (_fun _TSTreeRef -> _TSTreeRef)
  #:c-id ts_tree_copy)

; node
(define-treesitter node->string (_fun _TSNode -> _string)
  #:c-id ts_node_string)
