//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Type of class properties, methods, method arguments, variables etc.
 */
public indirect enum TypeDescription: Equatable, CustomStringConvertible {
    
    /**
     Boolean.
     */
    case boolean
    
    /**
     Anything, which contains "Int" in it: Int, Int16, Int32, Int64, UInt etc.
     */
    case integer
    
    /**
     Float.
     */
    case floatingPoint
    
    /**
     Double.
     */
    case doublePrecision
    
    /**
     String
     */
    case string
    
    /**
     Date (formerly known as NSDate).
     */
    case date
    
    /**
     Data (formerly known as NSData).
     */
    case data
    
    /**
     Void.
     */
    case void
    
    /**
     Anything optional; wraps actual type.
     */
    case optional(wrapped: TypeDescription)
    
    /**
     Classes, structures, enums & protocol. Except for Date, Data and collections of any kind.
     */
    case object(name: String)
    
    /**
     Array collection.
     */
    case array(element: TypeDescription)
    
    /**
     Map/dictionary collection.
     */
    case map(key: TypeDescription, value: TypeDescription)
    
    /**
     Generic type.
     
     Like `object`, contains type name and also contains type for item in corner brakets.
     */
    case generic(name: String, constraints: [TypeDescription])
    
    /**
     Write down own source code.
     
     ???: use .description
     */
    public var verse: String {
        switch self {
            case .boolean: return "Bool"
            case .integer: return "Int"
            case .floatingPoint: return "Float"
            case .doublePrecision: return "Double"
            case .string: return "String"
            case .date: return "Date"
            case .data: return "Data"
            case .void: return "Void"
            case .optional(let wrapped): return "\(wrapped.verse)?"
            case .object(let name): return name
            case .array(let element): return "[\(element.verse)]"
            case .map(let key, let value): return "[\(key.verse): \(value.verse)]"
            case .generic(let name, let constraints):
                let constraintsString: String = constraints.map { "\($0.verse)" }.joined(separator: ", ")
                return "\(name)<\(constraintsString)>"
        }
    }
    
    public var description: String {
        switch self {
            case .boolean: return "Bool"
            case .integer: return "Int"
            case .floatingPoint: return "Float"
            case .doublePrecision: return "Double"
            case .string: return "String"
            case .date: return "Date"
            case .data: return "Data"
            case .void: return "Void"
            case let .optional(wrapped): return "\(wrapped)?"
            case let .object(name): return "\(name)"
            case let .array(item): return "[\(item)]"
            case let .map(key, value): return "[\(key): \(value)]"
            case let .generic(name, constraints):
                let constraintsString: String = constraints.map { "\($0)" }.joined(separator: ", ")
                return "\(name)<\(constraintsString)>"
        }
    }
    
    public static func ==(left: TypeDescription, right: TypeDescription) -> Bool {
        switch (left, right) {
            case (TypeDescription.boolean, TypeDescription.boolean):
                return true
            
            case (TypeDescription.integer, TypeDescription.integer):
                return true
            
            case (TypeDescription.floatingPoint, TypeDescription.floatingPoint):
                return true
            
            case (TypeDescription.doublePrecision, TypeDescription.doublePrecision):
                return true
            
            case (TypeDescription.date, TypeDescription.date):
                return true
            
            case (TypeDescription.data, TypeDescription.data):
                return true
            
            case (TypeDescription.string, TypeDescription.string):
                return true
            
            case (TypeDescription.void, TypeDescription.void):
                return true
            
            case (let TypeDescription.optional(wrappedLeft), let TypeDescription.optional(wrappedRight)):
                return wrappedLeft == wrappedRight
            
            case (let TypeDescription.object(name: leftName), let TypeDescription.object(name: rightName)):
                return leftName == rightName
            
            case (let TypeDescription.array(element: leftItem), let TypeDescription.array(element: rightItem)):
                return leftItem == rightItem
            
            case (let TypeDescription.map(key: leftKey, value: leftValue), let TypeDescription.map(key: rightKey, value: rightValue)):
                return leftKey == rightKey
                    && leftValue == rightValue
            
            case (let TypeDescription.generic(name: leftName, constraints: leftConstraints), let TypeDescription.generic(name: rightName, constraints: rightConstraints)):
                return leftName == rightName
                    && leftConstraints == rightConstraints
            
            default:
                return false
        }
    }
    
}
