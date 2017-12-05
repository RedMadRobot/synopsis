//
// Project «Synopsis»
// Created by Jeorge Taflanidi
//


import Foundation


/**
 Structure information about given source code.
 */
public struct Synopsis {
    
    /**
     Found classes.
     */
    public let classes: [ClassDescription]
    
    /**
     Found structures.
     */
    public let structures: [StructDescription]
    
    /**
     Found protocols.
     */
    public let protocols: [ProtocolDescription]
    
    /**
     Found enums.
     */
    public let enums: [EnumDescription]
    
    /**
     Found free functions.
     */
    public let functions: [FunctionDescription]
    
    /**
     Errors.
     */
    public let parsingErrors: [SynopsisError]
    
    /**
     Analyze source code files and extract a `Synopsis` instance.
     */
    public init(files: [URL]) {
        var errors: [SynopsisError] = []
        
        let classParsingResult:    ParsingResult<ClassDescription>    = ClassDescriptionParser().parse(files: files)
        let structParsingResult:   ParsingResult<StructDescription>   = StructDescriptionParser().parse(files: files)
        let protocolParsingResult: ParsingResult<ProtocolDescription> = ProtocolDescriptionParser().parse(files: files)
        let enumParsingResult:     ParsingResult<EnumDescription>     = EnumDescriptionParser().parse(files: files)
        let functionParsingResult: ParsingResult<FunctionDescription> = FunctionDescriptionParser().parse(files: files)
        
        errors += classParsingResult.errors
        errors += structParsingResult.errors
        errors += protocolParsingResult.errors
        errors += enumParsingResult.errors
        errors += functionParsingResult.errors
        
        classes     = classParsingResult.models
        structures  = structParsingResult.models
        protocols   = protocolParsingResult.models
        enums       = enumParsingResult.models
        functions   = functionParsingResult.models
        
        parsingErrors = errors
    }
    
    /**
     Print out parsed Synopsis through Xcode warnings.
     */
    public func printToXcode() {
        var messages: [XcodeMessage] = []
        
        classes.forEach { (classDescription: ClassDescription) in
            messages.append(
                XcodeMessage(
                    declaration: classDescription.declaration,
                    message: classDescription.debugDescription,
                    type: XcodeMessage.MessageType.warning
                )
            )
            
            classDescription.annotations.forEach { (annotation: Annotation) in
                messages.append(
                    XcodeMessage(
                        declaration: classDescription.declaration, // TODO: replace with Annotation.declaration
                        message: annotation.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
            }
            
            classDescription.properties.forEach { (propertyDescription: PropertyDescription) in
                messages.append(
                    XcodeMessage(
                        declaration: propertyDescription.declaration,
                        message: propertyDescription.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
            }
            
            classDescription.methods.forEach { (methodDescription: MethodDescription) in
                messages.append(
                    XcodeMessage(
                        declaration: methodDescription.declaration,
                        message: methodDescription.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
                
                methodDescription.arguments.forEach { (argumentDescription: ArgumentDescription) in
                    messages.append(
                        XcodeMessage(
                            declaration: methodDescription.declaration, // TODO: replace with ArgumentDescription.declaration
                            message: argumentDescription.debugDescription,
                            type: XcodeMessage.MessageType.warning
                        )
                    )
                }
            }
        } // classes.forEach
        
        structures.forEach { (structDescription: StructDescription) in
            messages.append(
                XcodeMessage(
                    declaration: structDescription.declaration,
                    message: structDescription.debugDescription,
                    type: XcodeMessage.MessageType.warning
                )
            )
            
            structDescription.annotations.forEach { (annotation: Annotation) in
                messages.append(
                    XcodeMessage(
                        declaration: structDescription.declaration, // TODO: replace with Annotation.declaration
                        message: annotation.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
            }
            
            structDescription.properties.forEach { (propertyDescription: PropertyDescription) in
                messages.append(
                    XcodeMessage(
                        declaration: propertyDescription.declaration,
                        message: propertyDescription.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
            }
            
            structDescription.methods.forEach { (methodDescription: MethodDescription) in
                messages.append(
                    XcodeMessage(
                        declaration: methodDescription.declaration,
                        message: methodDescription.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
                
                methodDescription.arguments.forEach { (argumentDescription: ArgumentDescription) in
                    messages.append(
                        XcodeMessage(
                            declaration: methodDescription.declaration, // TODO: replace with ArgumentDescription.declaration
                            message: argumentDescription.debugDescription,
                            type: XcodeMessage.MessageType.warning
                        )
                    )
                }
            }
        } // structures.forEach
        
        protocols.forEach { (protocolDescription: ProtocolDescription) in
            messages.append(
                XcodeMessage(
                    declaration: protocolDescription.declaration,
                    message: protocolDescription.debugDescription,
                    type: XcodeMessage.MessageType.warning
                )
            )
            
            protocolDescription.annotations.forEach { (annotation: Annotation) in
                messages.append(
                    XcodeMessage(
                        declaration: protocolDescription.declaration, // TODO: replace with Annotation.declaration
                        message: annotation.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
            }
            
            protocolDescription.properties.forEach { (propertyDescription: PropertyDescription) in
                messages.append(
                    XcodeMessage(
                        declaration: propertyDescription.declaration,
                        message: propertyDescription.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
            }
            
            protocolDescription.methods.forEach { (methodDescription: MethodDescription) in
                messages.append(
                    XcodeMessage(
                        declaration: methodDescription.declaration,
                        message: methodDescription.debugDescription,
                        type: XcodeMessage.MessageType.warning
                    )
                )
                
                methodDescription.arguments.forEach { (argumentDescription: ArgumentDescription) in
                    messages.append(
                        XcodeMessage(
                            declaration: methodDescription.declaration, // TODO: replace with ArgumentDescription.declaration
                            message: argumentDescription.debugDescription,
                            type: XcodeMessage.MessageType.warning
                        )
                    )
                }
            }
        } // protocols.forEach
        
        messages.forEach { print($0) }
    }
    
}
