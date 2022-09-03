#lang scribble/manual
@require[@for-label[racket-tree-sitter
                    racket/base]]

@title{racket-tree-sitter}
@author{Lîm Tsú-thuàn}

@defmodule[racket-tree-sitter]

@section{Guide}

@racketblock[
 (require racket-tree-sitter
          ffi/unsafe
          ffi/unsafe/define)

 (define-ffi-definer define-racket
   (ffi-lib "./zig-out/lib/libtree-sitter-racket" '(#f)))

 (define-racket rkt-language (_fun -> _TSLanguageRef)
   #:c-id tree_sitter_racket)

 (define p (parser-new))
 (set-language p (rkt-language))

 (define source-code "
(+ 1 2)
(define x 1)
(define (foo a b)
  (+ a b x))
")
 (define tree (parse-string p #f source-code))

 (define root (root-node tree))
 (displayln (node->string root))

 (tree-delete tree)
 ]

@section{Reference}

@defthing*[([_TSParserRef ctype?]
            [_TSLanguageRef ctype?]
            [_TSTreeRef ctype?])]{
 Tree sitter primitive types.
}

@defproc[(TSParserRef? [v any/c]) boolean?]{check a value is TSParserRef or not}
@defproc[(TSLanguageRef? [v any/c]) boolean?]{check a value is TSLanguageRef or not}
@defproc[(TSTreeRef? [v any/c]) boolean?]{check a value is TSTreeRef or not}

@defproc[(parser-new) TSParserRef?]{
 New parser
}

@defproc[(parser-delete [parser TSParserRef?]) void?]{
 Delete a parser
}

@defproc[(set-language [parser TSParserRef?] [language TSLanguageRef?]) void?]{
 Setting the language of parser
}

@defproc[(parse-string [parser TSParserRef?]
                       [old-tree (or/c #f TSTreeRef?)]
                       [source-code string?])
         TSTreeRef?]{
 Parser a string source code
}
