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
        storeContents(protocolWithMultilineMethods, asFile: "MultilineMethodProtocol.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "MultilineMethodProtocol.swift")
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
                returnType: TypeDescription.void,
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
    
    func testParse_protocolWithMultilineMethodDeclarations_returnsCorrectReturnTypes() {
        let inputFile: URL = urlForFile(named: "MultilineMethodProtocol.swift")
        let parser = ProtocolDescriptionParser()
        let result: ParsingResult<ProtocolDescription> = parser.parse(files: [inputFile])
        
        XCTAssertEqual(result.models.count, 1)
        let actualProtocolDescription: ProtocolDescription = result.models.first!
        
        XCTAssertEqual(
            actualProtocolDescription,
            ProtocolDescription(
                comment: nil,
                annotations: [],
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "protocol Multiline",
                    offset: 0,
                    lineNumber: 1,
                    columnNumber: 1
                ),
                accessibility: Accessibility.`internal`,
                name: "Multiline",
                inheritedTypes: [],
                properties: [],
                methods: [
                    MethodDescription(
                        comment: "Get `Person` by id",
                        annotations: [],
                        accessibility: Accessibility.`internal`,
                        name: "get(personId:)",
                        arguments: [
                            ArgumentDescription(
                                name: "personId",
                                bodyName: "id",
                                type: TypeDescription.integer,
                                defaultValue: nil,
                                annotations: [Annotation(name: "url", value: nil, declaration: nil)],
                                declaration: nil,
                                comment: " @url"
                            ),
                        ],
                        returnType: TypeDescription.generic(name: "ServiceCall", constraints: [TypeDescription.object(name: "Person")]),
                        declaration: Declaration(
                            filePath: inputFile,
                            rawText: "func get(\n        personId id: Int // @url\n    ) -> ServiceCall<Person>",
                            offset: 52,
                            lineNumber: 3,
                            columnNumber: 5
                        ),
                        kind: FunctionDescription.Kind.instance,
                        body: nil
                    ),
                    MethodDescription(
                        comment: "Search for `Person`",
                        annotations: [],
                        accessibility: Accessibility.`internal`,
                        name: "search(firstName:lastName:)",
                        arguments: [
                            ArgumentDescription(
                                name: "firstName",
                                bodyName: "firstName",
                                type: TypeDescription.string,
                                defaultValue: nil,
                                annotations: [Annotation(name: "query", value: "first_name", declaration: nil)],
                                declaration: nil,
                                comment: " @query first_name"
                            ),
                            ArgumentDescription(
                                name: "lastName",
                                bodyName: "lastName",
                                type: TypeDescription.string,
                                defaultValue: nil,
                                annotations: [Annotation(name: "query", value: "last_name", declaration: nil)],
                                declaration: nil,
                                comment: " @query last_name"
                            ),
                        ],
                        returnType: TypeDescription.array(element: TypeDescription.object(name: "Person")),
                        declaration: Declaration(
                            filePath: inputFile,
                            rawText: "func search(\n        firstName: String, // @query first_name\n        lastName: String   // @query last_name\n    ) -> [Person]",
                            offset: 157,
                            lineNumber: 8,
                            columnNumber: 5
                        ),
                        kind: FunctionDescription.Kind.instance,
                        body: nil
                    ),
                ]
            )
        )
    }
    
    static var allTests = [
        ("testParse_basicFile_returnsAsExpected", testParse_basicFile_returnsAsExpected),
        ("testParse_protocolWithMultilineMethodDeclarations_returnsCorrectReturnTypes", testParse_protocolWithMultilineMethodDeclarations_returnsCorrectReturnTypes),
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


let protocolWithMultilineMethods = """
protocol Multiline {
    /// Get `Person` by id
    func get(
        personId id: Int // @url
    ) -> ServiceCall<Person>

    /// Search for `Person`
    func search(
        firstName: String, // @query first_name
        lastName: String   // @query last_name
    ) -> [Person]
}
"""
