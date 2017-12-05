//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 A method.
 */
public class MethodDescription: FunctionDescription {
    
    /**
     Is it a simple method or an initializer?
     */
    public var isInitializer: Bool {
        return name.hasPrefix("init(")
    }
    
    /**
     Write down own source code.
     */
    public override var verse: String {
        let commentStr: String
        if let commentExpl: String = comment, !commentExpl.isEmpty {
            commentStr = commentExpl.prefixEachLine(with: "/// ") + "\n"
        } else {
            commentStr = ""
        }
        
        let openBraceIndex: String.Index = name.index(of: "(")!
        
        let accessibilityStr    = accessibility.verse.isEmpty ? "" : "\(accessibility.verse) "
        let funcStr             = isInitializer ? "" : "func "
        let nameStr             = name[..<openBraceIndex]
        let kindStr             = kind.verse.isEmpty ? "" : "\(kind.verse) "
        
        let returnTypeStr: String
        if let returnTypeImpl: TypeDescription = returnType {
            if isInitializer {
                returnTypeStr = ""
            } else {
                returnTypeStr = " -> \(returnTypeImpl.verse)"
            }
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
        super.init(
            comment: comment,
            annotations: annotations,
            accessibility: accessibility,
            name: name,
            arguments: arguments,
            returnType: returnType,
            declaration: declaration,
            kind: kind,
            body: body
        )
    }
    
    public override var debugDescription: String {
        return "METHOD: name = \(name)" + (nil != returnType ? "; return type = \(returnType!)" : "")
    }
    
}
