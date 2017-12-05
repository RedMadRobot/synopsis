//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class EnumDescriptionParserTests: SynopsisTestCase {
    
    override func setUp() {
        super.setUp()
        storeContents(enumFile, asFile: "EnumFile.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "EnumFile.swift")
        super.tearDown()
    }
    
    func testParse_enumFile_returnsEnum() {
        let inputFile: URL = urlForFile(named: "EnumFile.swift")
        let parser = EnumDescriptionParser()
        let result: ParsingResult<EnumDescription> = parser.parse(files: [inputFile])
        
        XCTAssertEqual(result.models.count, 1)
        let actualEnumDescription: EnumDescription = result.models.first!
        
        XCTAssertEqual(
            actualEnumDescription,
            EnumDescription(
                comment: "EnumName docs\n\n@model Name",
                annotations: [
                    Annotation(name: "model", value: "Name", declaration: nil)
                ],
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "public enum EnumName: String, CodingKeys",
                    offset: 44,
                    lineNumber: 6,
                    columnNumber: 8
                ),
                accessibility: Accessibility.`public`,
                name: "EnumName",
                inheritedTypes: ["String", "CodingKeys"],
                cases: [
                    EnumCase(
                        comment: "First docs",
                        annotations: [],
                        name: "first",
                        defaultValue: "\"1st\"",
                        declaration: Declaration(
                            filePath: inputFile,
                            rawText: "case first = \"1st\"",
                            offset: 103,
                            lineNumber: 8,
                            columnNumber: 5
                        )
                    ),
                    EnumCase(
                        comment: "Second docs",
                        annotations: [],
                        name: "second",
                        defaultValue: "\"2nd\"",
                        declaration: Declaration(
                            filePath: inputFile,
                            rawText: "case second = \"2nd\"",
                            offset: 147,
                            lineNumber: 11,
                            columnNumber: 5
                        )
                    ),
                ],
                properties: [],
                methods: []
            )
        )
    }
    
    static var allTests = [
        ("testParse_enumFile_returnsEnum", testParse_enumFile_returnsEnum),
    ]
    
}


let enumFile = """
/**
 EnumName docs

 @model Name
 */
public enum EnumName: String, CodingKeys {
    /// First docs
    case first = "1st"

    /// Second docs
    case second = "2nd"
}
"""
