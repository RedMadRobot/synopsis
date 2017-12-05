//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Case of enum.
 */
public struct EnumCase: Equatable, CustomDebugStringConvertible {
    
    /**
     Documentation comment.
     */
    public let comment: String?
    
    /**
     Annotations.
     */
    public let annotations: [Annotation]
    
    /**
     Case name.
     */
    public let name: String
    
    /**
     Raw default value.
     */
    public let defaultValue: String?
    
    /**
     Declaration line.
     */
    public let declaration: Declaration
    
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
        
        let defaultValueStr:  String = nil != defaultValue ? " = \(defaultValue!)" : ""
        
        return """
            \(commentStr)case \(name)\(defaultValueStr)
            """
    }
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(
        comment: String?,
        annotations: [Annotation],
        name: String,
        defaultValue: String?,
        declaration: Declaration
    ) {
        self.comment        = comment
        self.annotations    = annotations
        self.name           = name
        self.defaultValue   = defaultValue
        self.declaration    = declaration
    }
    
    /**
     Make a template enum case for later code generation.
     */
    public static func template(
        comment: String?,
        name: String,
        defaultValue: String?
    ) -> EnumCase {
        return EnumCase(
            comment: comment,
            annotations: [],
            name: name,
            defaultValue: defaultValue,
            declaration: Declaration.mock
        )
    }
    
    public static func ==(left: EnumCase, right: EnumCase) -> Bool {
        return left.comment         == right.comment
            && left.annotations     == right.annotations
            && left.name            == right.name
            && left.defaultValue    == right.defaultValue
            && left.declaration     == right.declaration
    }
    
    public var debugDescription: String {
        return "ENUMCASE: name = \(name)"
    }
    
}


public extension Sequence where Iterator.Element == EnumCase {
    
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
