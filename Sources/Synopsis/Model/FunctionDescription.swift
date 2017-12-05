//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 A function.
 */
public class FunctionDescription: Equatable, CustomDebugStringConvertible {
    
    /**
     Documentation comment.
     */
    public let comment: String?
    
    /**
     Function annotations.
     
     Function annotations are located inside block comment above the declaration.
     */
    public let annotations: [Annotation]
    
    /**
     Access visibility.
     */
    public let accessibility: Accessibility
    
    /**
     Function name.
     
     Almost like signature, but without argument types.
     */
    public let name: String
    
    /**
     Function arguments.
     */
    public let arguments: [ArgumentDescription]
    
    /**
     Return type.
     */
    public let returnType: TypeDescription?
    
    /**
     Function declaration line.
     */
    public let declaration: Declaration
    
    /**
     Kind.
     */
    public let kind: Kind
    
    /**
     Function body, if available.
     */
    public let body: String?
    
    /**
     Write down own source code.
     */
    public var verse: String {
        let commentStr: String
        if let commentExpl: String = comment, !commentExpl.isEmpty {
            commentStr = commentExpl.prefixEachLine(with: "/// ") + "\n"
        } else {
            commentStr = ""
        }
        
        let openBraceIndex: String.Index = name.index(of: "(")!
        
        let accessibilityStr    = accessibility.verse.isEmpty ? "" : "\(accessibility.verse) "
        let funcStr             = "func "
        let nameStr             = name[..<openBraceIndex]
        let kindStr             = kind.verse.isEmpty ? "" : "\(kind.verse) "
        
        let returnTypeStr: String
        if let returnTypeImpl: TypeDescription = returnType {
            returnTypeStr = " -> \(returnTypeImpl.verse)"
        } else {
            returnTypeStr = ""
        }
        
        let bodyStr: String
        if let bodyImpl: String = body {
            if bodyImpl.isEmpty {
                bodyStr = " {}"
            } else {
                bodyStr = " {\n\(body!.indent)\n}"
            }
        } else {
            bodyStr = ""
        }
        
        let argumentsStr: String
        if arguments.isEmpty {
            argumentsStr = ""
        } else {
            argumentsStr = arguments.reduce("\n") { (result: String, argument: ArgumentDescription) -> String in
                if arguments.last != argument {
                    return result + argument.verseWithComa + "\n"
                }
                return result + argument.verse + "\n"
            }
        }
        
        return """
            \(commentStr)\(accessibilityStr)\(kindStr)\(funcStr)\(nameStr)(\(argumentsStr.indent))\(returnTypeStr)\(bodyStr)
            """
    }
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public required init(
        comment: String?,
        annotations: [Annotation],
        accessibility: Accessibility,
        name: String,
        arguments: [ArgumentDescription],
        returnType: TypeDescription?,
        declaration: Declaration,
        kind: Kind,
        body: String?
    ) {
        self.comment        = comment
        self.annotations    = annotations
        self.accessibility  = accessibility
        self.name           = name
        self.arguments      = arguments
        self.returnType     = returnType
        self.declaration    = declaration
        self.kind           = kind
        self.body           = body
    }
    
    /**
     Make a template for later code generation.
     
     - throws: FunctionTemplateError
     */
    public class func template(
        comment: String?,
        accessibility: Accessibility,
        name: String,
        arguments: [ArgumentDescription],
        returnType: TypeDescription?,
        kind: Kind,
        body: String?
    ) throws -> Self {
        if !checkRoundBrackets(inName: name) {
            throw FunctionTemplateError.nameLacksRoundBrackets(name: name)
        }
        
        return self.init(
            comment: comment,
            annotations: [],
            accessibility: accessibility,
            name: name,
            arguments: arguments,
            returnType: returnType,
            declaration: Declaration.mock,
            kind: kind,
            body: body
        )
    }
    
    public static func ==(left: FunctionDescription, right: FunctionDescription) -> Bool {
        return left.comment         == right.comment
            && left.annotations     == right.annotations
            && left.accessibility   == right.accessibility
            && left.name            == right.name
            && left.arguments       == right.arguments
            && left.returnType      == right.returnType
            && left.declaration     == right.declaration
            && left.kind            == right.kind
            && left.body            == right.body
    }
    
    public var debugDescription: String {
        return "FUNCTION: name = \(name)" + (nil != returnType ? "; return type = \(returnType!)" : "")
    }
    
    public enum FunctionTemplateError: Error {
        case nameLacksRoundBrackets(name: String)
    }
    
    public enum Kind {
        case free
        case `class`
        case `static`
        case instance
        
        public var verse: String {
            switch self {
                case .`class`: return "class"
                case .`static`: return "static"
                case .instance, .free: return ""
            }
        }
    }
    
}


public extension Sequence where Iterator.Element: FunctionDescription {
    
    public subscript(name: String) -> Iterator.Element? {
        for item in self {
            if item.name == name {
                return item
            }
        }
        return nil
    }
    
    public func contains(name: String) -> Bool {
        return nil != self[name]
    }
    
}


private extension FunctionDescription {
    static func checkRoundBrackets(inName name: String) -> Bool {
        let lex = LexemeString(name)
        
        var left    = false
        var right   = false
        
        for lexeme in lex.lexemes {
            if lexeme.isSourceCodeKind() {
                if name[lexeme.left...lexeme.right].contains("(") {
                    left = true
                }
                if name[lexeme.left...lexeme.right].contains(")") {
                    right = true
                }
            }
        }
        
        return left && right
    }
}
