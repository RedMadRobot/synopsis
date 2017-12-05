//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Enum description.
 */
public struct EnumDescription: Equatable, CustomDebugStringConvertible {

    /**
     Documentation comment above the enum.
     */
    public let comment: String?
    
    /**
     Enum annotations.
     
     Enum annotations are located inside the block comment above the enum declaration.
     */
    public let annotations: [Annotation]
    
    /**
     Enum declaration line.
     */
    public let declaration: Declaration
    
    /**
     Access visibility.
     */
    public let accessibility: Accessibility
    
    /**
     Name of the enum.
     */
    public let name: String
    
    /**
     Inherited protocols, classes, structs etc.
     */
    public let inheritedTypes: [String]
    
    /**
     Cases.
     */
    public let cases: [EnumCase]
    
    /**
     List of enum properties.
     */
    public let properties: [PropertyDescription]
    
    /**
     Enum methods.
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
        
        let casesStr: String
        if cases.isEmpty {
            casesStr = ""
        } else {
            casesStr = cases.reduce("\n") { (result: String, enumCase: EnumCase) -> String in
                if cases.last == enumCase {
                    return result + enumCase.verse.indent + "\n"
                }
                return result + enumCase.verse.indent + "\n\n"
            }
        }
        
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
            \(commentStr)\(accessibilityStr)enum \(name)\(inheritedTypesStr) {\(casesStr)\(propertiesStr)\(methodsStr)}\n
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
        cases: [EnumCase],
        properties: [PropertyDescription],
        methods: [MethodDescription]
    ) {
        self.comment        = comment
        self.annotations    = annotations
        self.declaration    = declaration
        self.accessibility  = accessibility
        self.name           = name
        self.inheritedTypes = inheritedTypes
        self.cases          = cases
        self.properties     = properties
        self.methods        = methods
    }
    
    /**
     Make a template enum for later code generation.
     */
    public static func template(
        comment: String?,
        accessibility: Accessibility,
        name: String,
        inheritedTypes: [String],
        cases: [EnumCase],
        properties: [PropertyDescription],
        methods: [MethodDescription]
    ) -> EnumDescription {
        return EnumDescription(
            comment: comment,
            annotations: [],
            declaration: Declaration.mock,
            accessibility: accessibility,
            name: name,
            inheritedTypes: inheritedTypes,
            cases: cases,
            properties: properties,
            methods: methods
        )
    }
    
    public static func ==(left: EnumDescription, right: EnumDescription) -> Bool {
        return left.comment        == right.comment
            && left.annotations    == right.annotations
            && left.declaration    == right.declaration
            && left.accessibility  == right.accessibility
            && left.name           == right.name
            && left.inheritedTypes == right.inheritedTypes
            && left.cases          == right.cases
            && left.properties     == right.properties
            && left.methods        == right.methods
    }
    
    public var debugDescription: String {
        if inheritedTypes.isEmpty {
            return "ENUM: name = \(name)"
        }
        return "ENUM: name = \(name); inherited = \(inheritedTypes.joined(separator: ", "))"
    }
    
}
