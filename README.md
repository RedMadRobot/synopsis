# Synopsis
## Description

The package is designed to gather information from Swift source files and compile this information into concrete objects with
strongly typed properties containing descriptions of found symbols.

In other words, if you have a source code file like
```swift
// MyClass.swift

/// My class does nothing.
open class MyClass {}
```
— **Synopsis** will give you structurized information that there's a `class`, it's `open` and named `MyClass`, with no methods nor properties,
and the class is documented as `My class does nothing`. Also, it has no parents.

## Installation
### Swift Package Manager dependency

```swift
Package.Dependency.package(
    url: "https://github.com/RedMadRobot/synopsis",
    from: "1.0.0"
)
```

## Usage

* [Synopsis struct](#synopsis-struct)
    - [Classes, structs and protocols](#classdescription)
    - [Enums](#enums)
    - [Methods and functions](#functions)
    - [Properties](#properties)
    - [Annotations](#annotation)
    - [Property types, argument types, return types](#types)
    - [Declaration](#declarations)
* [Code generation, templates and versing](#versing)
* [Running tests](#tests)

<a name="synopsis-struct" />

### Synopsis struct

`Synopsis` structure is your starting point. This structure provides you with an `init(files:)` initializer that accepts a list of file URLs
of your `*.swift` source code files.

```swift
let mySwiftFiles: [URL] = getFiles()

let synopsis = Synopsis(files: mySwiftFiles)
```

Initialized `Synopsis` structure has properties `classes`, `structures`, `protocols`, `enums` and `functions` containing descirpitons
of found classes, structs, protocols, enums and high-level free functions respectively. You may also examine `parsingErrors` property
with a list of problems occured during the compilation process.

```swift
struct Synopsis {
    let classes:        [ClassDescription]
    let structures:     [StructDescription]
    let protocols:      [ProtocolDescription]
    let enums:          [EnumDescription]
    let functions:      [FunctionDescription]
    let parsingErrors:  [SynopsisError]
}
```

<a name="classdescription" />

### Classes, structs and protocols

Meta-information about found classes, structs and protocols is organized as `ClassDescription`, `StructDescription`
or `ProtocolDescription` structs respectively. Each of these implements an `Extensible` protocol.

```swift
struct ClassDescription:    Extensible {}
struct StructDescription:   Extensible {}
struct ProtocolDescription: Extensible {}
```

<a name="extensible" />

#### Extensible

```swift
protocol Extensible: Equatable, CustomDebugStringConvertible {
    var comment:        String?
    var annotations:    [Annotation]
    var declaration:    Declaration
    var accessibility:  Accessibility
    var name:           String
    var inheritedTypes: [String]
    var properties:     [PropertyDescription]
    var methods:        [MethodDescription]

    var verse: String // this one is special
}
```

Extensibles (read like «classes», «structs» or «protocols») include

* `comment` — an optional documentation above the extensible.
* `annotations` — a list of `Annotation` instances parsed from the `comment`; see [Annotation](#annotation) for more details.
* `declaration` — an information, where this current extensible could be found (file, line number, column number etc.); see [Declaration](#declarations) for more details.
* `accessibility` — an `enum` of `private`, `internal`, `public` and `open`.
* `name` — an extensible name.
* `inheritedTypes` — a list of all parents, if any.
* `properties` — a list of all properties; see [Property](#properties) for more details.
* `methods` — a list of methods, including initializers; see [Methods and functions](#functions) for more details.

There's also a special computed property `verse: String`, which allows to obtain the `Extensible` as a source code.
This is a convenient way of composing new utility classes, see [Code generation, templates and versing](#versing) for more information.

All extensibles support `Equatable` and `CustomDebugStringConvertible` protocols, and extend `Sequence` with
`subscript(name:)` and `contains(name:)` methods.

```swift
extension Sequence where Iterator.Element: Extensible {
    subscript(name: String) -> Iterator.Element?
    func contains(name: String) -> Bool
}
```

<a name="enums" />

### Enums

```swift
struct EnumDescription: Equatable, CustomDebugStringConvertible {
    let comment:        String?
    let annotations:    [Annotation]
    let declaration:    Declaration
    let accessibility:  Accessibility
    let name:           String
    let inheritedTypes: [String]
    let cases:          [EnumCase] // !!! enum cases !!!
    let properties:     [PropertyDescription]
    let methods:        [MethodDescription]

    var verse: String
}
```

Enum descriptions contain almost the same information as the extensibles, but also include a list of cases.

<a name="cases" />

#### Enum cases

```swift
struct EnumCase: Equatable, CustomDebugStringConvertible {
    let comment:        String?
    let annotations:    [Annotation]
    let name:           String
    let defaultValue:   String? // everything after "=", e.g. case firstName = "first_name"
    let declaration:    Declaration
    
    var verse:          String
}
```

All enum cases have `String` names, and declarations. They may also have documentation (with [annotations](#annotation)) and optional `defaultValue: String?`.

You should know, that `defaultValue` is a raw text, which may contain symbols like quotes.

```swift
enum CodingKeys {
    case firstName = "first_name" // defaultValue == "\"first_name\""
}
```

<a name="functions" />

### Methods and functions

```swift
class FunctionDescription: Equatable, CustomDebugStringConvertible {
    let comment:        String?
    let annotations:    [Annotation]
    let accessibility:  Accessibility
    let name:           String
    let arguments:      [ArgumentDescription]
    let returnType:     TypeDescription?
    let declaration:    Declaration
    let kind:           Kind // see below
    let body:           String?
    
    var verse: String
    
    enum Kind {
        case free
        case class
        case static
        case instance
    }
}
```

**Synopsis** assumes that method is a function subclass with a couple additional features.

All functions have

* optional documentation;
* [annotations](#annotation);
* accessibility (`private`, `internal`, `public` or `open`);
* name;
* list of arguments (of type `ArgumentDescription`, [see below](#arguments));
* optional return type (of type `TypeDescription`, [see below](#types));
* a declaration (of type `Declaration`, [see below](#declarations));
* kind;
* optional body.

Methods also have a computed property `isInitializer: Bool`.

```swift
class MethodDescription: FunctionDescription {
    var isInitializer: Bool {
        return name.hasPrefix("init(")
    }
}
// literally no more reasonable code
```

While most of the `FunctionDescription` properties are self-explanatory, some of them have their own quirks and tricky details behind.
For instance, method names must contain round brackets `()` and are actually a kind of a signature without types, e.g. `myFunction(argument:count:)`.

```swift
func myFunction(arg argument: String) -> Int {}
// this function is named "myFunction(arg:)"
```

Function `kind` could only be `free`, while methods could have a `class`, `static` or `instance` kind.

Methods inside protocols have the same set of properties, but contain no body.
The body itself is a text inside curly brackets `{...}`, but without brackets.

```swift
func topLevelFunction() {
}
// this function body is equal to "\n"
```

<a name="arguments" />

#### Arguments

```swift
struct ArgumentDescription: Equatable, CustomDebugStringConvertible {
    let name:           String
    let bodyName:       String
    let type:           TypeDescription
    let defaultValue:   String?
    let annotations:    [Annotation]
    let comment:        String?

    var verse: String
}
```

Function and method arguments all have external and internal names, a type, an optional `defaultValue`, own optional documentation and [annotations](#annotation).

External `name` is an argument name when the function is called. Internal `bodyName` is used insibe function body. Both are mandatory, though they could be equal.

Argument type is described below, see [TypeDescription](#types).

<a name="properties" />

### Properties

Properties are represented with a `PropertyDescription` struct.

```swift
struct PropertyDescription: Equatable, CustomDebugStringConvertible {
    let comment:        String?
    let annotations:    [Annotation]
    let accessibility:  Accessibility
    let constant:       Bool                // is it "let"? If not, it's "var"
    let name:           String
    let type:           TypeDescription
    let defaultValue:   String?             // literally everything after "=", if there is a "="
    let declaration:    Declaration
    let kind:           Kind                // see below
    let body:           String?             // literally everything between curly brackets, but without brackets

    var verse: String
    
    enum Kind {
        case class
        case static
        case instance
    }
}
```

Properties could have documentation and [annotations](#annotation). All properties have own `kind` of `class`, `static` or `instance`.
All properties have names, `constant` boolean flag, accessibility, type (see [TypeDescription](#types)), a raw `defaultValue: String?`
and a `declaration: Declaration`.

Computed properties could also have a `body`, like functions. The body itself is a text inside curly brackets `{...}`,
but without brackets.

<a name="annotation" />

### Annotations

```swift
struct Annotation: Equatable, CustomDebugStringConvertible {
    let name: String
    let value: String?
}
```

Extensibles, enums, functions, methods and properties are all allowed to have documentation.

**Synopsis** parses documentation in order to gather special annotation elements with important meta-information.
These annotations resemble Java annotations, but lack their compile-time checks.

All annotations are required to have a name. Annotations can also contain an optional `String` value.

Annotations are recognized by the `@` symbol, for instance:

```swift
/// @model
class Model {}
```

> N.B. Documentation comment syntax is inherited from the Swift compiler, and for now supports block comments and triple slash comments.
> Method or function arguments usually contain documentation in the nearby inline comments, see below.

Use line breaks or semicolons `;` to divide separate annotations:

```swift
/**
 @annotation1
 @annotation2; @annotation3
 @annotation4 value1
 @annotation5 value2; @annotation5 value3
 @anontation6; @annotation7 value4
 */
```

Keep annotated function or method arguments on their own separate lines for readability:

```swift
func doSomething(
    with argument: String,    // @annotation1
    or argument2: Int,        /* @annotation2 value1; @annotation3 value2 */
    finally argument3: Double // @annotation4; annotation5 value3
) -> Int
```

Though it is not prohibited to have annotations above arguments:

```swift
func doSomething(
    // @annotation1
    with argument: String,
    /* @annotation2 value1; @annotation3 value2 */
    or argument2: Int,
    // @annotation4; annotation5 value3
    finally argument3: Double
) -> Int
```

<a name="types" />

### Types

Property types, argument types, function return types are represented with a `TypeDescription` enum with cases:

* `boolean`
* `integer`
* `floatingPoint`
* `doublePrecision`
* `string`
* `date`
* `data`
* `optional(wrapped: TypeDescription)`
* `object(name: String)`
* `array(element: TypeDescription)`
* `map(key: TypeDescription, value: TypeDescription)`
* `generic(name: String, constraints: [TypeDescription])`

While some of these cases are self-explanatory, others need additional clarification.

`integer` type for now has a limitation, as it represents all `Int` types like `Int16`, `Int32` etc. This means **Synopsis** won't let you determine the `Int` size.

`optional` type contains a wrapped `TypeDescription` for the actual value type. Same happens for arrays, maps and generics.

All object types except for `Data`, `Date`, `NSData` and `NSDate` are represented with an `object(name: String)` case. So, while `CGRect` is a struct, `Synopsis` will still thinks it is an `object("CGRect")`.

<a name="declarations" />

### Declaration

```swift
struct Declaration: Equatable {
    public let filePath:        URL
    public let rawText:         String
    public let offset:          Int
    public let lineNumber:      Int
    public let columnNumber:    Int
}
```

Classes, structs, protocols, properties, methods etc. — almost all detected source code elements have a `declaration: Declaration` property.

`Declaration` structure encapsulates several properties:

* filePath — a URL to the end file, where the source code element was detected;
* rawText — a raw line, which was parsed in order to detect source code element;
* offset — a numer of symbols from the beginning of file to the detected source code element;
* lineNumber — self-explanatory;
* columnNumber — self-explanatory; starts from 1.

<a name="versing" />

### Code generation, templates and versing

Each source code element provides a computed `String` property `verse`, which allows to obtain this element's source code.

This source code is composed programmatically, thus it may differ from the by-hand implementation.

This allows to generate new source code by composing, e.g, `ClassDescrption` instances by hand.

Though, each `ClassDescription` instance requires a `Declaration`, which contains a `filePath`, `rawText`, `offset` and other properties yet to be defined, because such source code hasn't been generated yet.

This is why `ClassDescription` and others provide you with a `template(...)` constructor, which replaces declaration with a special mock object.

Please, consider reviewing `Tests/SynopsisTests/Versing` test cases in order to get familiar with the concept.

```swift
func testVerse_fullyPacked_returnsAsExpected() {
    let enumDescription = EnumDescription.template(
        comment: "Docs",
        accessibility: Accessibility.`private`,
        name: "MyEnum",
        inheritedTypes: ["String"],
        cases: [
            EnumCase.template(comment: "First", name: "firstName", defaultValue: "\"first_name\""),
            EnumCase.template(comment: "Second", name: "lastName", defaultValue: "\"last_name\""),
        ],
        properties: [],
        methods: []
    )
    
    let expectedVerse = """
    /// Docs
    private enum MyEnum: String {
        /// First
        case firstName = "first_name"

        /// Second
        case lastName = "last_name"
    }

    """
    
    XCTAssertEqual(enumDescription.verse, expectedVerse)
}
```

<a name="tests" />

### Running tests

Use `spm_resolve.command` to load all dependencies and `spm_generate_xcodeproj.command` to assemble an Xcode project file.
Also, ensure Xcode targets macOS when running tests.
