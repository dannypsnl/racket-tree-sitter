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

;; -----------------------------------------------------------------------------
;; High-level helpers
;;
;; The raw `query-*-for-id` bindings above return `_string`, which stops at the
;; first NUL. tree-sitter's capture-name / string-value buffers are slices into
;; shared storage and are NOT reliably NUL-terminated, so the length out-param
;; is authoritative. These helpers copy exactly `len` bytes instead.
;; -----------------------------------------------------------------------------

(define-treesitter %query-capture-name (_fun (q id) ::
                                             [q : _TSQueryRef]
                                             [id : _uint32]
                                             [len : (_ptr o _uint32)]
                                             -> [p : _pointer]
                                             -> (values p len))
  #:c-id ts_query_capture_name_for_id)
(define (query-capture-name q id)
  (define-values (p len) (%query-capture-name q id))
  (define bs (make-bytes len))
  (memcpy bs p len)
  (bytes->string/utf-8 bs))

(define-treesitter %query-string-value (_fun (q id) ::
                                             [q : _TSQueryRef]
                                             [id : _uint32]
                                             [len : (_ptr o _uint32)]
                                             -> [p : _pointer]
                                             -> (values p len))
  #:c-id ts_query_string_value_for_id)
(define (query-string-value q id)
  (define-values (p len) (%query-string-value q id))
  (define bs (make-bytes len))
  (memcpy bs p len)
  (bytes->string/utf-8 bs))

;; Predicate steps for a pattern as a list of _TSQueryPredicateStep structs.
(define-treesitter %query-predicate-steps (_fun (q pattern-index) ::
                                                [q : _TSQueryRef]
                                                [pattern-index : _uint32]
                                                [len : (_ptr o _uint32)]
                                                -> [p : _pointer]
                                                -> (values p len))
  #:c-id ts_query_predicates_for_pattern)
(define (query-predicate-steps q pattern-index)
  (define-values (p len) (%query-predicate-steps q pattern-index))
  (for/list ([i (in-range len)]) (ptr-ref p _TSQueryPredicateStep i)))

;; Compile a query from a language and source (string or bytes). Returns the
;; query, or raises with the byte offset and error kind on failure.
;; The out-params are passed as caller-allocated cells (read only on failure)
;; so this wrapped call returns exactly one value — `allocator` requires that.
(define-treesitter %query-new (_fun _TSLanguageRef _bytes _uint32
                                    _pointer _pointer
                                    -> _TSQueryRef)
  #:c-id ts_query_new
  #:wrap (allocator query-delete))
(define (make-query lang src)
  (define bs (if (bytes? src) src (string->bytes/utf-8 src)))
  (define err-offset (malloc _uint32 'atomic))
  (define err-ty (malloc _TSQueryError 'atomic))
  (define q (%query-new lang bs (bytes-length bs) err-offset err-ty))
  (unless q
    (error 'make-query "query compile failed at byte ~a: ~a"
           (ptr-ref err-offset _uint32) (ptr-ref err-ty _TSQueryError)))
  q)
