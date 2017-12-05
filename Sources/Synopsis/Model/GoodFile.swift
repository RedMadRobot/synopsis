//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation
import SourceKittenFramework


/**
 `SourceKittenFramework.File` abstraction assumes there could be no `path`, which is not suitable
 for `Synopsis`.
 */
struct GoodFile {
    let path: URL
    let file: File
}
