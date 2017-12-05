//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class ClassDescriptionParser: ExtensibleParser<ClassDescription> {
    
    override func isRawExtensibleDescription(_ element: [String : AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false}
        return SwiftDeclarationKind.`class`.rawValue == kind
    }
    
}
