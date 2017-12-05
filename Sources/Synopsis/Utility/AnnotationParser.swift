//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Utility to parse annotations from comments of any kind.
 */
class AnnotationParser {
    
    /**
     Parse annotations from block and inline comments.
     
     ```
     @annotation
     ```
     
     ```
     @annotation; @annotation
     ```
     
     ```
     @annotation
     @annotation
     ```
     
     ```
     @annotation value
     @annotation
     ```
     
     ```
     @annotation value
     ```
     ```
     @annotation value;
     ```
     ```
     @annotation value @annotation value
     ```
     ```
     @annotation value; @annotation value
     ```
     ```
     @annotation value; @annotation value;
     ```
     */
    func parse(comment string: String) -> [Annotation] {
        var s:          String       = string
        var annotaions: [Annotation] = []
        
        while s.contains("@") {
            let annotationName: String = String(s.truncateUntil(word: "@", deleteWord: true).firstWord())
            s = String(s.truncateUntil(word: "@" + annotationName, deleteWord: true))
            
            let annotationValue: String?
            
            if s.hasPrefix("\n")
            || s.hasPrefix(" \n")
            || s.hasPrefix(";")
            || s.hasPrefix(";\n")
            || s.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                annotationValue = nil
            } else {
                annotationValue = String(s.truncateLeadingWhitespace().firstWord(sentenceDividers: ["\n", " ", ";"]))
            }
            
            annotaions.append(Annotation(name: annotationName, value: annotationValue, declaration: nil))
        }
        
        return annotaions
    }
    
}
