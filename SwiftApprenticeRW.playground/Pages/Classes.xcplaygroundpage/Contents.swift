//: [Previous](@previous)

import Foundation

// Classes are Reference types
struct Grade {
  var letter: Character
  var points: Double
  var credits: Double
}

class Person {
  var firstName: String
  var lastName: String
  
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

class Student {
  var firstName: String
  var lastName: String
  var grades: [Grade] = []
  
  required init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  
  // Convenience initializers are used to call other other, non-convenience initializers, that will handle the init instead of rewriting that logic.
  convenience init(transfer: Student) {
    self.init(firstName: transfer.firstName, lastName: transfer.lastName)
  }
  
  func recordGrade(_ grade: Grade) {
    grades.append(grade)
  }
}

let john = Person(firstName: "Johnny", lastName: "Appleseed")

// MARK: - Reference types share well... a reference to the same object
var homeOwner = john
john.firstName = "John" // John wants to use his short name!
john.firstName // "John"
homeOwner.firstName // "John"

// MARK: - Object Identity
john === homeOwner // true, these point to the same reference.


// MARK: - Preventing Inheritance
/*
 Sometimes you’ll want to disallow subclasses of a particular class. Swift provides the final keyword for you to guarantee a class will never get a subclass:
 */
final class FinalStudent: Person {}
//class FinalStudentAthlete: FinalStudent {} // Build error!

// You can also mark methods as final to prevent them from being overridden by subclasses.
class AnotherStudent: Person {
  final func recordGrade(_ grade: Grade) {}
}

class AnotherStudentAthlete: AnotherStudent {
  //override func recordGrade(_ grade: Grade) {} // Build error!
}


// MARK: - Two Phase Initialization
class StudentAthlete: Student {
  var sports: [String]
  // This is required from Student Class, so must be called in any sub classes of Student.
  required init(firstName: String, lastName: String) {
    self.sports = []
    super.init(firstName: firstName, lastName: lastName)
  }
  
  init(firstName: String, lastName: String, sports: [String]) {
    // 1
    self.sports = sports
    // 2
    let passGrade = Grade(letter: "P", points: 0.0, credits: 0.0)
    // 3
    super.init(firstName: firstName, lastName: lastName)
    // 4
    recordGrade(passGrade)
  }
}
/*
 1). First, you initialize the sports property of StudentAthlete. This is part of the first phase of initialization and has to be done early, before you call the superclass initializer.
 2). Although you can create local variables for things like grades, you can’t call recordGrade(_:) yet because the object is still in the first phase.
 3). Call super.init. When this returns, you know that you’ve also initialized every class in the hierarchy, because the same rules are applied at every level.
 4). After super.init returns, the initializer is in phase 2, so you call recordGrade(_:).
 */


// MARK: - deinit
class Person2 {
  var firstName: String
  var lastName: String
  
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  // original code
  deinit {
    print("\(firstName) \(lastName) is being removed from memory!")
  }
}

// MARK: - Retain Cycles and weak references
class Student2: Person2 {
  
  weak var partner: Student2?
  // original code
  deinit {
    print("\(firstName) is being deallocated!")
  }
}

var alice: Student2? = Student2(firstName: "Alice", lastName: "Appleseed")
var bob: Student2? = Student2(firstName: "Bob", lastName: "Appleseed")

// Create a reference between alice and bob.
alice?.partner = bob
bob?.partner = alice
// Now set alice and bob nil
alice = nil
bob = nil
// You won't see the deallocated message in the deinit!
// Alice and Bob have a reference to each other so the reference count never reaches 0, causing a common memory leak.
// To fix this add keyword "weak" to the partner variable.

// MARK: - Key Points
/*
 *Key points*
 
 - Class inheritance is one of the most important features of classes and enables polymorphism.
 - Subclassing is a powerful tool, but it’s good to know when to subclass. Subclass when you want to extend an object and could benefit from an “is-a” relationship between subclass and superclass, but be mindful of the inherited state and deep class hierarchies.
 - The keyword override makes it clear when you are overriding a method in a subclass.
 - The keyword final can be used to prevent a class from being subclassed.
 - Swift classes use two-phase initialization as a safety measure to ensure all stored properties are initialized before they are used.
 - Class instances have their own lifecycles which are controlled by their reference counts.
 - Automatic reference counting, or ARC, handles reference counting for you automatically, but it’s important to watch out for retain cycles.
 */

//: [Next](@next)
