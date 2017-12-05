//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Method arguments' parser.
 */
class ArgumentDescriptionParser {

    func parse(functionParsedDeclaration declaration: String) -> [ArgumentDescription] {
        let rawArguments: String = extractRawArguments(fromMethodDeclaration: declaration)
        return parse(rawArguments: rawArguments)
    }
    
}


private extension ArgumentDescriptionParser {
    
    func extractRawArguments(fromMethodDeclaration declaration: String) -> String {
        let openBraceIndex: String.Index = findOpenBrace(inMethodDeclaration: declaration)
        let argumentsStart = declaration.index(after: openBraceIndex)
        
        let lex = LexemeString(declaration)
        for index in declaration.indices {
            if ")" == declaration[index] && lex.inSourceCodeRange(index) {
                return String(declaration[argumentsStart..<index])
            }
        }
        
        return declaration
    }
    
    func findOpenBrace(inMethodDeclaration declaration: String) -> String.Index {
        let lex = LexemeString(declaration)
        for index in declaration.indices {
            if "(" == declaration[index] && lex.inSourceCodeRange(index) {
                return index
            }
        }
        
        return declaration.startIndex
    }
    
    func parse(rawArguments arguments: String) -> [ArgumentDescription] {
        if arguments.isEmpty { return [] }
        
        var rawArgumentsWithoutComments: String   = ""
        var inlineComments:              [String] = []
        
        let lex = LexemeString(arguments)
        for lexeme in lex.lexemes {
            if lexeme.isCommentKind() {
                inlineComments.append(String(arguments[lexeme.left...lexeme.right]).truncateInlineCommentOpening())
            } else {
                rawArgumentsWithoutComments += String(arguments[lexeme.left...lexeme.right])
            }
        }
        
        return parse(rawArgumentsWithoutComments: rawArgumentsWithoutComments, comments: inlineComments)
    }
    
    func parse(rawArgumentsWithoutComments: String, comments: [String]) -> [ArgumentDescription] {
        var commentsIterator = comments.makeIterator()
        return
            rawArgumentsWithoutComments
                .replacingOccurrences(of: "\n", with: "")
                .components(separatedBy: ",")
                .map { parse(argumentLine: $0, comment: commentsIterator.next()) }
    }
    
    func parse(argumentLine line: String, comment: String?) -> ArgumentDescription {
        let argumentName:         String
        let externalArgumentName: String
        
        let annotations: [Annotation] = nil != comment ? AnnotationParser().parse(comment: comment!) : []
        let argumentType: TypeDescription = TypeParser().deduceType(fromDeclaration: line)
        let defaultValue: String? = getDefaultValue(fromArgumentLineWithNoComments: line)
        
        // NOTE: method arguments always have explicit types
        let names = String(line.truncateAfter(word: ":", deleteWord: true).trimmingCharacters(in: CharacterSet.whitespaces))
        
        externalArgumentName = String(names.firstWord())
        if names.contains(" ") {
            argumentName = String(names.truncateUntil(word: " ", deleteWord: true))
        } else {
            argumentName = externalArgumentName
        }
        
        return ArgumentDescription(
            name: externalArgumentName,
            bodyName: argumentName,
            type: argumentType,
            defaultValue: defaultValue,
            annotations: annotations,
            declaration: nil,
            comment: comment
        )
    }
    
    func getDefaultValue(fromArgumentLineWithNoComments line: String) -> String? {
        guard let equalSignIndex: String.Index = line.index(of: "=")
        else { return nil }
        
        return String(line[equalSignIndex...].dropFirst().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    
}
