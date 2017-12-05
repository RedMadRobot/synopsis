//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class EnumCaseParser {
    
    func parse(rawStructureElements: [[String: AnyObject]], file: GoodFile) -> [EnumCase] {
        return rawStructureElements
            .filter { isRawEnumCaseDescription($0) }
            .flatMap { (rawEnumCaseDescription: [String: AnyObject]) -> [EnumCaseElement] in
                /**
                 Each enum case may contain multiple options:
                 
                 enum MyEnum {
                    case option1, option2
                 }
                 
                 Our goal is to flat them out.
                */
                let offset: Int = rawEnumCaseDescription.offset
                return rawEnumCaseDescription.subsctructure.map { EnumCaseElement(offset: offset, structure: $0) }
            }
            .map { (enumCaseElement: EnumCaseElement) -> EnumCase in
                let parsedDeclaration: String   = enumCaseElement.structure.parsedDeclaration
                
                let comment:        String?         = enumCaseElement.structure.comment
                let annotations:    [Annotation]    = nil != comment ? AnnotationParser().parse(comment: comment!) : []
                let name:           String          = enumCaseElement.structure.name
                let defaultValue:   String?         = getDefaultValue(fromParsedDeclaration: parsedDeclaration)
                
                let declaration: Declaration =
                    Declaration(
                        filePath: file.path,
                        fileContents: file.file.contents,
                        rawText: parsedDeclaration,
                        offset: enumCaseElement.offset
                    )
                
                return EnumCase(
                    comment: comment,
                    annotations: annotations,
                    name: name,
                    defaultValue: defaultValue,
                    declaration: declaration
                )
            }
    }
    
}


private extension EnumCaseParser {
    
    struct EnumCaseElement {
        let offset: Int
        let structure: [String: AnyObject]
    }
    
    func isRawEnumCaseDescription(_ element: [String: AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false }
        return SwiftDeclarationKind.enumcase.rawValue == kind
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
    
}
