#lang racket/base
(provide (all-defined-out))
(require ffi/unsafe
         ffi/unsafe/alloc
         "definer.rkt"
         "types.rkt")

(define-treesitter query-cursor-delete (_fun _TSQueryCursorRef -> _void)
  #:c-id ts_query_cursor_delete
  #:wrap (deallocator))
(define-treesitter query-cursor-new (_fun -> _TSQueryCursorRef)
  #:c-id ts_query_cursor_new
  #:wrap (allocator query-cursor-delete))
(define-treesitter query-cursor-exec (_fun _TSQueryCursorRef _TSQueryRef _TSNode -> _void)
  #:c-id ts_query_cursor_exec)
(define-treesitter query-cursor-did-exceed-match-limit (_fun _TSQueryCursorRef -> _bool)
  #:c-id ts_query_cursor_did_exceed_match_limit)
(define-treesitter query-cursor-match-limit (_fun _TSQueryCursorRef -> _uint32)
  #:c-id ts_query_cursor_match_limit)
(define-treesitter query-cursor-set-match-limit (_fun _TSQueryCursorRef _uint32 -> _void)
  #:c-id ts_query_cursor_set_match_limit)
(define-treesitter query-cursor-set-byte-range (_fun _TSQueryCursorRef _uint32 _uint32 -> _void)
  #:c-id ts_query_cursor_set_byte_range)
(define-treesitter query-cursor-set-point-range (_fun _TSQueryCursorRef _TSPoint _TSPoint -> _void)
  #:c-id ts_query_cursor_set_point_range)
(define-treesitter query-cursor-next-match (_fun _TSQueryCursorRef _TSQueryMatchRef -> _bool)
  #:c-id ts_query_cursor_next_match)
(define-treesitter query-cursor-remove-match (_fun _TSQueryCursorRef _uint32 -> _void)
  #:c-id ts_query_cursor_remove_match)
(define-treesitter query-cursor-next-capture (_fun _TSQueryCursorRef _TSQueryMatch _uint32 -> _bool)
  #:c-id ts_query_cursor_next_capture)
