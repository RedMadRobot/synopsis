//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Synopsis library makes a lot of work with files.
 
 This means I/O errors and content parsing errors.
 
 Thus, this structure was created.
 */
public struct SynopsisError {
    /**
     What happened?
     */
    public let description: String
    
    /**
     Where happened?
     */
    public let file: URL
    
    /**
     FFS make auto-public initializers @ Apple
     */
    public init(description: String, file: URL) {
        self.description = description
        self.file        = file
    }
    
    public static func errorReadingFile(file: URL) -> SynopsisError {
        return self.init(description: "Cannot read file", file: file)
    }
    
    public static func errorCompilingFile(file: URL) -> SynopsisError {
        return self.init(description: "Cannot parse file", file: file)
    }
}
