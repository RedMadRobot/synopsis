//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Meta-information about classes, protocols, structures, properties, methods and method arguments located in the nearby
 documentation comments.
 */
public struct Annotation: Equatable, CustomDebugStringConvertible {
    
    /**
     Name of the annotation; doesn't include "@" symbol.
     */
    public let name: String
    
    /**
     Value of the annotation; optional, contains first word after annotation name, if any.
     
     Inline annotations may be divided by semicolon, which may go immediately after annotation name
     in case annotation doesn't have any value.
     */
    public let value: String?
    
    /**
     Annotation declaration.
     */
    public let declaration: Declaration? // FIXME: Make mandatory
    
    /**
     Write down own source code.
     */
    public var verse: String {
        return "@\(name)" + (nil != value ? " \(value!)" : "")
    }
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(name: String, value: String?, declaration: Declaration?) {
        self.name           = name
        self.value          = value
        self.declaration    = declaration
    }
    
    public static func ==(left: Annotation, right: Annotation) -> Bool {
        return left.name        == right.name
            && left.value       == right.value
            && left.declaration == right.declaration
    }
    
    public var debugDescription: String {
        return "ANNOTATION: name = \(name)" + (nil != value ? "; value = \(value!)" : "")
    }
    
}


public extension Sequence where Iterator.Element == Annotation {
    
    public subscript(annotationName: String) -> Iterator.Element? {
        for item in self {
            if item.name == annotationName {
                return item
            }
        }
        return nil
    }
    
    public func contains(annotationName: String) -> Bool {
        return nil != self[annotationName]
    }
    
}
