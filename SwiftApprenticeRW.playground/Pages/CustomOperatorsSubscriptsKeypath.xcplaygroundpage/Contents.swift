//: [Previous](@previous)

import Foundation

// MARK: - Custom Operator
//infix operator **

func **<T: BinaryInteger>(base: T, power: Int) -> T {
  precondition(power >= 2)
  var result = base
  for _ in 2...power {
    result *= base
  }
  return result
}

let base = 2
let exponent = 2
base ** exponent

// MARK: - Compound Custom Operator
infix operator **=
// inout changes the value passed in directly instead of returning a value.
func **=<T: BinaryInteger>(lhs: inout T, rhs: Int) {
  lhs = lhs ** rhs
}

var number = 2
number **= exponent

// MARK: - Testing, Generic allows use of all these types.
let unsignedBase: UInt = 2
let unsignedResult = unsignedBase ** exponent

let base8: Int8 = 2
let result8 = base8 ** exponent

let unsignedBase8: UInt8 = 2
let unsignedResult8 = unsignedBase8 ** exponent

let base16: Int16 = 2
let result16 = base16 ** exponent

let unsignedBase16: UInt16 = 2
let unsignedResult16 = unsignedBase16 ** exponent

let base32: Int32 = 2
let result32 = base32 ** exponent

let unsignedBase32: UInt32 = 2
let unsignedResult32 = unsignedBase32 ** exponent

let base64: Int64 = 2
let result64 = base64 ** exponent

let unsignedBase64: UInt64 = 2
let unsignedResult64 = unsignedBase64 ** exponent

// MARK: - Precedence and Associativity
/*
 Precedence: Should the multiplication be done before or after the exponentiation?
 Associativity: Should the consecutive exponentiations be done left to right, or right to left?
 */
//2 * 2 ** 3 ** 2 // Does not compile!
// Parentheses can make xcode understand order of operations
2 * (2 ** (3 ** 2))
// We can define our own precedence goroup.
precedencegroup ExponentationPrecedence {
  associativity: right
  higherThan: MultiplicationPrecedence
}
infix operator **: ExponentationPrecedence
2 * 2 ** 3 ** 2 // Now this compiles.

// MARK: - Subscripts
/* Subscript syntax is as follows:
 subscript(parameterList) -> ReturnType {
  get {
  // return someValue of ReturnType
  }
 
  set(newValue) {
  // set someValue of ReturnType to newValue
  }
 }
 */
class Person {
  let name: String
  let age: Int
  
  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
}

extension Person {
  subscript(property key: String) -> String? {
    switch key {
    case "name":
      return name
    case "age":
      return "\(age)"
    default:
      return nil
    }
  }
}

let me = Person(name: "Steve", age: 33)
me[property: "name"]
me[property: "age"]
me[property: "gender"]

// MARK: - Static Subscripts
class File {
  let name: String
  
  init(name: String) {
    self.name = name
  }
  
  // 1
  static subscript(key: String) -> String {
    switch key {
    case "path":
      return "custom path"
    default:
      return "default path"
    }
  }
}

File["path"]
File["PATH"]

// MARK: - Dynamic Member Lookup
// You use dynamic member lookup to provide arbitrary dot syntax to your type.
@dynamicMemberLookup
class Instrument {
  let brand: String
  let year: Int
  private let details: [String: String]
  
  init(brand: String, year: Int, details: [String: String]) {
    self.brand = brand
    self.year = year
    self.details = details
  }
  
  // outer "dynamicMember" name required when using @dynamicMembershipLookup
  subscript(dynamicMember key: String) -> String {
    switch key {
    case "info":
      return "\(brand) made in \(year)."
    default:
      return details[key] ?? ""
    }
  }
}

// 3
let instrument = Instrument(brand: "Roland", year: 2019,
                            details: ["type": "acoustic",
                                      "pitch": "C"])
instrument.info
instrument.pitch

// A derived class inherits dynamic member lookup from its base one:
class Guitar: Instrument {}
let guitar = Guitar(brand: "Fender", year: 2019,
                    details: ["type": "electric", "pitch": "C"])
guitar.info

// MARK: - Class Subscripts
// We can also make classes use dynamic member lookup.
@dynamicMemberLookup
class Folder {
  let name: String
  
  init(name: String) {
    self.name = name
  }
  
  class subscript(dynamicMember key: String) -> String {
    switch key {
    case "path":
      return "custom path"
    default:
      return "default path"
    }
  }
}

Folder.path
Folder.PATH

// MARK: - Keypaths
class Tutorial {
  let title: String
  let author: Person
  let details: (type: String, category: String)
  
  init(title: String, author: Person,
       details: (type: String, category: String)) {
    self.title = title
    self.author = author
    self.details = details
  }
}

let tutorial = Tutorial(title: "Object Oriented Programming in Swift",
                        author: me,
                        details: (type: "Swift",
                                  category: "iOS"))

let title = \Tutorial.title // Keypath
let tutorialTitle = tutorial[keyPath: title]
// Keypaths can access properties several levels deep:
let authorName = \Tutorial.author.name
var tutorialAuthor = tutorial[keyPath: authorName]
// You can also use keypaths for tuples in Swift:
let type = \Tutorial.details.type
let tutorialType = tutorial[keyPath: type]
let category = \Tutorial.details.category
let tutorialCategory = tutorial[keyPath: category]
// You can make new keypaths by appending to existing ones like this:
let authorPath = \Tutorial.author
let authorNamePath = authorPath.appending(path: \.name)
tutorialAuthor = tutorial[keyPath: authorNamePath]

// MARK: - Setting Properties
class Jukebox {
  var song: String
  
  init(song: String) {
    self.song = song
  }
}

let jukebox = Jukebox(song: "Nothing Else Matters")
let song = \Jukebox.song
jukebox[keyPath: song] = "Stairway to Heaven"

// MARK: - Keypath member lookup
// 1
struct Point {
  let x, y: Int
}

// 2
@dynamicMemberLookup
struct Circle {
  let center: Point
  let radius: Int
  
  // 3
  subscript(dynamicMember keyPath: KeyPath<Point, Int>) -> Int {
    center[keyPath: keyPath]
  }
}

// 4
let center = Point(x: 1, y: 2)
let circle = Circle(center: center, radius: 1)
circle.x
circle.y

/*
 Key points
 - Remember the custom operators mantra when creating brand new operators from scratch: With great power comes great responsibility. Make sure the additional cognitive overhead of a custom operator introduces pays for itself.
 - Choose the appropriate type for custom operators: postfix, prefix or infix.
 - Don’t forget to define any related operators, such as compound assignment operators, for custom operators.
 - Use subscripts to overload the square brackets operator for classes, structures and enumerations.
 - Use keypaths to create dynamic references to properties.
 - Use dynamic member lookup to provide type safe dot syntax access to internal properties.
 */

//: [Next](@next)
