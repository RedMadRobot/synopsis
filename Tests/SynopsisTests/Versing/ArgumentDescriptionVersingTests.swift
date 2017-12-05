//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class ArgumentDescriptionVersingTests: XCTestCase {
    
    func testVerse_intArgumentNoBodyName_returnsAsExpected() {
        let argumentDescription = ArgumentDescription.template(
            name: "count",
            bodyName: "count",
            type: TypeDescription.integer,
            defaultValue: nil,
            comment: nil
        )
        
        let expectedVerse = """
        count: Int
        """
        
        XCTAssertEqual(argumentDescription.verse, expectedVerse)
    }
    
    func testVerse_hasDefaultValueAndComment_returnsWithExplicitType() {
        let argumentDescription = ArgumentDescription.template(
            name: "withDictionary",
            bodyName: "dictionary",
            type: TypeDescription.map(key: TypeDescription.string, value: TypeDescription.object(name: "AnyObject")),
            defaultValue: "[:]",
            comment: "raw arguments"
        )
        
        let expectedVerse = """
        withDictionary dictionary: [String: AnyObject] = [:] // raw arguments
        """
        
        XCTAssertEqual(argumentDescription.verse, expectedVerse)
    }
    
    static var allTests = [
        ("testVerse_intArgumentNoBodyName_returnsAsExpected", testVerse_intArgumentNoBodyName_returnsAsExpected),
        ("testVerse_hasDefaultValueAndComment_returnsWithExplicitType", testVerse_hasDefaultValueAndComment_returnsWithExplicitType),
    ]
    
}

