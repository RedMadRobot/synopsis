//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


struct ParsingResult<ParsedModel> {
    let errors: [SynopsisError]
    let models: [ParsedModel]
}
