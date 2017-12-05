//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class EnumDescriptionVersingTests: XCTestCase {
    
    func testVerse_fullyPacked_returnsAsExpected() {
        let enumDescription = EnumDescription.template(
            comment: "Docs",
            accessibility: Accessibility.`private`,
            name: "MyEnum",
            inheritedTypes: ["String"],
            cases: [
                EnumCase.template(comment: "First", name: "firstName", defaultValue: "\"first_name\""),
                EnumCase.template(comment: "Second", name: "lastName", defaultValue: "\"last_name\""),
            ],
            properties: [],
            methods: []
        )
        
        let expectedVerse = """
        /// Docs
        private enum MyEnum: String {
            /// First
            case firstName = "first_name"

            /// Second
            case lastName = "last_name"
        }

        """
        
        XCTAssertEqual(enumDescription.verse, expectedVerse)
    }
    
    static var allTests = [
        ("testVerse_fullyPacked_returnsAsExpected", testVerse_fullyPacked_returnsAsExpected)
    ]
    
}
