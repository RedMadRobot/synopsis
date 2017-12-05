//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class MethodDescriptionParserTests: SynopsisTestCase {
    
    override func setUp() {
        super.setUp()
        storeContents(topLevelMethods, asFile: "TopLevelMethods.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "TopLevelMethods.swift")
    }
    
    func testParse_topLevelMethods_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "TopLevelMethods.swift")
        let parser = FunctionDescriptionParser()
        
        let result: ParsingResult<FunctionDescription> = parser.parse(files: [inputFile])
        
        XCTAssertEqual(result.models.count, 1)
        let topLevelFunction: FunctionDescription = result.models.first!
        
        XCTAssertEqual(
            topLevelFunction,
            FunctionDescription(
                comment: nil,
                annotations: [],
                accessibility: Accessibility.`internal`,
                name: "topLevelFunction()",
                arguments: [],
                returnType: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "func topLevelFunction()",
                    offset: 0,
                    lineNumber: 1,
                    columnNumber: 1
                ),
                kind: .free,
                body: "\n"
            )
        )
    }
    
    static var allTests = [
        ("testParse_topLevelMethods_returnsAsExpected", testParse_topLevelMethods_returnsAsExpected),
    ]
    
}


let topLevelMethods = """
func topLevelFunction() {
}
"""
