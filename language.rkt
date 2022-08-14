#lang racket/base
(provide (all-defined-out))
(require ffi/unsafe
         "definer.rkt"
         "types.rkt")

(define-treesitter language-symbol-count (_fun _TSLanguageRef -> _uint32)
  #:c-id ts_language_symbol_count)
(define-treesitter language-symbol-name (_fun _TSLanguageRef _TSSymbol -> _string)
  #:c-id ts_language_symbol_name)
(define-treesitter language-symbol-for-name (_fun (self str len named?) ::
                                                  [self : _TSLanguageRef]
                                                  [str : _string]
                                                  [len : _uint32]
                                                  [named? : _bool]
                                                  -> _TSSymbol)
  #:c-id ts_language_symbol_for_name)
(define-treesitter language-field-count (_fun _TSLanguageRef -> _uint32)
  #:c-id ts_language_field_count)
(define-treesitter language-field-name-for-id (_fun _TSLanguageRef _TSFieldId -> _string)
  #:c-id ts_language_field_name_for_id)
(define-treesitter language-field-id-for-name (_fun _TSLanguageRef _string _uint32 -> _TSFieldId)
  #:c-id ts_language_field_id_for_name)
(define-treesitter language-symbol-type (_fun _TSLanguageRef _TSSymbol -> _TSSymbolType)
  #:c-id ts_language_symbol_type)
(define-treesitter language-version (_fun _TSLanguageRef -> _uint32)
  #:c-id ts_language_version)