//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


class ProtocolDescriptionParser: ExtensibleParser<ProtocolDescription> {
    
    override func isRawExtensibleDescription(_ element: [String : AnyObject]) -> Bool {
        guard let kind: String = element.kind
        else { return false}
        return SwiftDeclarationKind.`protocol`.rawValue == kind
    }
    
}
