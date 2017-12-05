//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class MethodDescriptionParser: FunctionDescriptionParser<MethodDescription> {
    override func isRawFunctionDescription(_ element: [String : AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false }
        return SwiftDeclarationKind.functionMethodInstance.rawValue == kind
            || SwiftDeclarationKind.functionMethodStatic.rawValue   == kind
            || SwiftDeclarationKind.functionMethodClass.rawValue    == kind
    }
}
