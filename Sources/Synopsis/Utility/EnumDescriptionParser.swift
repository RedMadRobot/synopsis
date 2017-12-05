//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class EnumDescriptionParser {
    
    func parse(files pathList: [URL]) -> ParsingResult<EnumDescription> {
        var ioErrors: [SynopsisError] = []
        
        let files: [GoodFile] = pathList.flatMap { (fileURL: URL) -> GoodFile? in
            if let file = File(path: fileURL.path) {
                return GoodFile(path: fileURL, file: file)
            }
            
            ioErrors.append(SynopsisError.errorReadingFile(file: fileURL))
            return nil
        }
        
        let result: ParsingResult<EnumDescription> = parse(files: files)
        return ParsingResult(errors: result.errors + ioErrors, models: result.models)
    }
    
    func parse(files: [GoodFile]) -> ParsingResult<EnumDescription> {
        var compilingErrors: [SynopsisError] = []
        
        let compiledStructures: [CompiledStructure] = files.flatMap { (goodFile: GoodFile) -> CompiledStructure? in
            if let structure: CompiledStructure = CompiledStructure(file: goodFile) {
                return structure
            }
            
            compilingErrors.append(SynopsisError.errorCompilingFile(file: goodFile.path))
            return nil
        }
        
        let result: [EnumDescription] = translate(compiledStructures)
        return ParsingResult(errors: compilingErrors, models: result)
    }
    
}


private extension EnumDescriptionParser {
    
    func translate(_ structures: [CompiledStructure]) -> [EnumDescription] {
        return structures.flatMap { translate($0) }
    }
    
    func translate(_ structure: CompiledStructure) -> [EnumDescription] {
        let topStructureElements = structure.topElements
        
        let enums: [EnumDescription] =
            topStructureElements
                .filter { isRawEnumDescription($0) }
                .map { (rawEnumDescription: [String: AnyObject]) -> EnumDescription in
                    let declarationOffset:     Int = rawEnumDescription.offset
                    let declarationRawText: String = rawEnumDescription.parsedDeclaration
                    let rawStructureElements  = rawEnumDescription.subsctructure
                    
                    let comment:        String?         = rawEnumDescription.comment
                    let annotations:    [Annotation]    = nil != comment ? AnnotationParser().parse(comment: comment!) : []
                    let accessibility:  Accessibility   = Accessibility.deduce(forRawStructureElement: rawEnumDescription)
                    let name:           String          = rawEnumDescription.name
                    let inheritedTypes: [String]        = rawEnumDescription.inheritedTypes
                    
                    let declaration: Declaration =
                        Declaration(
                            filePath: structure.file.path,
                            fileContents: structure.file.file.contents,
                            rawText: declarationRawText,
                            offset: declarationOffset
                        )
                    
                    let cases: [EnumCase] =
                        EnumCaseParser().parse(rawStructureElements: rawStructureElements, file: structure.file)
                    
                    let properties: [PropertyDescription] =
                        PropertyDescriptionParser().parse(rawStructureElements: rawStructureElements, file: structure.file)
                    
                    let methods: [MethodDescription] =
                        MethodDescriptionParser().parse(rawStructureElements: rawStructureElements, file: structure.file)
                    
                    return EnumDescription(
                        comment: comment,
                        annotations: annotations,
                        declaration: declaration,
                        accessibility: accessibility,
                        name: name,
                        inheritedTypes: inheritedTypes,
                        cases: cases,
                        properties: properties,
                        methods: methods
                    )
                }
        
        return enums
    }
    
    func isRawEnumDescription(_ element: [String: AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false }
        return SwiftDeclarationKind.`enum`.rawValue == kind
    }
    
}
