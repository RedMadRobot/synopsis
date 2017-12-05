//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Property description.
 */
public struct PropertyDescription: Equatable, CustomDebugStringConvertible {
    
    /**
     Documentation comment.
     */
    public let comment: String?
    
    /**
     Property annotations.
     */
    public let annotations: [Annotation]
    
    /**
     Access visibility.
     */
    public let accessibility: Accessibility
    
    /**
     Property is `let`.
     
     Otherwise `var`.
     */
    public let constant: Bool
    
    /**
     Property name.
     */
    public let name: String
    
    /**
     Property type.
     */
    public let type: TypeDescription
    
    /**
     Raw default value.
     */
    public let defaultValue: String?
    
    /**
     Property declaration line.
     */
    public let declaration: Declaration
    
    /**
     Kind of a property.
     */
    public let kind: Kind
    
    /**
     Getters, setters, didSetters, willSetters etc.
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
        
        let accessibilityStr: String = accessibility.verse.isEmpty ? "" : "\(accessibility.verse) "
        let kindStr:          String = kind.verse.isEmpty ? "" : "\(kind.verse) "
        let constantStr:      String = constant ? "let" : "var"
        let bodyStr:          String = nil != body ? " {\n\(body!.indent)\n}" : ""
        let defaultValueStr:  String = nil != defaultValue ? " = \(defaultValue!)" : ""
        
        return """
            \(commentStr)\(accessibilityStr)\(kindStr)\(constantStr) \(name): \(type.verse)\(defaultValueStr)\(bodyStr)
            """
    }
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(
        comment: String?,
        annotations: [Annotation],
        accessibility: Accessibility,
        constant: Bool,
        name: String,
        type: TypeDescription,
        defaultValue: String?,
        declaration: Declaration,
        kind: Kind,
        body: String?
    ) {
        self.comment        = comment
        self.annotations    = annotations
        self.accessibility  = accessibility
        self.constant       = constant
        self.name           = name
        self.type           = type
        self.defaultValue   = defaultValue
        self.declaration    = declaration
        self.kind           = kind
        self.body           = body
    }
    
    /**
     Make a template property for later code generation.
     */
    public static func template(
        comment: String?,
        accessibility: Accessibility,
        constant: Bool,
        name: String,
        type: TypeDescription,
        defaultValue: String?,
        kind: Kind,
        body: String?
    ) -> PropertyDescription {
        return PropertyDescription(
            comment: comment,
            annotations: [],
            accessibility: accessibility,
            constant: constant,
            name: name,
            type: type,
            defaultValue: defaultValue,
            declaration: Declaration.mock,
            kind: kind,
            body: body
        )
    }
    
    public static func ==(left: PropertyDescription, right: PropertyDescription) -> Bool {
        return left.comment         == right.comment
            && left.annotations     == right.annotations
            && left.accessibility   == right.accessibility
            && left.constant        == right.constant
            && left.name            == right.name
            && left.type            == right.type
            && left.defaultValue    == right.defaultValue
            && left.declaration     == right.declaration
            && left.kind            == right.kind
            && left.body            == right.body
    }
    
    public var debugDescription: String {
        return "PROPERTY: name = \(name); type = \(type); constant = \(constant)"
    }
    
    public enum Kind {
        case `class`
        case `static`
        case instance
        
        public var verse: String {
            switch self {
                case .`class`: return "class"
                case .`static`: return "static"
                case .instance: return ""
            }
        }
        
        // TODO support global, local & parameter kinds
    }
    
}


public extension Sequence where Iterator.Element == PropertyDescription {
    
    public subscript(propertyName: String) -> Iterator.Element? {
        for item in self {
            if item.name == propertyName {
                return item
            }
        }
        return nil
    }
    
    public func contains(propertyName: String) -> Bool {
        return nil != self[propertyName]
    }
    
}
