//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class MethodDescriptionVersingTests: XCTestCase {
    
    func testVerse_methodNameWithoutBrackets_throwsFunctionTemplateError() {
        do {
            let _ = try MethodDescription.template(
                comment: nil,
                accessibility: Accessibility.`internal`,
                name: "method",
                arguments: [],
                returnType: nil,
                kind: .instance,
                body: ""
            )
        } catch let error as FunctionDescription.FunctionTemplateError {
            if case FunctionDescription.FunctionTemplateError.nameLacksRoundBrackets = error {
                XCTAssert(true)
                return
            }
        } catch {
            XCTAssert(false)
        }
        
        XCTAssert(false)
    }
    
    func testVerse_simpleMethodEmptyBody_returnsSingleLine() {
        let methodDescription = try! MethodDescription.template(
            comment: nil,
            accessibility: Accessibility.`internal`,
            name: "method()",
            arguments: [],
            returnType: nil,
            kind: .instance,
            body: ""
        )
        
        let expectedVerse = """
        func method() {}
        """
        
        XCTAssertEqual(methodDescription.verse, expectedVerse)
    }
    
    func testVerse_simpleMethodWithBody_returnsMultiline() {
        let methodDescription = try! MethodDescription.template(
            comment: nil,
            accessibility: Accessibility.`internal`,
            name: "method()",
            arguments: [],
            returnType: nil,
            kind: .instance,
            body: "print(\"Test\")"
        )
        
        let expectedVerse = """
        func method() {
            print("Test")
        }
        """
        
        XCTAssertEqual(methodDescription.verse, expectedVerse)
    }
    
    func testVerse_simpleInit_returnsAsExpected() {
        let methodDescription = try! MethodDescription.template(
            comment: nil,
            accessibility: Accessibility.`internal`,
            name: "init(name:)",
            arguments: [
                ArgumentDescription.template(
                    name: "name",
                    bodyName: "name",
                    type: TypeDescription.string,
                    defaultValue: nil,
                    comment: nil
                )
            ],
            returnType: TypeDescription.object(name: "Entity"),
            kind: .instance,
            body: "self.name = name"
        )
        
        let expectedVerse = """
        init(
            name: String
        ) {
            self.name = name
        }
        """
        
        XCTAssertEqual(methodDescription.verse, expectedVerse)
    }
    
    func testVerse_methodWithComments_returnsAsExpected() {
        let methodDescription = try! MethodDescription.template(
            comment: "Change name.\nObviously",
            accessibility: Accessibility.`public`,
            name: "change(personName:)",
            arguments: [
                ArgumentDescription.template(
                    name: "personName",
                    bodyName: "name",
                    type: TypeDescription.string,
                    defaultValue: nil,
                    comment: "@json"
                )
            ],
            returnType: TypeDescription.object(name: "Person"),
            kind: .instance,
            body: "print(\"TBD\")"
        )
        
        let expectedVerse = """
        /// Change name.
        /// Obviously
        public func change(
            personName name: String // @json
        ) -> Person {
            print("TBD")
        }
        """
        
        XCTAssertEqual(methodDescription.verse, expectedVerse)
    }
    
    func testVerse_bigComplexServiceCallProtocol_returnsWithoutBody() {
        let comment = """
        Get Person by identifier.

        - parameter personId: Identifier
        - parameter fullPayload: Full long payload. 0 = short payload, else full.

        @get
        @url https://service.com/persons/{person_id}
        """
        
        let methodDescription = try! MethodDescription.template(
            comment: comment,
            accessibility: Accessibility.`public`,
            name: "get(personId:fullPayload:)",
            arguments: [
                ArgumentDescription.template(
                    name: "personId",
                    bodyName: "id",
                    type: TypeDescription.integer,
                    defaultValue: nil,
                    comment: "@url person_id"
                ),
                ArgumentDescription.template(
                    name: "fullPayload",
                    bodyName: "fullPayload",
                    type: TypeDescription.integer,
                    defaultValue: "0",
                    comment: "@query full_payload"
                )
            ],
            returnType: TypeDescription.generic(
                name: "ServiceCall",
                constraints: [
                    TypeDescription.object(name: "Person")
                ]
            ),
            kind: .instance,
            body: nil
        )
        
        let expectedVerse = """
        /// Get Person by identifier.
        ///\(" ")
        /// - parameter personId: Identifier
        /// - parameter fullPayload: Full long payload. 0 = short payload, else full.
        ///\(" ")
        /// @get
        /// @url https://service.com/persons/{person_id}
        public func get(
            personId id: Int, // @url person_id
            fullPayload: Int = 0 // @query full_payload
        ) -> ServiceCall<Person>
        """
        
        XCTAssertEqual(methodDescription.verse, expectedVerse)
    }
    
    static var allTests = [
        ("testVerse_methodNameWithoutBrackets_throwsFunctionTemplateError", testVerse_methodNameWithoutBrackets_throwsFunctionTemplateError),
        ("testVerse_simpleMethodEmptyBody_returnsSingleLine", testVerse_simpleMethodEmptyBody_returnsSingleLine),
        ("testVerse_simpleMethodWithBody_returnsMultiline", testVerse_simpleMethodWithBody_returnsMultiline),
        ("testVerse_simpleInit_returnsAsExpected", testVerse_simpleInit_returnsAsExpected),
        ("testVerse_bigComplexServiceCallProtocol_returnsWithoutBody", testVerse_bigComplexServiceCallProtocol_returnsWithoutBody),
    ]
    
}
