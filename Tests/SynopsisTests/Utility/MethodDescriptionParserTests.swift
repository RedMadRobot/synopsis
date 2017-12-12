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
        storeContents(genericReturnType, asFile: "GenericReturnType.swift")
        storeContents(multilineMethod, asFile: "Multiline.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "Multiline.swift")
        deleteFile(named: "GenericReturnType.swift")
        deleteFile(named: "TopLevelMethods.swift")
        super.tearDown()
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
                returnType: TypeDescription.void,
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
    
    func testParse_complexReturnType_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "GenericReturnType.swift")
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
                name: "genericReturnType()",
                arguments: [],
                returnType: TypeDescription.generic(name: "ServiceCall", constraints: [TypeDescription.void]),
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "func genericReturnType() /* bla bla */ -> ServiceCall<Void>",
                    offset: 0,
                    lineNumber: 1,
                    columnNumber: 1
                ),
                kind: .free,
                body: "\n"
            )
        )
    }
    
    func testParse_multilineMethod_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "Multiline.swift")
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
                name: "some(other:)",
                arguments: [
                    ArgumentDescription(
                        name: "other",
                        bodyName: "other",
                        type: TypeDescription.string,
                        defaultValue: nil,
                        annotations: [],
                        declaration: nil,
                        comment: nil
                    )
                ],
                returnType: TypeDescription.object(name: "Something"),
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "func some(\n    other: String\n) -> Something"    ,
                    offset: 0,
                    lineNumber: 1,
                    columnNumber: 1
                ),
                kind: .free,
                body: "\n    print(other)\n    return 1\n"
            )
        )
    }
    
    static var allTests = [
        ("testParse_topLevelMethods_returnsAsExpected", testParse_topLevelMethods_returnsAsExpected),
        ("testParse_complexReturnType_returnsAsExpected", testParse_complexReturnType_returnsAsExpected),
        ("testParse_multilineMethod_returnsAsExpected", testParse_multilineMethod_returnsAsExpected),
    ]
    
}


let topLevelMethods = """
func topLevelFunction() {
}
"""


let genericReturnType = """
func genericReturnType() /* bla bla */ -> ServiceCall<Void> {
}
"""


let multilineMethod = """
func some(
    other: String
) -> Something {
    print(other)
    return 1
}
"""
