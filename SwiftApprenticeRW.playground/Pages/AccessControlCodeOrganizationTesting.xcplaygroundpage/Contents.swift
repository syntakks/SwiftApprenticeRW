//: [Previous](@previous)

import Foundation

/// A protocol describing core functionality for an account
protocol Account {
  associatedtype Currency
  
  var balance: Currency { get }
  func deposit(amount: Currency)
  func withdraw(amount: Currency)
}

typealias Dollars = Double

/// A U.S. Dollar based "basic" account.
class BasicAccount: Account {
  
  private(set) var balance: Dollars = 0.0 // Adding private(set) means this property has a private setter. Outside classes cannot set the value.
  
  func deposit(amount: Dollars) {
    balance += amount
  }
  
  func withdraw(amount: Dollars) {
    if amount <= balance {
      balance -= amount
    } else {
      balance = 0
    }
  }
}

// MARK: - Lack of Access Control
// Create a new account
let account = BasicAccount()

// Deposit and withdraw some money
account.deposit(amount: 10.00)
account.withdraw(amount: 5.00)

// ... or do evil things!
//account.balance = 1000000.00
// Balance is set as read only in the protocol but can be set in the BasicAccount type.
// with balance now set as private(set) var, this will no longer compile.

/*
 Note: Access control is not a security feature that protects your code from malicious hackers.
 Instead, it lets you express intent by generating helpful compiler errors if a user attempts directly access
 implementation details that may compromise the invariant, and therefore, correctness.
 */










//: [Next](@next)
