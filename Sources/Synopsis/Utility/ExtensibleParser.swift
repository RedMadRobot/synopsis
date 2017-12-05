//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class ExtensibleParser<Model: Extensible> {
    
    func parse(files pathList: [URL]) -> ParsingResult<Model> {
        var ioErrors: [SynopsisError] = []
        
        let files: [GoodFile] = pathList.flatMap { (fileURL: URL) -> GoodFile? in
            if let file = File(path: fileURL.path) {
                return GoodFile(path: fileURL, file: file)
            }
            
            ioErrors.append(SynopsisError.errorReadingFile(file: fileURL))
            return nil
        }
        
        let result: ParsingResult<Model> = parse(files: files)
        return ParsingResult(errors: result.errors + ioErrors, models: result.models)
    }
    
    func parse(files: [GoodFile]) -> ParsingResult<Model> {
        var compilingErrors: [SynopsisError] = []
        
        let compiledStructures: [CompiledStructure] = files.flatMap { (goodFile: GoodFile) -> CompiledStructure? in
            if let structure: CompiledStructure = CompiledStructure(file: goodFile) {
                return structure
            }
            
            compilingErrors.append(SynopsisError.errorCompilingFile(file: goodFile.path))
            return nil
        }
        
        let result: [Model] = translate(compiledStructures)
        return ParsingResult(errors: compilingErrors, models: result)
    }
    
    func isRawExtensibleDescription(_ element: [String: AnyObject]) -> Bool {
        return false
    }
    
}


private extension ExtensibleParser {
    
    func translate(_ structures: [CompiledStructure]) -> [Model] {
        return structures.flatMap { translate($0) }
    }
    
    func translate(_ structure: CompiledStructure) -> [Model] {
        let topStructureElements = structure.topElements
        
        let extensibles: [Model] =
            topStructureElements
                .filter { isRawExtensibleDescription($0) }
                .map { (rawExtensibleDescription: [String: AnyObject]) -> Model in
                    let declarationOffset:     Int = rawExtensibleDescription.offset
                    let declarationRawText: String = rawExtensibleDescription.parsedDeclaration
                    let rawStructureElements  = rawExtensibleDescription.subsctructure
                    
                    let comment:        String?         = rawExtensibleDescription.comment
                    let annotations:    [Annotation]    = nil != comment ? AnnotationParser().parse(comment: comment!) : []
                    let accessibility:  Accessibility   = Accessibility.deduce(forRawStructureElement: rawExtensibleDescription)
                    let name:           String          = rawExtensibleDescription.name
                    let inheritedTypes: [String]        = rawExtensibleDescription.inheritedTypes
                    
                    let declaration: Declaration =
                        Declaration(
                            filePath: structure.file.path,
                            fileContents: structure.file.file.contents,
                            rawText: declarationRawText,
                            offset: declarationOffset
                        )
                    
                    let properties: [PropertyDescription] =
                        PropertyDescriptionParser().parse(rawStructureElements: rawStructureElements, file: structure.file)
                    
                    let methods: [MethodDescription] =
                        MethodDescriptionParser().parse(rawStructureElements: rawStructureElements, file: structure.file)
                    
                    return Model(
                        comment: comment,
                        annotations: annotations,
                        declaration: declaration,
                        accessibility: accessibility,
                        name: name,
                        inheritedTypes: inheritedTypes,
                        properties: properties,
                        methods: methods
                    )
                }
        
        return extensibles
    }
    
}
