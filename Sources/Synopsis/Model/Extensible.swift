//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Basically, protocols, structs and classes.
 */
public protocol Extensible: Equatable, CustomDebugStringConvertible {
    
    /**
     Documentation comment above the extensible.
     */
    var comment: String? { get }
    
    /**
     Annotations.
     
     Annotations are located inside the comment.
     */
    var annotations: [Annotation] { get }
    
    /**
     Declaration.
     */
    var declaration: Declaration { get }
    
    /**
     Access visibility.
     */
    var accessibility: Accessibility { get }
    
    /**
     Name.
     */
    var name: String { get }
    
    /**
     Inherited types: parent class/classes, protocols etc.
     */
    var inheritedTypes: [String] { get }
    
    /**
     List of properties.
     */
    var properties: [PropertyDescription] { get }
    
    /**
     List of methods.
     */
    var methods: [MethodDescription] { get }
    
    /**
     Write down own source code.
     */
    var verse: String { get }
    
    init(
        comment: String?,
        annotations: [Annotation],
        declaration: Declaration,
        accessibility: Accessibility,
        name: String,
        inheritedTypes: [String],
        properties: [PropertyDescription],
        methods: [MethodDescription]
    )
    
}


public func ==<E: Extensible>(left: E, right: E) -> Bool {
    return left.comment        == right.comment
        && left.annotations    == right.annotations
        && left.declaration    == right.declaration
        && left.accessibility  == right.accessibility
        && left.name           == right.name
        && left.inheritedTypes == right.inheritedTypes
        && left.properties     == right.properties
        && left.methods        == right.methods
}


public extension Sequence where Iterator.Element: Extensible {
    
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
