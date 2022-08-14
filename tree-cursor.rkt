#lang racket/base
(provide (all-defined-out))
(require ffi/unsafe
         ffi/unsafe/alloc
         "definer.rkt"
         "types.rkt")

#|
TSTreeCursor ts_tree_cursor_new(TSNode);
void ts_tree_cursor_delete(TSTreeCursor *);
void ts_tree_cursor_reset(TSTreeCursor *, TSNode);
TSNode ts_tree_cursor_current_node(const TSTreeCursor *);
const char *ts_tree_cursor_current_field_name(const TSTreeCursor *);
TSFieldId ts_tree_cursor_current_field_id(const TSTreeCursor *);
bool ts_tree_cursor_goto_parent(TSTreeCursor *);
bool ts_tree_cursor_goto_next_sibling(TSTreeCursor *);
bool ts_tree_cursor_goto_first_child(TSTreeCursor *);
int64_t ts_tree_cursor_goto_first_child_for_byte(TSTreeCursor *, uint32_t);
int64_t ts_tree_cursor_goto_first_child_for_point(TSTreeCursor *, TSPoint);
TSTreeCursor ts_tree_cursor_copy(const TSTreeCursor *);
|#
(define-treesitter tree-cursor-delete (_fun _TSTreeCursorRef -> _void)
  #:c-id ts_tree_cursor_delete
  #:wrap (deallocator))
(define-treesitter tree-cursor-new (_fun _TSNode -> _TSTreeCursor)
  #:c-id ts_tree_cursor_new
  #:wrap (allocator tree-cursor-delete))
(define-treesitter reset-tree-cursor (_fun _TSTreeCursorRef _TSNode -> _void)
  #:c-id ts_tree_cursor_reset)
(define-treesitter current-node (_fun _TSTreeCursorRef -> _TSNode)
  #:c-id ts_tree_cursor_current_node)
(define-treesitter current-field-name (_fun _TSTreeCursorRef -> _string)
  #:c-id ts_tree_cursor_current_field_name)
(define-treesitter current-field-id (_fun _TSTreeCursorRef -> _TSFieldId)
  #:c-id ts_tree_cursor_current_field_id)
(define-treesitter goto-parent (_fun _TSTreeCursorRef -> _bool)
  #:c-id ts_tree_cursor_goto_parent)
(define-treesitter goto-next-sibling (_fun _TSTreeCursorRef -> _bool)
  #:c-id ts_tree_cursor_goto_next_sibling)
(define-treesitter goto-first-child (_fun _TSTreeCursorRef -> _bool)
  #:c-id ts_tree_cursor_goto_first_child)
(define-treesitter goto-first-child-for-byte (_fun _TSTreeCursorRef _uint32 -> _int64)
  #:c-id ts_tree_cursor_goto_first_child_for_byte)
(define-treesitter goto-first-child-for-point (_fun _TSTreeCursorRef _TSPoint -> _int64)
  #:c-id ts_tree_cursor_goto_first_child_for_point)
(define-treesitter copy-tree-cursor (_fun _TSTreeCursorRef -> _TSTreeCursor)
  #:c-id ts_tree_cursor_copy)
