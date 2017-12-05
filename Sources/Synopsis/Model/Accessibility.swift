//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Access mode for Swift statements.
 */
public enum Accessibility: CustomDebugStringConvertible {
    case `private`
    case `internal`
    case `public`
    case `open`
    
    static func deduce(forRawStructureElement element: [String: AnyObject]) -> Accessibility {
        let accessibilityString: String = element.accessibility
        switch accessibilityString {
            case "source.lang.swift.accessibility.private":  return Accessibility.`private`
            case "source.lang.swift.accessibility.public":   return Accessibility.`public`
            case "source.lang.swift.accessibility.open":     return Accessibility.`open`
            default:                                         return Accessibility.`internal`
        }
    }
    
    /**
     Write down own source code.
     */
    public var verse: String {
        switch self {
            case Accessibility.`private`:   return "private"
            case Accessibility.`public`:    return "public"
            case Accessibility.`open`:      return "open"
            default:                        return ""
        }
    }
    
    public var debugDescription: String {
        switch self {
            case Accessibility.`private`:   return "ACCESSIBILITY: private"
            case Accessibility.`public`:    return "ACCESSIBILITY: public"
            case Accessibility.`open`:      return "ACCESSIBILITY: open"
            default:                        return "ACCESSIBILITY: internal"
        }
    }
}
