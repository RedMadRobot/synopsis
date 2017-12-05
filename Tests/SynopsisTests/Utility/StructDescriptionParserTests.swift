//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class StructDescriptionParserTests: SynopsisTestCase {
    
    override func setUp() {
        super.setUp()
        storeContents(basicStruct, asFile: "BasicStruct.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "BasicStruct.swift")
        super.tearDown()
    }
    
    func testParse_basicFile_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "BasicStruct.swift")
        let parser = StructDescriptionParser()
        let result: ParsingResult<StructDescription> = parser.parse(files: [inputFile])
        
        let expectedAnnotations: [Annotation] = []
        
        let expectedDeclaration: Declaration = Declaration(
            filePath: inputFile,
            rawText: "public struct Person: Codable",
            offset: 174,
            lineNumber: 21,
            columnNumber: 8
        )
        
        let expectedProperties: [PropertyDescription] = [
            PropertyDescription(
                comment: nil,
                annotations: [],
                accessibility: Accessibility.`public`,
                constant: true,
                name: "name",
                type: TypeDescription.string,
                defaultValue: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "public let name:    String",
                    offset: 210,
                    lineNumber: 22,
                    columnNumber: 12
                ),
                kind: .instance,
                body: nil
            ),
            PropertyDescription(
                comment: nil,
                annotations: [],
                accessibility: Accessibility.`public`,
                constant: true,
                name: "surname",
                type: TypeDescription.string,
                defaultValue: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "public let surname: String",
                    offset: 241,
                    lineNumber: 23,
                    columnNumber: 12
                ),
                kind: .instance,
                body: nil
            ),
        ]
        
        let expectedMethods: [MethodDescription] = [
            MethodDescription(
                comment: nil,
                annotations: [],
                accessibility: Accessibility.`public`,
                name: "init(name:surname:)",
                arguments: [
                    ArgumentDescription(
                        name: "name",
                        bodyName: "name",
                        type: TypeDescription.string,
                        defaultValue: "\"John\"",
                        annotations: [],
                        declaration: nil,
                        comment: nil
                    ),
                    ArgumentDescription(
                        name: "surname",
                        bodyName: "surname",
                        type: TypeDescription.string,
                        defaultValue: "\"Appleseed\"",
                        annotations: [],
                        declaration: nil,
                        comment: nil
                    ),
                ],
                returnType: TypeDescription.object(name: "Person"),
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "public init(name: String = \"John\", surname: String = \"Appleseed\")",
                    offset: 273,
                    lineNumber: 25,
                    columnNumber: 12
                ),
                kind: .instance,
                body: "\n        self.name = name\n        self.surname = surname\n    "
            ),
        ]
        
        XCTAssertEqual(result.models.count, 1)
        let basicStructDescription: StructDescription = result.models.first!
        
        XCTAssertEqual(basicStructDescription.comment, "Struct docs")
        XCTAssertEqual(basicStructDescription.annotations, expectedAnnotations)
        XCTAssertEqual(basicStructDescription.declaration, expectedDeclaration)
        XCTAssertEqual(basicStructDescription.accessibility, Accessibility.`public`)
        XCTAssertEqual(basicStructDescription.name, "Person")
        XCTAssertEqual(basicStructDescription.inheritedTypes.first, "Codable")
        XCTAssertEqual(basicStructDescription.properties, expectedProperties)
        XCTAssertEqual(basicStructDescription.methods, expectedMethods)
    }
    
    static var allTests = [
        ("testParse_basicFile_returnsAsExpected", testParse_basicFile_returnsAsExpected),
    ]
}


let basicStruct = """
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
 Struct docs
 */
public struct Person: Codable {
    public let name:    String
    public let surname: String

    public init(name: String = "John", surname: String = "Appleseed") {
        self.name = name
        self.surname = surname
    }
}
"""
