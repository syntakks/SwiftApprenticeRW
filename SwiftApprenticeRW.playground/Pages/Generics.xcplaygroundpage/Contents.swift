//: [Previous](@previous)

import Foundation

// The Generic Type Keeper has a placeholder value "Animal", commonly seen as "T" or Type.
// Animal Could be anything at this point.
class Keeper<Animal: Pet> {
  var name: String
  var morningCare: Animal
  var afternoonCare: Animal

  init(name: String, morningCare: Animal, afternoonCare: Animal) {
    self.name = name
    self.morningCare = morningCare
    self.afternoonCare = afternoonCare
  }
}

class Cat {
  var name: String

  init(name: String) {
    self.name = name
  }
}

class Dog {
  var name: String

  init(name: String) {
    self.name = name
  }
}

// Now when you instantiate a Keeper, Swift will make sure, at compile-time, that the morning and afternoon types are the same.
let jason = Keeper(name: "Jason", morningCare: Cat(name: "Whiskers"), afternoonCare: Cat(name: "Sleepy"))
// Try instatiating another Keeper but this time for dogs?
let steve = Keeper(name: "Steve", morningCare: Dog(name: "Loki"), afternoonCare: Dog(name: "Loki's Brother"))
//let stringTest = Keeper(name: "Steve", morningCare: String("Will this work?"), afternoonCare: String("Another string?"))
// Notice that we could make a Keeper of strings... kinda pointless.

// MARK: - Type Constraints
// To ensure your Keeper only works on pets we'll have to change our definitions up a bit.
class Keeper2<Animal: Pet> {
  // Definiition body as before
}

protocol Pet {
  var name: String { get }
}
// Add protocol conformance in extensions. The call to String under "steve" keeper above no longer compiles.
extension Cat: Pet {}
extension Dog: Pet {}
// MARK: - Where Clause
// Lets say you want arrays of cats to all have a meow function... annoying.
extension Array where Element: Cat {
  func meow() {
    forEach { print("\($0.name) says meow!") }
  }
}

// MARK: - Conditional Conformance
protocol Meowable {
  func meow()
}

extension Cat: Meowable {
  func meow() {
    print("\(self.name) says meow!")
  }
}
// This could also be done by saying: "An array is Meowable if all it's elements are also Meowable"
extension Array: Meowable where Element: Meowable {
  func meow() {
    forEach { $0.meow() }
  }
}

let cats = Array(repeating: Cat(name: "Mia"), count: 20)
cats.meow()

// MARK: - Generic function Parameters
// This function takes two arguments and swaps their order in a tuple:
func swapped<T, U>(_ x: T, _ y: U) -> (U, T) {
  (y, x)
}

swapped(33, "Jay")  // returns ("Jay", 33)

// MARK: - Challenge (Build a collection) Consider the pet and keeper example from earlier:
// A keeper can have a collection of animals instead of just 2
// func countAnimals()
// func animalAtIndex(_ index:)
// func lookAfter(_ animal:)

class Cat3 {
  var name: String

  init(name: String) {
    self.name = name
  }
}

class Dog3 {
  var name: String

  init(name: String) {
    self.name = name
  }
}

class Keeper3<Animal> {
  var name: String
  var animals: [Animal] = []

  init(name: String) {
    self.name = name
  }
  
  func lookAfter(_ animal: Animal) {
    animals.append(animal)
  }
  
  func countAnimals() {
    print("\(name) is watching \(animals.count) animals")
  }
  
  func animalAtIndex(_ index: Int) -> Animal {
    return animals[index]
  }
}

// MARK: - Key Points
/*
 Key points
 - Generics are everywhere in Swift: in optionals, arrays, dictionaries, other collection structures, and most basic operators like + and ==.
 - Generics express systematic variation at the level of types via type parameters that range over possible concrete types.
 - Generics are like functions for the compiler. They are evaluated at compile-time and result in new types, which are specializations of the generic type.
 - A generic type is not a real type on its own, but more like a recipe, program, or template for defining new types.
 - Swift provides a rich system of type constraints, which lets you specify what types are allowed for various type parameters.
 */









//: [Next](@next)
