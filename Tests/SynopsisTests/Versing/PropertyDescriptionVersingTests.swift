//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class PropertyDescriptionVersingTests: XCTestCase {
    
    func testVerse_simpleIntProperty_returnsAsExpected() {
        let propertyDescription = PropertyDescription.template(
            comment: nil,
            accessibility: Accessibility.`internal`,
            constant: true,
            name: "count",
            type: TypeDescription.integer,
            defaultValue: nil,
            kind: .instance,
            body: nil
        )
        
        let expectedVerse = """
        let count: Int
        """
        
        XCTAssertEqual(propertyDescription.verse, expectedVerse)
    }
    
    func testVerse_publicStringPropertyWithBody_returnsAsExpected() {
        let propertyDescription = PropertyDescription(
            comment: nil,
            annotations: [],
            accessibility: Accessibility.`public`,
            constant: false,
            name: "name",
            type: TypeDescription.string,
            defaultValue: nil,
            declaration: Declaration.mock,
            kind: .instance,
            body: "return \"Travis\""
        )
        
        let expectedVerse = """
        public var name: String {
            return "Travis"
        }
        """
        
        XCTAssertEqual(propertyDescription.verse, expectedVerse)
    }
    
    func testVerse_privateStringPropertyWithDefaultValueAndComment_returnsWithExplicitType() {
        let propertyDescription = PropertyDescription.template(
            comment: "Entity name.\n\n    Wild text.",
            accessibility: Accessibility.`private`,
            constant: false,
            name: "name",
            type: TypeDescription.string,
            defaultValue: "\"Jeff\"",
            kind: .instance,
            body: nil
        )
        
        let expectedVerse = """
        /// Entity name.
        ///\(" ")
        ///     Wild text.
        private var name: String = "Jeff"
        """
        
        XCTAssertEqual(propertyDescription.verse, expectedVerse)
    }
    
    func testVerse_publicStaticLet_returnsAsExpected() {
        let propertyDescirption = PropertyDescription.template(
            comment: nil,
            accessibility: Accessibility.`public`,
            constant: true,
            name: "pi",
            type: TypeDescription.doublePrecision,
            defaultValue: "3.1415926536",
            kind: PropertyDescription.Kind.static,
            body: nil
        )
        
        let expextedVerse = """
        public static let pi: Double = 3.1415926536
        """
        
        XCTAssertEqual(propertyDescirption.verse, expextedVerse)
    }
    
    static var allTests = [
        ("testVerse_simpleIntProperty_returnsAsExpected", testVerse_simpleIntProperty_returnsAsExpected),
        ("testVerse_publicStringPropertyWithBody_returnsAsExpected", testVerse_publicStringPropertyWithBody_returnsAsExpected),
        ("testVerse_privateStringPropertyWithDefaultValueAndComment_returnsWithExplicitType", testVerse_privateStringPropertyWithDefaultValueAndComment_returnsWithExplicitType),
        ("testVerse_publicStaticLet_returnsAsExpected", testVerse_publicStaticLet_returnsAsExpected),
    ]
    
}
