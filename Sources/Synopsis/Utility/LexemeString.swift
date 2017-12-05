//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


struct LexemeString {
    
    let string:  String
    let lexemes: [Lexeme]

    init(_ string: String) {
        self.string = string
        if string.isEmpty {
            self.lexemes = []
        } else {
            self.lexemes = LexemeString.returnLexeme(
                currentIndex: string.startIndex,
                string: string,
                currentLexeme: Lexeme(left: string.startIndex, right: string.startIndex, kind: LexemeString.Lexeme.Kind.sourceCode),
                initial: []
            )
        }
    }
    
    func inCommentRange(_ index: String.Index) -> Bool {
        if !string.indices.contains(index) || string.endIndex == index {
            return false
        }
        for lexeme in lexemes {
            if (lexeme.left...lexeme.right).contains(index) {
                return lexeme.isCommentKind()
            }
        }
        return false
    }
    
    func inStringLiteralRange(_ index: String.Index) -> Bool {
        if !string.indices.contains(index) || string.endIndex == index {
            return false
        }
        for lexeme in lexemes {
            if (lexeme.left...lexeme.right).contains(index) {
                return lexeme.isStringLiteralKind()
            }
        }
        return false
    }
    
    func inSourceCodeRange(_ index: String.Index) -> Bool {
        if !string.indices.contains(index) || string.endIndex == index {
            return false
        }
        for lexeme in lexemes {
            if (lexeme.left...lexeme.right).contains(index) {
                return lexeme.isSourceCodeKind()
            }
        }
        return false
    }

    private static func returnLexeme(
        currentIndex: String.Index,
        string: String,
        currentLexeme: Lexeme,
        initial: [Lexeme]
    ) -> [Lexeme] {
        if string.endIndex == currentIndex {
            return initial + [currentLexeme]
        } else {
            switch currentLexeme.kind {
                case .sourceCode:
                    if string.detectInlineComment(startingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(after: currentIndex),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.inlineComment),
                            initial: initial + [currentLexeme]
                        )
                    }

                    if string.detectBlockComment(startingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(after: currentIndex),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.blockComment),
                            initial: initial + [currentLexeme]
                        )
                    }

                    if string.detectTextLiteral(startingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(currentIndex, offsetBy: 3),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.textLiteral),
                            initial: initial + [currentLexeme.adjusted(right: string.index(currentIndex, offsetBy: 2))]
                        )
                    }

                    if string.detectStringLiteral(startingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(after: currentIndex),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.stringLiteral),
                            initial: initial + [currentLexeme]
                        )
                    }

                    return returnLexeme(
                        currentIndex: string.index(after: currentIndex),
                        string: string,
                        currentLexeme: currentLexeme.adjusted(right: currentIndex),
                        initial: initial
                    )

                case .blockComment:
                    if string.detectBlockComment(endingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(after: currentIndex),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.sourceCode),
                            initial: initial + [currentLexeme]
                        )
                    }

                    return returnLexeme(
                        currentIndex: string.index(after: currentIndex),
                        string: string,
                        currentLexeme: currentLexeme.adjusted(right: currentIndex),
                        initial: initial
                    )

                case .inlineComment:
                    if string.detectInlineComment(endingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(after: currentIndex),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right:  currentIndex, kind: LexemeString.Lexeme.Kind.sourceCode),
                            initial: initial + [currentLexeme]
                        )
                    }

                    return returnLexeme(
                        currentIndex: string.index(after: currentIndex),
                        string: string,
                        currentLexeme: currentLexeme.adjusted(right: currentIndex),
                        initial: initial
                    )

                case .stringLiteral:
                    if string.detectStringLiteral(endingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(after: currentIndex),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.sourceCode),
                            initial: initial + [currentLexeme]
                        )
                    }

                    return returnLexeme(
                        currentIndex: string.index(after: currentIndex),
                        string: string,
                        currentLexeme: currentLexeme.adjusted(right: currentIndex),
                        initial: initial
                    )

                case .textLiteral:
                    if string.detectTextLiteral(endingAt: currentIndex) {
                        return returnLexeme(
                            currentIndex: string.index(currentIndex, offsetBy: 3),
                            string: string,
                            currentLexeme: Lexeme(left: currentIndex, right: currentIndex, kind: LexemeString.Lexeme.Kind.sourceCode),
                            initial: initial + [currentLexeme.adjusted(right: string.index(currentIndex, offsetBy: 2))]
                        )
                    }
                
                    return returnLexeme(
                        currentIndex: string.index(after: currentIndex),
                        string: string,
                        currentLexeme: currentLexeme.adjusted(right: currentIndex),
                        initial: initial
                    )
            }
        }
    }

    struct Lexeme {
        let left: String.Index
        var right: String.Index
        let kind: Kind
        
        func isCommentKind() -> Bool {
            switch kind {
                case .inlineComment, .blockComment: return true
                default: return false
            }
        }
        
        func isStringLiteralKind() -> Bool {
            switch kind {
                case .stringLiteral, .textLiteral: return true
                default: return false
            }
        }
        
        func isSourceCodeKind() -> Bool {
            switch kind {
                case .sourceCode: return true
                default: return false
            }
        }

        enum Kind {
            case sourceCode
            case inlineComment
            case blockComment
            case stringLiteral
            case textLiteral
        }
        
        func adjusted(right: String.Index) -> Lexeme {
            return Lexeme(left: left, right: right, kind: kind)
        }
    }

}
