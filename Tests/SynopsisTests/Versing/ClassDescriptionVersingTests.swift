//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class ClassDescriptionVersingTests: XCTestCase {
    
    func testVerse_simpleEmpty_returnsSingleLine() {
        let classDescription = ClassDescription.template(
            comment: nil,
            accessibility: Accessibility.`internal`,
            name: "Entity",
            inheritedTypes: [],
            properties: [],
            methods: []
        )
        
        let expectedVerse = """
        class Entity {}

        """
        
        XCTAssertEqual(classDescription.verse, expectedVerse)
    }
    
    func testVerse_fullyPacked_returnsAsExpected() {
        let computedPropertyBody = """
        get {
            return 0
        }

        set {
            print(newValue)
        }
        """
        
        let properties = [
            PropertyDescription.template(
                comment: "inferredString docs",
                accessibility: Accessibility.`internal`,
                constant: true,
                name: "inferredString",
                type: TypeDescription.string,
                defaultValue: "\"inferredStringValue\"",
                kind: .instance,
                body: nil
            ),
            PropertyDescription.template(
                comment: "basicInt docs",
                accessibility: Accessibility.`internal`,
                constant: false,
                name: "basicInt",
                type: TypeDescription.integer,
                defaultValue: nil,
                kind: .instance,
                body: computedPropertyBody
            ),
            PropertyDescription.template(
                comment: "complexType docs\n@ignore",
                accessibility: Accessibility.`private`,
                constant: true,
                name: "complexType",
                type: TypeDescription.array(element: TypeDescription.object(name: "Basic")),
                defaultValue: "[]",
                kind: .instance,
                body: nil
            )
        ]
        
        let methods = [
            try! MethodDescription.template(
                comment: "init docs",
                accessibility: Accessibility.`internal`,
                name: "init(basicInt:)",
                arguments: [
                    ArgumentDescription.template(
                        name: "basicInt",
                        bodyName: "basicInt",
                        type: TypeDescription.integer,
                        defaultValue: nil,
                        comment: nil
                    )
                ],
                returnType: TypeDescription.object(name: "Basic"),
                kind: .instance,
                body: "self.basicInt = basicInt"
            ),
            try! MethodDescription.template(
                comment: "internalMethod docs",
                accessibility: Accessibility.`internal`,
                name: "internalMethod(parameter:asInteger:)",
                arguments: [
                    ArgumentDescription.template(
                        name: "parameter",
                        bodyName: "parameter",
                        type: TypeDescription.optional(wrapped: TypeDescription.string),
                        defaultValue: nil,
                        comment: "@string"
                    ),
                    ArgumentDescription.template(
                        name: "asInteger",
                        bodyName: "integer",
                        type: TypeDescription.integer,
                        defaultValue: "0",
                        comment: nil
                    )
                ],
                returnType: nil,
                kind: .instance,
                body: "print(parameter)\nprint(integer)"
            ),
            try! MethodDescription.template(
                comment: "privateMethod docs",
                accessibility: Accessibility.`private`,
                name: "privateMethod()",
                arguments: [],
                returnType: TypeDescription.object(name: "Never"),
                kind: .instance,
                body: "print(inferredString)"
            )
        ]
        
        let comment = """
        Basic docs

        @model
        @realm DBBasic
        """
        
        let classDescription = ClassDescription.template(
            comment: comment,
            accessibility: Accessibility.`open`,
            name: "Basic",
            inheritedTypes: ["Entity", "Codable"],
            properties: properties,
            methods: methods
        )
        
        let expectedVerse = """
        /// Basic docs
        ///\(" ")
        /// @model
        /// @realm DBBasic
        open class Basic: Entity, Codable {
            /// inferredString docs
            let inferredString: String = "inferredStringValue"

            /// basicInt docs
            var basicInt: Int {
                get {
                    return 0
                }

                set {
                    print(newValue)
                }
            }

            /// complexType docs
            /// @ignore
            private let complexType: [Basic] = []

            /// init docs
            init(
                basicInt: Int
            ) {
                self.basicInt = basicInt
            }

            /// internalMethod docs
            func internalMethod(
                parameter: String?, // @string
                asInteger integer: Int = 0
            ) {
                print(parameter)
                print(integer)
            }

            /// privateMethod docs
            private func privateMethod() -> Never {
                print(inferredString)
            }
        }

        """
        
        XCTAssertEqual(classDescription.verse, expectedVerse)
    }
    
    static var allTests = [
        ("testVerse_simpleEmpty_returnsSingleLine", testVerse_simpleEmpty_returnsSingleLine),
        ("testVerse_fullyPacked_returnsAsExpected", testVerse_fullyPacked_returnsAsExpected),
    ]
    
}

