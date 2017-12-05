//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class ClassDescriptionParserTests: SynopsisTestCase {
    
    override func setUp() {
        super.setUp()
        storeContents(basic, asFile: "Basic.swift")
        storeContents(propertyWithGetter, asFile: "PropertyWithGetter.swift")
        storeContents(classProperty, asFile: "ClassProperty.swift")
    }
    
    override func tearDown() {
        deleteFile(named: "ClassProperty.swift")
        deleteFile(named: "PropertyWithGetter.swift")
        deleteFile(named: "Basic.swift")
        super.tearDown()
    }
    
    func testParse_basicFile_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "Basic.swift")
        let parser: ClassDescriptionParser = ClassDescriptionParser()
        let result: ParsingResult<ClassDescription> = parser.parse(files: [inputFile])
        
        let expectedAnnotations: [Annotation] = [
            Annotation(name: "model", value: nil, declaration: nil),
            Annotation(name: "realm", value: "DBBasic", declaration: nil),
        ]
        
        let expectedDeclaration: Declaration = Declaration(
            filePath: inputFile,
            rawText: "class Basic: Codable",
            offset: 154,
            lineNumber: 18,
            columnNumber: 1
        )
        
        let expectedProperties: [PropertyDescription] = [
            PropertyDescription(
                comment: "inferredString docs",
                annotations: [],
                accessibility: Accessibility.`internal`,
                constant: true,
                name: "inferredString",
                type: TypeDescription.string,
                defaultValue: "\"inferredStringValue\"",
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "let inferredString = \"inferredStringValue\"",
                    offset: 223,
                    lineNumber: 23,
                    columnNumber: 5
                ),
                kind: .instance,
                body: nil
            ),
            PropertyDescription(
                comment: "basicInt docs",
                annotations: [],
                accessibility: Accessibility.`internal`,
                constant: false,
                name: "basicInt",
                type: TypeDescription.integer,
                defaultValue: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "var basicInt: Int",
                    offset: 306,
                    lineNumber: 28,
                    columnNumber: 5
                ),
                kind: .instance,
                body: nil
            ),
            PropertyDescription(
                comment: "complexType docs",
                annotations: [],
                accessibility: Accessibility.`private`,
                constant: true,
                name: "complexType",
                type: TypeDescription.array(element: TypeDescription.object(name: "Basic")),
                defaultValue: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "private let complexType: [Basic]",
                    offset: 375,
                    lineNumber: 33,
                    columnNumber: 13
                ),
                kind: .instance,
                body: nil
            ),
        ]
        
        let expectedMethods: [MethodDescription] = [
            MethodDescription(
                comment: "init docs",
                annotations: [],
                accessibility: Accessibility.`internal`,
                name: "init(basicInt:)",
                arguments: [
                    ArgumentDescription(
                        name: "basicInt",
                        bodyName: "basicInt",
                        type: TypeDescription.integer,
                        defaultValue: nil,
                        annotations: [],
                        declaration: nil,
                        comment: nil
                    )
                ],
                returnType: TypeDescription.object(name: "Basic"),
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "init(basicInt: Int)",
                    offset: 436,
                    lineNumber: 38,
                    columnNumber: 5
                ),
                kind: .instance,
                body: "\n        self.basicInt = basicInt\n        self.complexType = Date()\n    "
            ),
            MethodDescription(
                comment: "internalMethod docs",
                annotations: [],
                accessibility: Accessibility.`internal`,
                name: "internalMethod(parameter:asInteger:)",
                arguments: [
                    ArgumentDescription(
                        name: "parameter",
                        bodyName: "parameter",
                        type: TypeDescription.string,
                        defaultValue: nil,
                        annotations: [
                            Annotation(
                                name: "string",
                                value: nil,
                                declaration: nil
                            )
                        ],
                        declaration: nil,
                        comment: " @string"
                    ),
                    ArgumentDescription(
                        name: "asInteger",
                        bodyName: "integer",
                        type: TypeDescription.integer,
                        defaultValue: "0",
                        annotations: [],
                        declaration: nil,
                        comment: nil
                    ),
                ],
                returnType: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "func internalMethod(\n    parameter: String, // @string\n    asInteger integer: Int = 0\n)",
                    offset: 564,
                    lineNumber: 44,
                    columnNumber: 5
                ),
                kind: .instance,
                body: "\n        print(basicInt)\n    "
            ),
            MethodDescription(
                comment: nil,
                annotations: [],
                accessibility: Accessibility.`private`,
                name: "privateMethod()",
                arguments: [],
                returnType: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "private func privateMethod()",
                    offset: 748,
                    lineNumber: 54,
                    columnNumber: 13
                ),
                kind: .instance,
                body: "\n        print(inferredString)\n    "
            ),
        ]
        
        XCTAssertEqual(result.models.count, 1)
        let basicClassDescription: ClassDescription = result.models.first!
        
        XCTAssertEqual(basicClassDescription.comment, "Basic docs\n\n@model\n@realm DBBasic")
        XCTAssertEqual(basicClassDescription.annotations, expectedAnnotations)
        XCTAssertEqual(basicClassDescription.declaration, expectedDeclaration)
        XCTAssertEqual(basicClassDescription.accessibility, Accessibility.`internal`)
        XCTAssertEqual(basicClassDescription.name, "Basic")
        XCTAssertEqual(basicClassDescription.inheritedTypes.first, "Codable")
        XCTAssertEqual(basicClassDescription.properties, expectedProperties)
        XCTAssertEqual(basicClassDescription.methods, expectedMethods)
    }
    
    func testParse_propertyGetter_returnsPropertyDescriptionWithBody() {
        let inputFile: URL = urlForFile(named: "PropertyWithGetter.swift")
        let parser: ClassDescriptionParser = ClassDescriptionParser()
        let result: ParsingResult<ClassDescription> = parser.parse(files: [inputFile])
        
        let expectedAnnotations: [Annotation] = []
        
        let expectedDeclaration: Declaration = Declaration(
            filePath: inputFile,
            rawText: "class Basic",
            offset: 40,
            lineNumber: 7,
            columnNumber: 1
        )
        
        let expectedProperties: [PropertyDescription] = [
            PropertyDescription(
                comment: "inferredString docs",
                annotations: [],
                accessibility: Accessibility.`internal`,
                constant: false,
                name: "inferredString",
                type: TypeDescription.string,
                defaultValue: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "var inferredString: String",
                    offset: 100,
                    lineNumber: 12,
                    columnNumber: 5
                ),
                kind: .instance,
                body: "\n        return \"inferredStringValue\"\n    "
            ),
        ]
        
        let expectedMethods: [MethodDescription] = []
        
        XCTAssertEqual(result.models.count, 1)
        let basicClassDescription: ClassDescription = result.models.first!
        
        XCTAssertEqual(basicClassDescription.comment, "Basic docs")
        XCTAssertEqual(basicClassDescription.annotations, expectedAnnotations)
        XCTAssertEqual(basicClassDescription.declaration, expectedDeclaration)
        XCTAssertEqual(basicClassDescription.accessibility, Accessibility.`internal`)
        XCTAssertEqual(basicClassDescription.name, "Basic")
        XCTAssertEqual(basicClassDescription.properties, expectedProperties)
        XCTAssertEqual(basicClassDescription.methods, expectedMethods)
    }
    
    func testParse_classProperty_returnsAsExpected() {
        let inputFile: URL = urlForFile(named: "ClassProperty.swift")
        let parser: ClassDescriptionParser = ClassDescriptionParser()
        let result: ParsingResult<ClassDescription> = parser.parse(files: [inputFile])
        
        let expectedAnnotations: [Annotation] = []
        
        let expectedDeclaration: Declaration = Declaration(
            filePath: inputFile,
            rawText: "class Basic",
            offset: 40,
            lineNumber: 7,
            columnNumber: 1
        )
        
        let expectedProperties: [PropertyDescription] = [
            PropertyDescription(
                comment: "asd docs",
                annotations: [],
                accessibility: Accessibility.`internal`,
                constant: false,
                name: "asd",
                type: TypeDescription.string,
                defaultValue: nil,
                declaration: Declaration(
                    filePath: inputFile,
                    rawText: "class var asd: String",
                    offset: 89,
                    lineNumber: 12,
                    columnNumber: 5
                ),
                kind: .`class`,
                body: "\n        return \"asd\"\n    "
            ),
            ]
        
        let expectedMethods: [MethodDescription] = []
        
        XCTAssertEqual(result.models.count, 1)
        let basicClassDescription: ClassDescription = result.models.first!
        
        XCTAssertEqual(basicClassDescription.comment, "Basic docs")
        XCTAssertEqual(basicClassDescription.annotations, expectedAnnotations)
        XCTAssertEqual(basicClassDescription.declaration, expectedDeclaration)
        XCTAssertEqual(basicClassDescription.accessibility, Accessibility.`internal`)
        XCTAssertEqual(basicClassDescription.name, "Basic")
        XCTAssertEqual(basicClassDescription.properties, expectedProperties)
        XCTAssertEqual(basicClassDescription.methods, expectedMethods)
    }
    
    static var allTests = [
        ("testParse_basicFile_returnsAsExpected", testParse_basicFile_returnsAsExpected),
        ("testParse_propertyGetter_returnsPropertyDescriptionWithBody", testParse_propertyGetter_returnsPropertyDescriptionWithBody),
    ]
}


let basic = """
//
//  Basic.swift
//  SynopsisTests
//
//  Created by John Appleseed on 10.11.29H.
//


import Foundation


/**
 Basic docs

 @model
 @realm DBBasic
 */
class Basic: Codable {

    /**
     inferredString docs
     */
    let inferredString = "inferredStringValue"

    /**
     basicInt docs
     */
    var basicInt: Int

    /**
     complexType docs
     */
    private let complexType: [Basic]

    /**
     init docs
     */
    init(basicInt: Int) {
        self.basicInt = basicInt
        self.complexType = Date()
    }

    /// internalMethod docs
    func internalMethod(
        parameter: String, // @string
        asInteger integer: Int = 0
    ) {
        print(basicInt)
    }

    /*
     privateMethod docs
     */
    private func privateMethod() {
        print(inferredString)
    }

}
"""


let propertyWithGetter = """
import Foundation


/**
 Basic docs
 */
class Basic {

    /**
     inferredString docs
     */
    var inferredString: String {
        return "inferredStringValue"
    }

}
"""


let classProperty = """
import Foundation


/**
 Basic docs
 */
class Basic {

    /**
     asd docs
     */
    class var asd: String {
        return "asd"
    }

}
"""
