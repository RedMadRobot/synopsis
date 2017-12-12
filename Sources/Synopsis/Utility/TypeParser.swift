//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class TypeParser {
    
    func parse(rawDescription: [String: AnyObject]) -> TypeDescription {
        let typename:    String = rawDescription.typename
        let declaration: String = rawDescription.parsedDeclaration
        
        switch typename {
            // TODO: incorporate all possible rawDescription.typename values
            case "Bool": return TypeDescription.boolean
            case "Int": return TypeDescription.integer
            case "Float": return TypeDescription.floatingPoint
            case "Double": return TypeDescription.doublePrecision
            case "String": return TypeDescription.string
            case "Void": return TypeDescription.void
            
            default: return deduceType(fromDeclaration: declaration)
        }
    }
    
    func parse(functionTypename: String) -> TypeDescription? {
        let returnTypename: String =
            String(functionTypename.split(separator: " ").last!)
        
        switch returnTypename {
            case "()", "Void": return TypeDescription.void
            
            case "Bool": return TypeDescription.boolean
            case "Int": return TypeDescription.integer
            case "Float": return TypeDescription.floatingPoint
            case "Double": return TypeDescription.doublePrecision
            case "String": return TypeDescription.string
            
            default: return parse(rawType: returnTypename)
        }
    }
    
    func deduceType(fromDeclaration declaration: String) -> TypeDescription {
        if let type: TypeDescription = parseExplicitType(fromDeclaration: declaration) {
            return type
        }
        
        return deduceType(fromDefaultValue: declaration)
    }
}


private extension TypeParser {
    
    func parseExplicitType(fromDeclaration declaration: String) -> TypeDescription? {
        guard declaration.contains(":")
        else { return nil }
        
        let declarationWithoutDefultValue: String =
            declaration
                .truncateAfter(word: "=", deleteWord: true)
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let typename: String =
            declarationWithoutDefultValue
                .truncateUntilExist(word: ":")
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return parse(rawType: typename)
    }
    
    func deduceType(fromDefaultValue declaration: String) -> TypeDescription {
        guard declaration.contains("=")
        else { return TypeDescription.object(name: "") }
        
        let defaultValue: String =
            declaration
                .truncateUntilExist(word: "=")
                .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return guessType(ofVariableValue: defaultValue)
    }
    
    /**
     Parse raw type line without any other garbage.
     
     ```MyType<[Entity]>```
     */
    func parse(rawType: String) -> TypeDescription {
        // check type ends with ?
        if rawType.hasSuffix("?") {
            return TypeDescription.optional(
                wrapped: parse(rawType: String(rawType.dropLast()))
            )
        }
        
        if rawType.contains("<") && rawType.contains(">") {
            let name: String = rawType.truncateAfter(word: "<", deleteWord: true).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let itemName: String = String(rawType.truncateUntilExist(word: "<").truncateAfter(word: ">", deleteWord: true))
            let itemType: TypeDescription = self.parse(rawType: itemName)
            return TypeDescription.generic(name: name, constraints: [itemType])
        }
        
        if rawType.contains("[") && rawType.contains("]") {
            let collecitonItemTypeName: String =
                rawType
                    .truncateUntilExist(word: "[")
                    .truncateAfter(word: "]", deleteWord: true)
                    .trimmingCharacters(in: CharacterSet.whitespaces)
            return self.parseCollectionItemType(collecitonItemTypeName)
        }
        
        if rawType == "Bool" {
            return TypeDescription.boolean
        }
        
        if rawType.contains("Int") {
            return TypeDescription.integer
        }
        
        if rawType == "Float" {
            return TypeDescription.floatingPoint
        }
        
        if rawType == "Double" {
            return TypeDescription.doublePrecision
        }
        
        if rawType == "Date" {
            return TypeDescription.date
        }
        
        if rawType == "Data" {
            return TypeDescription.data
        }
        
        if rawType == "String" {
            return TypeDescription.string
        }
        
        if rawType == "Void" {
            return TypeDescription.void
        }
        
        var objectTypeName: String = String(rawType.firstWord())
        if objectTypeName.last == "?" {
            objectTypeName = String(objectTypeName.dropLast())
        }
        
        return TypeDescription.object(name: objectTypeName)
    }

    func guessType(ofVariableValue value: String) -> TypeDescription {
        // collections are not supported yet
        if value.contains("[") {
            return TypeDescription.object(name: "")
        }
        
        // check value is text in quotes:
        // let abc = "abcd"
        if let _ = value.range(of: "^\"(.*)\"$", options: .regularExpression) {
            return TypeDescription.string
        }
        
        // check value is double:
        // let abc = 123.45
        if let _ = value.range(of: "^(\\d+)\\.(\\d+)$", options: .regularExpression) {
            return TypeDescription.doublePrecision
        }
        
        // check value is int:
        // let abc = 123
        if let _ = value.range(of: "^(\\d+)$", options: .regularExpression) {
            return TypeDescription.integer
        }
        
        // check value is bool
        // let abc = true
        if value.contains("true") || value.contains("false") {
            return TypeDescription.boolean
        }
        
        // check value contains object init statement:
        // let abc = Object(some: 123)
        if let _ = value.range(of: "^(\\w+)\\((.*)\\)$", options: .regularExpression) {
            let rawValueTypeName: String = String(value.truncateAfter(word: "(", deleteWord: true))
            return parse(rawType: rawValueTypeName)
        }
        
        return TypeDescription.object(name: "")
    }
    
    func parseCollectionItemType(_ collecitonItemTypeName: String) -> TypeDescription {
        if collecitonItemTypeName.contains(":") {
            let keyTypeName:   String = String(collecitonItemTypeName.truncateAfter(word: ":", deleteWord: true))
            let valueTypeName: String = String(collecitonItemTypeName.truncateUntilExist(word: ":"))
            
            return TypeDescription.map(key: self.parse(rawType: keyTypeName), value: self.parse(rawType: valueTypeName))
        } else {
            return TypeDescription.array(element: self.parse(rawType: collecitonItemTypeName))
        }
    }
    
}
