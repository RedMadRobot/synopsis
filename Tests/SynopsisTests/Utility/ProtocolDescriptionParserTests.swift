//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class ProtocolDescriptionParserTests: SynopsisTestCase {
    
    override func setUp() {
        super.setUp()
        storeContents(basicProtocol, asFile: "BasicProtocol.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "BasicProtocol.swift")
        super.tearDown()
    }
    
    func testParse_basicFile_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "BasicProtocol.swift")
        let parser = ProtocolDescriptionParser()
        let result: ParsingResult<ProtocolDescription> = parser.parse(files: [inputFile])
        
        let expectedAnnotations: [Annotation] = []
        
        let expectedDeclaration: Declaration = Declaration(
            filePath: inputFile,
            rawText: "public protocol Doer",
            offset: 176,
            lineNumber: 21,
            columnNumber: 8
        )
        
        let expectedProperties: [PropertyDescription] = []
        
        let expectedMethods: [MethodDescription] = [
            MethodDescription(
                comment: "Do anything.",
                annotations: [],
                accessibility: Accessibility.`public`,
                name: "abc()",
                arguments: [],
                returnType: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "func abc()",
                    offset: 230,
                    lineNumber: 25,
                    columnNumber: 5
                ),
                kind: .instance,
                body: nil
            ),
        ]
        
        XCTAssertEqual(result.models.count, 1)
        let basicProtocolDescription: ProtocolDescription = result.models.first!
        
        XCTAssertEqual(basicProtocolDescription.comment, "Protocol docs")
        XCTAssertEqual(basicProtocolDescription.annotations, expectedAnnotations)
        XCTAssertEqual(basicProtocolDescription.declaration, expectedDeclaration)
        XCTAssertEqual(basicProtocolDescription.accessibility, Accessibility.`public`)
        XCTAssertEqual(basicProtocolDescription.name, "Doer")
        XCTAssertEqual(basicProtocolDescription.inheritedTypes.count, 0)
        XCTAssertEqual(basicProtocolDescription.properties, expectedProperties)
        XCTAssertEqual(basicProtocolDescription.methods, expectedMethods)
    }
    
    static var allTests = [
        ("testParse_basicFile_returnsAsExpected", testParse_basicFile_returnsAsExpected),
    ]
}


let basicProtocol = """
//
//  Basic.swift
//  SynopsisTests
//
//  Created by John Appleseed on 10.11.29H.
//


import Foundation


/**
 Basic docs
 */
class Basic {}


/**
 Protocol docs
 */
public protocol Doer {
    /**
     Do anything.
     */
    func abc()
}
"""
