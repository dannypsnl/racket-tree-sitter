#lang racket/base
(provide (all-defined-out))
(require ffi/unsafe)

(define _TSParserRef (_cpointer 'TSParser))
(define _TSTreeRef (_cpointer 'TSTree))
(define _TSLanguageRef (_cpointer 'TSLanguage))
(define _TSRangeRef (_cpointer 'TSRange))
(define _TSInputEditRef (_cpointer 'TSInputEdit))
(define _TSSymbol _uint16)
(define _TSFieldId _uint16)

(define _TSInputEncoding
  (_enum '(TSInputEncodingUTF8 TSInputEncodingUTF16)))

(define _TSSymbolType
  (_enum '(TSSymbolTypeRegular
           TSSymbolTypeAnonymous
           TSSymbolTypeAuxiliary)))

(define _TSQueryRef (_cpointer 'TSQuery))
(define _TSQueryPredicateStepRef (_cpointer 'TSQueryPredicateStep))
(define _TSQueryError
  (_enum '(TSQueryErrorNone
           = 0
           TSQueryErrorSyntax
           TSQueryErrorNodeType
           TSQueryErrorField
           TSQueryErrorCapture
           TSQueryErrorStructure
           TSQueryErrorLanguage)))
(define _TSQuantifier
  (_enum '(TSQuantifierZero
           = 0
           TSQuantifierZeroOrOne
           TSQuantifierZeroOrMore
           TSQuantifierOne
           TSQuantifierOneOrMore)))

(define _TSQueryCursorRef (_cpointer 'TSQueryCursor))
(define _TSQueryMatchRef (_cpointer 'TSQueryMatch))
(define _TSQueryCaptureRef (_cpointer/null 'TSQueryCapture))
(define-cstruct _TSQueryMatch
  ([id _uint32]
   [pattern_index _uint16]
   [capture_count _uint16]
   [captures _TSQueryCaptureRef]))

;; TSQueryPredicateStepType: Done = 0, Capture = 1, String = 2
(define _TSQueryPredicateStepType
  (_enum '(TSQueryPredicateStepTypeDone
           TSQueryPredicateStepTypeCapture
           TSQueryPredicateStepTypeString)))
;; { TSQueryPredicateStepType type; uint32_t value_id; }
(define-cstruct _TSQueryPredicateStep
  ([type _TSQueryPredicateStepType]
   [value_id _uint32]))

(define-cstruct _TSPoint ([row _uint32] [column _uint32]))

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

(define _TSNodeRef (_cpointer 'TSNode))
(define-cstruct _TSNode
  ([context (_array _uint32 4)]
   [id _pointer]
   [tree _TSTreeRef]))

;; A single capture inside a match: { TSNode node; uint32_t index; }
;; Read entries out of TSQueryMatch.captures with (ptr-ref captures _TSQueryCapture i).
;; Defined after _TSNode because it embeds one by value.
(define-cstruct _TSQueryCapture
  ([node _TSNode]
   [index _uint32]))

(define _TSTreeCursorRef (_cpointer 'TSTreeCursor))
(define-cstruct _TSTreeCursor
  ([tree (_cpointer _void)]
   [id (_cpointer _void)]
   [context (_array _uint32 2)]))

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
