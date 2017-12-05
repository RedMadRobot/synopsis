//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Method argument description.
 */
public struct ArgumentDescription: Equatable, CustomDebugStringConvertible {
    
    /**
     Argument "external" name used in method calls.
     */
    public let name: String
    
    /**
     Argument "internal" name used inside method body.
     */
    public let bodyName: String
    
    /**
     Argument type.
     */
    public let type: TypeDescription
    
    /**
     Default value, if any.
     */
    public let defaultValue: String?
    
    /**
     Argument annotations; N.B.: arguments only have inline annotations.
     */
    public let annotations: [Annotation]
    
    /**
     Argument declaration.
     */
    public let declaration: Declaration? // FIXME: Make mandatory
    
    /**
     Inline comment.
     */
    public let comment: String?
    
    /**
     Write down own source code.
     */
    public var verse: String {
        let defaultValueStr: String = nil != defaultValue ? " = \(defaultValue!)" : ""
        
        if name == bodyName {
            return "\(name): \(type.verse)\(defaultValueStr)" + (nil != comment ? " // \(comment!)" : "")
        } else {
            return "\(name) \(bodyName): \(type.verse)\(defaultValueStr)" + (nil != comment ? " // \(comment!)" : "")
        }
    }
    
    /**
     Write down own source code like if it was one of multiple arguments.
     */
    public var verseWithComa: String {
        let defaultValueStr: String = nil != defaultValue ? " = \(defaultValue!)" : ""
        
        if name == bodyName {
            return "\(name): \(type.verse)\(defaultValueStr)," + (nil != comment ? " // \(comment!)" : "")
        } else {
            return "\(name) \(bodyName): \(type.verse)\(defaultValueStr)," + (nil != comment ? " // \(comment!)" : "")
        }
    }
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(
        name: String,
        bodyName: String,
        type: TypeDescription,
        defaultValue: String?,
        annotations: [Annotation],
        declaration: Declaration?,
        comment: String?
    ) {
        self.name           = name
        self.bodyName       = bodyName
        self.type           = type
        self.defaultValue   = defaultValue
        self.annotations    = annotations
        self.declaration    = declaration
        self.comment        = comment
    }
    
    /**
     Make a template for later code generation.
     */
    public static func template(
        name: String,
        bodyName: String,
        type: TypeDescription,
        defaultValue: String?,
        comment: String?
    ) -> ArgumentDescription {
        return ArgumentDescription(
            name: name,
            bodyName: bodyName,
            type: type,
            defaultValue: defaultValue,
            annotations: [],
            declaration: Declaration.mock,
            comment: comment
        )
    }
    
    public static func ==(left: ArgumentDescription, right: ArgumentDescription) -> Bool {
        return left.annotations     == right.annotations
            && left.name            == right.name
            && left.bodyName        == right.bodyName
            && left.type            == right.type
            && left.defaultValue    == right.defaultValue
            && left.declaration     == right.declaration
            && left.comment         == right.comment
    }
    
    public var debugDescription: String {
        return "ARGUMENT: name = \(name); body name = \(bodyName); type = \(type)"
    }
    
}


public extension Sequence where Iterator.Element == ArgumentDescription {
    
    public subscript(argumentName: String) -> Iterator.Element? {
        for item in self {
            if item.name == argumentName {
                return item
            }
        }
        return nil
    }
    
    public func contains(argumentName: String) -> Bool {
        return nil != self[argumentName]
    }
    
}
