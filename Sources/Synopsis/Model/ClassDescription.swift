//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Class description.
 */
public struct ClassDescription: Extensible {

    /**
     Documentation comment above the class.
     */
    public let comment: String?
    
    /**
     Class annotations.
     
     Class annotations are located inside the block comment above the class declaration.
     */
    public let annotations: [Annotation]
    
    /**
     Class declaration line.
     */
    public let declaration: Declaration
    
    /**
     Access visibility.
     */
    public let accessibility: Accessibility
    
    /**
     Name of the class.
     */
    public let name: String
    
    /**
     Inherited types: parent class/classes, protocols etc.
     */
    public let inheritedTypes: [String]
    
    /**
     List of class properties.
     */
    public let properties: [PropertyDescription]
    
    /**
     Class methods.
     */
    public let methods: [MethodDescription]
    
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
        
        let inheritedTypesStr: String = inheritedTypes.isEmpty ? "" : ": " + inheritedTypes.joined(separator: ", ")
        
        let propertiesStr: String
        if properties.isEmpty {
            propertiesStr = ""
        } else {
            propertiesStr = properties.reduce("\n") { (result: String, property: PropertyDescription) -> String in
                if properties.last == property {
                    return result + property.verse.indent + "\n"
                }
                return result + property.verse.indent + "\n\n"
            }
        }
        
        let methodsStr: String
        if methods.isEmpty {
            methodsStr = ""
        } else {
            methodsStr = methods.reduce("\n") { (result: String, method: MethodDescription) -> String in
                if methods.last == method {
                    return result + method.verse.indent + "\n"
                }
                return result + method.verse.indent + "\n\n"
            }
        }
        
        return """
            \(commentStr)\(accessibilityStr)class \(name)\(inheritedTypesStr) {\(propertiesStr)\(methodsStr)}\n
            """
    }
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(
        comment: String?,
        annotations: [Annotation],
        declaration: Declaration,
        accessibility: Accessibility,
        name: String,
        inheritedTypes: [String],
        properties: [PropertyDescription],
        methods: [MethodDescription]
    ) {
        self.comment        = comment
        self.annotations    = annotations
        self.declaration    = declaration
        self.accessibility  = accessibility
        self.name           = name
        self.inheritedTypes = inheritedTypes
        self.properties     = properties
        self.methods        = methods
    }
    
    public static func template(
        comment: String?,
        accessibility: Accessibility,
        name: String,
        inheritedTypes: [String],
        properties: [PropertyDescription],
        methods: [MethodDescription]
    ) -> ClassDescription {
        return ClassDescription(
            comment: comment,
            annotations: [],
            declaration: Declaration.mock,
            accessibility: accessibility,
            name: name,
            inheritedTypes: inheritedTypes,
            properties: properties,
            methods: methods
        )
    }
    
    public var debugDescription: String {
        if inheritedTypes.isEmpty {
            return "CLASS: name = \(name)"
        }
        return "CLASS: name = \(name); inherited = \(inheritedTypes.joined(separator: ", "))"
    }
    
}
