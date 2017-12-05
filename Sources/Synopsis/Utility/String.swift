//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


extension String {
    
    func detectInlineComment(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("//")
    }
    
    func detectInlineComment(endingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\n")
    }
    
    func detectBlockComment(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("/*")
    }
    
    func detectBlockComment(endingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("*/")
    }
    
    func detectTextLiteral(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\"\"\"\n")
    }
    
    func detectTextLiteral(endingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\"\"\"")
    }
    
    func detectStringLiteral(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\"")
    }
    
    func detectStringLiteral(endingAt index: String.Index) -> Bool {
        return detectStringLiteral(startingAt: index)
    }
    
    func truncateUntilExist(word: String) -> Substring {
        if let range = range(of: word) {
            return self[range.lowerBound...].dropFirst().truncateUntilExist(word: word)
        }
        
        return Substring(self)
    }
    
    func truncateLeadingWhitespace() -> Substring {
        if hasPrefix(" ") {
            return dropFirst().truncateLeadingWhitespace()
        }
        
        if hasPrefix("\n") {
            return dropFirst().truncateLeadingWhitespace()
        }
        
        return Substring(self)
    }
    
    func truncateUntil(word: String, deleteWord: Bool) -> Substring {
        guard let wordRange = range(of: word)
        else {
            return Substring(self)
        }
        
        return deleteWord ? self[wordRange.upperBound...] : self[wordRange.lowerBound...]
    }
    
    func truncateAfter(word: String, deleteWord: Bool) -> Substring {
        guard let wordRange: Range<String.Index> = range(of: word)
        else {
            return Substring(self)
        }
        
        return deleteWord ? self[..<wordRange.lowerBound] : self[..<wordRange.upperBound]
    }
    
    func firstWord(sentenceDividers: [String] = ["\n", " ", ".", ",", ";", ":"]) -> Substring {
        for divider in sentenceDividers {
            if contains(divider) {
                return truncateAfter(word: divider, deleteWord: true).firstWord(sentenceDividers: sentenceDividers)
            }
        }
        
        return Substring(self)
    }
    
    func truncateInlineCommentOpening() -> String {
        if self.hasPrefix("//") {
            return String(self.dropFirst().dropFirst()).truncateInlineCommentOpening()
        }
        
        return self
    }
    
    var indent: String {
        return self
            .components(separatedBy: "\n")
            .map { $0.isEmpty ? $0 : "    " + $0 }
            .joined(separator: "\n")
    }
    
    func prefixEachLine(with prefix: String) -> String {
        return self
            .components(separatedBy: "\n")
            .map { prefix + $0 }
            .joined(separator: "\n")
    }
}


extension Substring {
    
    func detectInlineComment(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("//")
    }
    
    func detectInlineComment(endingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\n")
    }
    
    func detectBlockComment(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("/*")
    }
    
    func detectBlockComment(endingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("*/")
    }
    
    func detectTextLiteral(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\"\"\"\n")
    }
    
    func detectTextLiteral(endingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\"\"\"")
    }
    
    func detectStringLiteral(startingAt index: String.Index) -> Bool {
        return self[index...].hasPrefix("\"")
    }
    
    func detectStringLiteral(endingAt index: String.Index) -> Bool {
        return detectStringLiteral(startingAt: index)
    }
    
    func truncateUntilExist(word: String) -> Substring {
        if let range = self.range(of: word) {
            return self[range.lowerBound...].dropFirst().truncateUntilExist(word: word)
        }
        
        return self
    }
    
    func truncateAfter(word: String, deleteWord: Bool) -> Substring {
        guard let wordRange: Range<String.Index> = range(of: word)
        else {
            return self
        }
        
        return deleteWord ? self[..<wordRange.lowerBound] : self[..<wordRange.upperBound]
    }
    
    func truncateLeadingWhitespace() -> Substring {
        if hasPrefix(" ") {
            return dropFirst().truncateLeadingWhitespace()
        }
        
        if hasPrefix("\n") {
            return dropFirst().truncateLeadingWhitespace()
        }
        
        return self
    }
    
    func firstWord(sentenceDividers: [String] = ["\n", " ", ".", ",", ";", ":"]) -> Substring {
        for divider in sentenceDividers {
            if contains(divider) {
                return truncateAfter(word: divider, deleteWord: true).firstWord(sentenceDividers: sentenceDividers)
            }
        }
        
        return self
    }
    
}
