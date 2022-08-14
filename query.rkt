#lang racket/base
(provide (all-defined-out))
(require ffi/unsafe
         ffi/unsafe/alloc
         "definer.rkt"
         "types.rkt")

(define-treesitter query-delete (_fun _TSQueryRef -> _void)
  #:c-id ts_query_delete
  #:wrap (deallocator))
(define-treesitter query-new (_fun (lang src src-len err-offset err-ty) ::
                                   [lang : _TSLanguageRef]
                                   [src : _string]
                                   [src-len : _uint32]
                                   [err-offset : (_cpointer _uint32)]
                                   [err-ty : (_cpointer _TSQueryError)]
                                   -> _TSQueryRef)
  #:c-id ts_query_new
  #:wrap (allocator query-delete))
(define-treesitter query-pattern-count (_fun _TSQueryRef -> _uint32)
  #:c-id ts_query_pattern_count)
(define-treesitter query-capture-count (_fun _TSQueryRef -> _uint32)
  #:c-id ts_query_capture_count)
(define-treesitter query-string-count (_fun _TSQueryRef -> _uint32)
  #:c-id ts_query_string_count)
(define-treesitter query-start-byte-for-pattern (_fun _TSQueryRef _uint32 -> _uint32)
  #:c-id ts_query_start_byte_for_pattern)
(define-treesitter query-predicates-for-pattern (_fun (self pattern-index len) ::
                                                      [self : _TSQueryRef]
                                                      [pattern-index : _uint32]
                                                      [len : (_cpointer _uint32)]
                                                      -> _TSQueryPredicateStepRef)
  #:c-id ts_query_predicates_for_pattern)
(define-treesitter query-is-pattern-rooted (_fun (self pattern-index) ::
                                                 [self : _TSQueryRef]
                                                 [pattern-index : _uint32]
                                                 -> _bool)
  #:c-id ts_query_is_pattern_rooted)
(define-treesitter query-is-pattern-guaranteed-at-step (_fun (self byte-offset) ::
                                                             [self : _TSQueryRef]
                                                             [byte-offset : _uint32]
                                                             -> _bool)
  #:c-id ts_query_is_pattern_guaranteed_at_step)
(define-treesitter query-capture-name-for-id (_fun (self id len) ::
                                                   [self : _TSQueryRef]
                                                   [id : _uint32]
                                                   [len : (_cpointer _uint32)]
                                                   -> _string)
  #:c-id ts_query_capture_name_for_id)
(define-treesitter query-capture-quantifier-for-id (_fun _TSQueryRef _uint32 _uint32 -> _TSQuantifier)
  #:c-id ts_query_capture_quantifier_for_id)
(define-treesitter query-string-value-for-id (_fun (self id len) ::
                                                   [self : _TSQueryRef]
                                                   [id : _uint32]
                                                   [len : (_cpointer _uint32)]
                                                   -> _string)
  #:c-id ts_query_string_value_for_id)
(define-treesitter query-disable-capture (_fun _TSQueryRef _string _uint32 -> _void)
  #:c-id ts_query_disable_capture)
(define-treesitter query-disable-pattern (_fun _TSQueryRef _uint32 -> _void)
  #:c-id ts_query_disable_pattern)
