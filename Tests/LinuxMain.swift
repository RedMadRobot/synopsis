import XCTest
@testable import SynopsisTests

XCTMain([
    testCase(ClassDescriptionParserTests.allTests),
    testCase(EnumDescriptionParserTests.allTests),
    testCase(MethodDescriptionParserTests.allTests),
    testCase(ProtocolDescriptionParserTests.allTests),
    testCase(StructDescriptionParserTests.allTests),
    testCase(ArgumentDescriptionVersingTests.allTests),
    testCase(ClassDescriptionVersingTests.allTests),
    testCase(EnumDescriptionVersingTests.allTests),
    testCase(MethodDescriptionVersingTests.allTests),
    testCase(PropertyDescriptionVersingTests.allTests),
])
