//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import XCTest
@testable import Synopsis


class SynopsisTestCase: XCTestCase {
    
    func storeContents(_ contents: String, asFile filename: String) {
        let appSupportFolderURL: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let fileURL: URL = URL(string: filename, relativeTo: appSupportFolderURL)!
        
        try! contents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func deleteFile(named name: String) {
        let appSupportFolderURL: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let fileURL: URL = URL(string: name, relativeTo: appSupportFolderURL)!
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    func urlForFile(named name: String) -> URL {
        let appSupportFolderURL: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        return URL(string: name, relativeTo: appSupportFolderURL)!
    }
    
}
