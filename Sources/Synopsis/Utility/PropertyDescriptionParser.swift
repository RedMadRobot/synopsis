//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class PropertyDescriptionParser {
    
    func parse(rawStructureElements: [[String: AnyObject]], file: GoodFile) -> [PropertyDescription] {
        return rawStructureElements
            .filter { isInstanceVariableDescription($0) }
            .map { (rawPropertyDescription: [String: AnyObject]) -> PropertyDescription in
                let parsedDeclaration: String   = rawPropertyDescription.parsedDeclaration
                let declarationOffset: Int      = rawPropertyDescription.offset
                
                let comment:        String?         = rawPropertyDescription.comment
                let annotations:    [Annotation]    = nil != comment ? AnnotationParser().parse(comment: comment!) : []
                let accessibility:  Accessibility   = Accessibility.deduce(forRawStructureElement: rawPropertyDescription)
                let constant:       Bool            = parsedDeclaration.contains("let ")
                let name:           String          = rawPropertyDescription.name
                let type:           TypeDescription = TypeParser().parse(rawDescription: rawPropertyDescription)
                let defaultValue:   String?         = getDefaultValue(fromParsedDeclaration: parsedDeclaration)
                let body:           String?         = getBody(rawPropertyDescription: rawPropertyDescription, file: file)
                
                let kind: PropertyDescription.Kind  = getKind(rawPropertyDescription: rawPropertyDescription)
                
                let declaration: Declaration =
                    Declaration(
                        filePath: file.path,
                        fileContents: file.file.contents,
                        rawText: parsedDeclaration,
                        offset: declarationOffset
                    )
                
                return PropertyDescription(
                    comment: comment,
                    annotations: annotations,
                    accessibility: accessibility,
                    constant: constant,
                    name: name,
                    type: type,
                    defaultValue: defaultValue,
                    declaration: declaration,
                    kind: kind,
                    body: body
                )
        }
    }
    
}


private extension PropertyDescriptionParser {
    
    func isInstanceVariableDescription(_ element: [String: AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false }
        return SwiftDeclarationKind.varInstance.rawValue == kind
            || SwiftDeclarationKind.varClass.rawValue    == kind
            || SwiftDeclarationKind.varStatic.rawValue   == kind
    }
    
    func getDefaultValue(fromParsedDeclaration parsedDeclaration: String) -> String? {
        let lex = LexemeString(parsedDeclaration)
        
        for index in parsedDeclaration.indices {
            if "=" == parsedDeclaration[index] && lex.inSourceCodeRange(index) {
                let defaultValueStart: String.Index = parsedDeclaration.index(after: index)
                return parsedDeclaration[defaultValueStart...].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        }
        
        return nil
    }
    
    func getBody(rawPropertyDescription: [String: AnyObject], file: GoodFile) -> String? {
        guard
            let bodyOffset: Int = rawPropertyDescription.bodyOffset,
            let bodyLength: Int = rawPropertyDescription.bodyLength
        else {
            return nil
        }
        
        let fileContents: String = file.file.contents
        
        let bodyStartIndex: String.Index = fileContents.index(fileContents.startIndex, offsetBy: bodyOffset)
        let bodyEndIndex:   String.Index = fileContents.index(bodyStartIndex, offsetBy: bodyLength)
        
        return String(fileContents[bodyStartIndex..<bodyEndIndex])
    }
    
    func getKind(rawPropertyDescription: [String: AnyObject]) -> PropertyDescription.Kind {
        guard let kind: String = rawPropertyDescription.kind
        else { return PropertyDescription.Kind.instance }
        
        switch kind {
            case SwiftDeclarationKind.varStatic.rawValue: return PropertyDescription.Kind.`static`
            case SwiftDeclarationKind.varClass.rawValue: return PropertyDescription.Kind.`class`
            
            default: return PropertyDescription.Kind.instance
        }
    }
    
}
