//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Source code element declaration.
 
 Includes absolute file path, line number, column number, offset and raw declaration text itself.
 */
public struct Declaration: Equatable {
    
    /**
     File, where statement is declared.
     */
    public let filePath: URL
    
    /**
     Parsed condensed declaration.
     */
    public let rawText: String
    
    /**
     How many characters to skip.
     */
    public let offset: Int
    
    /**
     Calculated line number.
     */
    public let lineNumber: Int
    
    /**
     Calculated column number.
     */
    public let columnNumber: Int
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(
        filePath: URL,
        rawText: String,
        offset: Int,
        lineNumber: Int,
        columnNumber: Int
    ) {
        self.filePath       = filePath
        self.rawText        = rawText
        self.offset         = offset
        self.lineNumber     = lineNumber
        self.columnNumber   = columnNumber
    }
    
    public init(
        filePath: URL,
        fileContents: String,
        rawText: String,
        offset: Int
    ) {
        let offsetIndex: String.Index = fileContents.index(fileContents.startIndex, offsetBy: offset)
        let textBeforeDeclaration: Substring = fileContents[..<offsetIndex]
        let textBeforeDeclarationLines: [String] = textBeforeDeclaration.components(separatedBy: "\n")
        let lineNumber: Int = textBeforeDeclarationLines.count
        let columnNumber: Int = (textBeforeDeclarationLines.last?.count ?? 0) + 1
        
        self.init(
            filePath: filePath,
            rawText: rawText,
            offset: offset,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public init?(
        filePath: URL,
        rawText: String,
        offset: Int
    ) throws {
        let fileContents: String = try! String(contentsOf: filePath)
        self.init(filePath: filePath, fileContents: fileContents, rawText: rawText, offset: offset)
    }
    
    public static func ==(left: Declaration, right: Declaration) -> Bool {
        return left.filePath        == right.filePath
            && left.rawText         == right.rawText
            && left.offset          == right.offset
            && left.lineNumber      == right.lineNumber
            && left.columnNumber    == right.columnNumber
    }
    
    public static let mock = Declaration(
        filePath: URL(fileURLWithPath: Declaration.MockProperties.filePath),
        rawText: Declaration.MockProperties.rawText,
        offset: Declaration.MockProperties.offset,
        lineNumber: Declaration.MockProperties.lineNumber,
        columnNumber: Declaration.MockProperties.columnNumber
    )
    
    private enum MockProperties {
        static let filePath     = ""
        static let rawText      = ""
        static let offset       = -1
        static let lineNumber   = -1
        static let columnNumber = -1
    }
    
}
