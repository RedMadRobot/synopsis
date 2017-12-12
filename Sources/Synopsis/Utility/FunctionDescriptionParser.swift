//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class FunctionDescriptionParser<Function: FunctionDescription> {
    
    func parse(files pathList: [URL]) -> ParsingResult<Function> {
        var ioErrors: [SynopsisError] = []
        
        let files: [GoodFile] = pathList.flatMap { (fileURL: URL) -> GoodFile? in
            if let file = File(path: fileURL.path) {
                return GoodFile(path: fileURL, file: file)
            }
            
            ioErrors.append(SynopsisError.errorReadingFile(file: fileURL))
            return nil
        }
        
        let result: ParsingResult<Function> = parse(files: files)
        return ParsingResult(errors: result.errors + ioErrors, models: result.models)
    }
    
    func parse(files: [GoodFile]) -> ParsingResult<Function> {
        var compilingErrors: [SynopsisError] = []
        
        let compiledStructures: [CompiledStructure] = files.flatMap { (goodFile: GoodFile) -> CompiledStructure? in
            if let structure: CompiledStructure = CompiledStructure(file: goodFile) {
                return structure
            }
            
            compilingErrors.append(SynopsisError.errorCompilingFile(file: goodFile.path))
            return nil
        }
        
        let result: [Function] = translate(compiledStructures)
        return ParsingResult(errors: compilingErrors, models: result)
    }
    
    func isRawFunctionDescription(_ element: [String: AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false }
        return SwiftDeclarationKind.functionFree.rawValue == kind
    }
    
    func parse(rawStructureElements: [[String: AnyObject]], file: GoodFile) -> [Function] {
        return rawStructureElements
            .filter { isRawFunctionDescription($0) }
            .map { (rawFunctionDescription: [String: AnyObject]) -> Function in
                let declarationOffset: Int    = rawFunctionDescription.offset
                let declarationString: String =
                    deduceDeclaration(
                        rawFunctionDescription: rawFunctionDescription,
                        file: file.file.contents,
                        declarationOffset: declarationOffset
                    )
                
                let name:           String                  = rawFunctionDescription.name
                let comment:        String?                 = rawFunctionDescription.comment
                let annotations:    [Annotation]            = nil != comment ? AnnotationParser().parse(comment: comment!) : []
                let accessibility:  Accessibility           = Accessibility.deduce(forRawStructureElement: rawFunctionDescription)
                let typename:       String                  = rawFunctionDescription.typename
                let returnType:     TypeDescription?        = TypeParser().parse(functionTypename: typename, declarationString: declarationString)
                let kind:           Function.Kind           = getKind(rawFunctionDescription: rawFunctionDescription)
                let body:           String?                 = getBody(rawFunctionDescription: rawFunctionDescription, file: file)
                let arguments:      [ArgumentDescription]   = ArgumentDescriptionParser().parse(functionParsedDeclaration: declarationString)
                
                let declaration: Declaration =
                    Declaration(
                        filePath: file.path,
                        fileContents: file.file.contents,
                        rawText: declarationString,
                        offset: declarationOffset
                    )
                
                return Function(
                    comment: comment,
                    annotations: annotations,
                    accessibility: accessibility,
                    name: name,
                    arguments: arguments,
                    returnType: returnType,
                    declaration: declaration,
                    kind: kind,
                    body: body
                )
            }
    }
}


private extension FunctionDescriptionParser {
    
    func deduceDeclaration(rawFunctionDescription: [String: AnyObject], file: String, declarationOffset: Int) -> String {
        /**
         Sometimes SourceKit can't accurately parse full method declaration
         This constantly happens for multiline method declarations in protocols, where
         
         func abc(
            argument: Int
         ) -> String
         
         gets truncated to "func abc(".
         
         This is why defaultDeclarationString needs to be checked.
         */
        let defaultDeclarationString: String = rawFunctionDescription.parsedDeclaration
        let defaultDeclarationLex = LexemeString(defaultDeclarationString)
        
        // Simple check searches for the right round bracket:
        for index in defaultDeclarationString.indices {
            if defaultDeclarationLex.inSourceCodeRange(index) && ")" == defaultDeclarationString[index] {
                return defaultDeclarationString
            }
        }
        // defaultDeclarationString is enough for most cases.
        
        // If defaultDeclarationString is not enough, full method declaration needs to be parsed manually
        let startIndex: String.Index    = file.index(file.startIndex, offsetBy: declarationOffset)
        let endIndex:   String.Index    = file.index(startIndex, offsetBy: rawFunctionDescription.length)
        let fullText:   String          = String(file[startIndex...endIndex])
        let fullTextLex                 = LexemeString(fullText)
        
        var declarationString: String = ""
        for index in fullText.indices {
            // Detect the end of method signature by the opening curly brace:
            if fullTextLex.inSourceCodeRange(index) && "{" == fullText[index] { break }
            declarationString.append(fullText[index])
        }
        
        return declarationString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func translate(_ structures: [CompiledStructure]) -> [Function] {
        return structures.flatMap { translate($0) }
    }
    
    func translate(_ structure: CompiledStructure) -> [Function] {
        return parse(rawStructureElements: structure.topElements, file: structure.file)
        
    }
    
    func getKind(rawFunctionDescription: [String: AnyObject]) -> Function.Kind {
        guard let kind: String = rawFunctionDescription.kind
        else { return Function.Kind.free }
        
        switch kind {
            case SwiftDeclarationKind.functionMethodInstance.rawValue: return Function.Kind.instance
            case SwiftDeclarationKind.functionMethodClass.rawValue:    return Function.Kind.`class`
            case SwiftDeclarationKind.functionMethodStatic.rawValue:   return Function.Kind.`static`
            
            default: return Function.Kind.free
        }
    }
    
    func getBody(rawFunctionDescription: [String: AnyObject], file: GoodFile) -> String? {
        guard
            let bodyOffset: Int = rawFunctionDescription.bodyOffset,
            let bodyLength: Int = rawFunctionDescription.bodyLength
        else {
                return nil
        }
        
        let fileContents: String = file.file.contents
        
        let bodyStartIndex: String.Index = fileContents.index(fileContents.startIndex, offsetBy: bodyOffset)
        let bodyEndIndex:   String.Index = fileContents.index(bodyStartIndex, offsetBy: bodyLength)
        
        return String(fileContents[bodyStartIndex..<bodyEndIndex])
    }
    
}
