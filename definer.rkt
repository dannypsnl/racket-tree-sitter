#lang racket/base
(provide (all-defined-out))

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc)

(define (get-lib-dir)
  (list "/usr/local/lib"))
(define-ffi-definer define-treesitter
  (ffi-lib "libtree-sitter" '(#f)
           #:get-lib-dirs get-lib-dir))

(define _TSParserRef (_cpointer 'TSParser))
(define _TSTreeRef (_cpointer 'TSTree))
(define _TSLanguageRef (_cpointer 'TSLanguage))
(define _TSRangeRef (_cpointer 'TSRange))
(define _TSInputEditRef (_cpointer 'TSInputEdit))
(define _TSSymbol _uint16)
(define _TSFieldId _uint16)
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
(define-cstruct _TSInputEdit
  ([start_byte _uint32]
   [old_end_byte _uint32]
   [new_end_byte _uint32]
   [start_point _TSPoint]
   [old_end_point _TSPoint]
   [new_end_point _TSPoint]))

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
(define-treesitter tree-copy (_fun _TSTreeRef -> _TSTreeRef)
  #:c-id ts_tree_copy)
(define-treesitter tree-delete (_fun _TSTreeRef -> _void)
  #:c-id ts_tree_delete
  #:wrap (deallocator))
(define-treesitter root-node (_fun _TSTreeRef -> _TSNode)
  #:c-id ts_tree_root_node)
(define-treesitter tree-language (_fun _TSTreeRef -> _TSLanguageRef)
  #:c-id ts_tree_language)
(define-treesitter tree-edit (_fun _TSTreeRef _TSInputEditRef -> _void)
  #:c-id ts_tree_edit)
(define-treesitter tree-get-changed-ranges (_fun (old-tree new-tree length) ::
                                                 [old-tree : _TSTreeRef]
                                                 [new-tree : _TSTreeRef]
                                                 [length : (_cpointer _uint32)]
                                                 -> _TSRangeRef)
  #:c-id ts_tree_get_changed_ranges)


; node
(define-treesitter node-type (_fun _TSNode -> _string)
  #:c-id ts_node_type)
(define-treesitter node-symbol (_fun _TSNode -> _TSSymbol)
  #:c-id ts_node_symbol)
(define-treesitter node-start-byte (_fun _TSNode -> _uint32)
  #:c-id ts_node_start_byte)
(define-treesitter node-start-point (_fun _TSNode -> _TSPoint)
  #:c-id ts_node_start_point)
(define-treesitter node-end-byte (_fun _TSNode -> _uint32)
  #:c-id ts_node_end_byte)
(define-treesitter node-end-point (_fun _TSNode -> _TSPoint)
  #:c-id ts_node_end_point)
(define-treesitter node->string (_fun _TSNode -> _string)
  #:c-id ts_node_string)
(define-treesitter node-is-null (_fun _TSNode -> _bool)
  #:c-id ts_node_is_null)
(define-treesitter node-is-named (_fun _TSNode -> _bool)
  #:c-id ts_node_is_named)
(define-treesitter node-is-missing (_fun _TSNode -> _bool)
  #:c-id ts_node_is_missing)
(define-treesitter node-is-extra (_fun _TSNode -> _bool)
  #:c-id ts_node_is_extra)
(define-treesitter node-has-changes (_fun _TSNode -> _bool)
  #:c-id ts_node_has_changes)
(define-treesitter node-has-error (_fun _TSNode -> _bool)
  #:c-id ts_node_has_error)
(define-treesitter node-parent (_fun _TSNode -> _TSNode)
  #:c-id ts_node_parent)
(define-treesitter node-child (_fun (node index) ::
                                    (node : _TSNode)
                                    (index : _uint32)
                                    -> _TSNode)
  #:c-id ts_node_child)
(define-treesitter node-field-name-for-child (_fun (node index) ::
                                                   (node : _TSNode)
                                                   (index : _uint32)
                                                   -> _string)
  #:c-id ts_node_field_name_for_child)
(define-treesitter node-child-count (_fun _TSNode -> _uint32)
  #:c-id ts_node_child_count)
(define-treesitter node-named-child (_fun (node index) ::
                                          (node : _TSNode)
                                          (index : _uint32)
                                          -> _TSNode)
  #:c-id ts_node_named_child)
(define-treesitter node-named-child-count (_fun _TSNode -> _uint32)
  #:c-id ts_node_named_child_count)
(define-treesitter node-child-by-field-name (_fun (self field-name field-name-length) ::
                                                  (self : _TSNode)
                                                  (field-name : _string)
                                                  (field-name-length : _uint32)
                                                  -> _TSNode)
  #:c-id ts_node_child_by_field_name)
(define-treesitter node-child-by-field-id (_fun (node field-id) ::
                                                (node : _TSNode)
                                                (field-id : _TSFieldId)
                                                -> _TSNode)
  #:c-id ts_node_child_by_field_id)
