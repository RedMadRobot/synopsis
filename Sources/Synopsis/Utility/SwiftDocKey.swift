//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


/**
 ATTENTION!
 
 Most of the methods below are unsafe. Use on your own risk.
 */
extension Dictionary where Key == String {
    var accessibility: String {
        return self["key.accessibility"] as! String
    }
    
    var offset: Int {
        return self[SwiftDocKey.offset] as! Int
    }
    
    var length: Int {
        return self[SwiftDocKey.length] as! Int
    }
    
    var parsedDeclaration: String {
        if let value = self[SwiftDocKey.parsedDeclaration] as? String {
            return value
        }
        
        preconditionFailure("""
        
        !!! ATTENTION !!!
        It looks like Swift compiler can't reach your source code file.
        This usually happens when provided path does not exist or when this path contains relative injections like ".":
        
        /Users/user/Projects/MyProject/./Sources
                                       ^~~~~~~~~

        Swift compiler can't navigate through "." and ".." yet. Sorry about that.
        Also, Swift compiler uses absolute paths, so we concatenate your relative paths with current working directory.

        Please make sure your "-input" folder reads like "Sources/Classes" and not like "./Sources/Classes".
        (or provide absolute path, if applicable)
        !!! ATTENTION !!!

        """)
    }
    
    var subsctructure: [[String: AnyObject]] {
        return self[SwiftDocKey.substructure] as? [[String: AnyObject]] ?? []
    }
    
    var comment: String? {
        return self[SwiftDocKey.documentationComment] as? String
    }
    
    var name: String {
        return self[SwiftDocKey.name] as! String
    }
    
    var inheritedTypes: [String] {
        let inheritedTypes: [[String: AnyObject]] = self[SwiftDocKey.inheritedtypes] as? [[String: AnyObject]] ?? []
        return inheritedTypes.map { (inheritedType: [String: AnyObject]) -> String in
            return inheritedType[SwiftDocKey.name] as! String
        }
    }
    
    var typename: String {
        return self[SwiftDocKey.typeName] as! String
    }
    
    var kind: String? {
        return self[SwiftDocKey.kind] as? String
    }
    
    var bodyOffset: Int? {
        return self[SwiftDocKey.bodyOffset] as? Int
    }
    
    var bodyLength: Int? {
        return self[SwiftDocKey.bodyLength] as? Int
    }
    
    subscript(key: SwiftDocKey) -> Value? {
        return self[key.rawValue]
    }
}

