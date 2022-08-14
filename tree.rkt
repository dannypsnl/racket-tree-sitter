#lang racket/base
(provide (all-defined-out))
(require ffi/unsafe
         ffi/unsafe/alloc
         "definer.rkt"
         "types.rkt")

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
