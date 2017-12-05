//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


struct CompiledStructure {
    let file: GoodFile
    let structure: SwiftDocs
    
    var topElements: [[String: AnyObject]] {
        return structure.docsDictionary.subsctructure
    }
    
    init(structure: SwiftDocs, file: GoodFile) {
        self.structure = structure
        self.file      = file
    }
    
    init?(file: GoodFile) {
        if let docs: SwiftDocs = SwiftDocs(file: file.file, arguments: [CompilerArgument.buildSymbols, file.path.path]) {
            self.init(structure: docs, file: file)
            return
        }
        
        return nil
    }
    
    private enum CompilerArgument {
        static let buildSymbols: String = "-j4"
    }
}
