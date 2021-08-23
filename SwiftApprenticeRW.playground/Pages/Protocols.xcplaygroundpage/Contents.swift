//: [Previous](@previous)

import Foundation

// Protocols are basically Interfaces in Java, basically a definition of what the object must include.

protocol Vehicle {
  func accelerate()
  func stop()
}

// Classes, structs, and enumerations can Conform to a protocol.
class Unicycle: Vehicle {
  var peddling = false

  func accelerate() {
    peddling = true
  }

  func stop() {
    peddling = false
  }
}

enum Direction {
  case left
  case right
}

protocol DirectionalVehicle {
  func accelerate()
  func stop()
  func turn(_ direction: Direction)
  func description() -> String
}

// MARK: - Protocol Properties, get/set
protocol VehicleProperties {
  var weight: Int { get }
  var name: String { get set }
}
// Define if properties are read/ read, write

// MARK: - Initializers in Protocols
protocol Account {
  var value: Double { get set }
  init(initialAmount: Double)
  init?(transferAccount: Account)
}
/*
 In the Account protocol above, you define two initializers as part of the protocol. Any type that conforms to Account is required to have these initializers. If you conform to a protocol with required initializers using a class type, those initializers must use the required keyword:
 */
class BitcoinAccount: Account {
  var value: Double
  required init(initialAmount: Double) {
    value = initialAmount
  }
  required init?(transferAccount: Account) {
    guard transferAccount.value > 0.0 else {
      return nil
    }
    value = transferAccount.value
  }
}

var accountType: Account.Type = BitcoinAccount.self
let account = accountType.init(initialAmount: 30.00)
let transferAccount = accountType.init(transferAccount: account)!

// MARK: - Protocol Inheritance
protocol WheeledVehicle: Vehicle {
  var numberOfWheels: Int { get }
  var wheelSize: Double { get set }
}

// MARK: - Associated Types in Protocols
protocol WeightCalculatable {
  associatedtype WeightType
  var weight: WeightType { get }
}
/*
 You can also add an associated type as a protocol member.
 When using associatedtype in a protocol, you’re simply stating there is a type used in this protocol, without specifying what type this should be.
 It’s up to the protocol adopter to decide what the exact type should be.
 */
class HeavyThing: WeightCalculatable {
  // This heavy thing only needs integer accuracy
  typealias WeightType = Int

  var weight: Int { 100 }
}

class LightThing: WeightCalculatable {
  // This light thing needs decimal places
  typealias WeightType = Double

  var weight: Double { 0.0025 }
}
// Bascially allows generics to be used for protocol conformance.

// MARK: - Implementing Multiple Protocols
protocol Wheeled {
  var numberOfWheels: Int { get }
  var wheelSize: Double { get set }
}

class Bike: Vehicle, Wheeled {
  // Implement both Vehicle and Wheeled
}
/*
 A class can only inherit from a single class — this is the property of “single inheritance”.
 In contrast, a class (struct or enum) can be made to conform to as many protocols as you’d like!
 */

// MARK: - Protocol Composition
// If you need to pass an object that conforms to multiple protocols, connect them with the "&" operator.
func roundAndRound(transportation: Vehicle & Wheeled) { // <<< & here
    transportation.stop()
    print("The brakes are being applied to
          \(transportation.numberOfWheels) wheels.")
}

roundAndRound(transportation: Bike())
// The brakes are being applied to 2 wheels.


// MARK: - Key Points
/*
 - Protocols define a contract that classes, structs and enums can adopt.
 - By adopting a protocol, a type is required to conform to the protocol by implementing all methods and properties of the protocol.
- A type can adopt any number of protocols, which allows for a quasi-multiple inheritance not permitted through subclassing.
 - You can use extensions for protocol adoption and conformance.
 - The Swift standard library uses protocols extensively. You can use many of them, such as Equatable and Hashable, on your own named types.
 */

//: [Next](@next)
