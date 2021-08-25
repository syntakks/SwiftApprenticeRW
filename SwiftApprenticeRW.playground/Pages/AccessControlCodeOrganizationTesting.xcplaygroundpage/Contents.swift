//: [Previous](@previous)

import Foundation
import XCTest

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

/*
 The private modifier used in the brief example above is one of several access modifiers available to you in Swift:
 private: Accessible only to the defining type, all nested types and extensions on that type within the same source file.
 fileprivate: Accessible from anywhere within the source file in which it’s defined.
 internal: Accessible from anywhere within the module in which it’s defined. This level is the default access level. If you don’t write anything, this is what you get.
 public: Accessible from anywhere that imports the module.
 open: The same as public, with the additional ability granted to override the code in another module.
 */

// MARK: - Deprecation messages
@available(*, deprecated, message: "This testFunction is deprecated, use something else instead. ")
func testFunction() {}

/*
 The asterisk in the parameters denotes which platforms are affected by this deprecation. It accepts the values *, iOS, iOSMac, tvOS or watchOS. The second parameter details whether this method is deprecated, renamed or unavailable.
 */

// MARK: - Checking Account

class CheckingAccount: BasicAccount {
  private var issuedChecks: [Int] = []
  private var currentCheck = 1
  private let accountNumber = UUID().uuidString
  
  class Check {
    let account: String
    var amount: Dollars
    private(set) var cashed = false
    
    func cash() {
      cashed = true
    }
    
    init(amount: Dollars, from account: CheckingAccount) {
      self.amount = amount
      self.account = account.accountNumber
    }
  }
  
  func writeCheck(amount: Dollars) -> Check? {
    guard balance > amount else {
      return nil
    }
    
    let check = Check(amount: amount, from: self)
    withdraw(amount: check.amount)
    return check
  }
  
  func deposit(_ check: Check) {
    guard !check.cashed else {
      return
    }
    
    deposit(amount: check.amount)
    check.cash()
  }
  
}

private extension CheckingAccount {
  func inspectForFraud(with checkNumber: Int) -> Bool {
    issuedChecks.contains(checkNumber)
  }
  
  func nextNumber() -> Int {
    let next = currentCheck
    currentCheck += 1
    return next
  }
}

extension CheckingAccount: CustomStringConvertible {
  public var description: String {
    "Checking Balance: $\(balance)"
  }
}

// MARK: - Savings Account
class SavingsAccount: BasicAccount {
  var interestRate: Double
  private let pin: Int
  
  init(interestRate: Double, pin: Int) {
    self.interestRate = interestRate
    self.pin = pin
  }
  
  @available(*, deprecated, message: "Use processInterest(pin:) instead")
  
  func processInterest(pin: Int) {
    if pin == self.pin {
      let interest = balance * interestRate
      deposit(amount: interest)
    }
  }
  
}


//func createAccount() ->  Account { // Protocol 'Account' can only be used as a generic constraint because it has Self or associated type requirements
//  CheckingAccount()
//}

// This code is an opaque return type, and it lets the function decide what kind of Account it wants to return without exposing the class type.
func createAccount() -> some Account {
  CheckingAccount()
}

// MARK: - Unit Tests
/*
 Writing tests
 - Once you have your test class ready, it’s time to add some tests. Tests should cover the core functionality of your code and some edge cases. The acronym FIRST describes a concise set of criteria for useful unit tests. Those criteria are:
 - Fast: Tests should run quickly.
 - Independent/Isolated: Tests should not share state.
 - Repeatable: You should obtain the same results every time you run a test.
 - Self-validating: Tests should be fully automated. The output should be either “pass” or “fail”.
 - Timely: Ideally, write tests before you write the code they test (Test-Driven Development).
 - Adding tests to a test class is super easy - just add a function that starts with the word test, takes no arguments and returns nothing.
 */
class BankingTests: XCTestCase {
  
  var checkingAccount: CheckingAccount!
  
  // This setup method runs before each test.
  override func setUp() {
    super.setUp()
    checkingAccount = CheckingAccount()
  }
  
  // This will also run after each test. Here we are only setting the account back to zero for example as the setup just inits a new instance.
  override func tearDown() {
    checkingAccount.withdraw(amount: checkingAccount.balance)
    super.tearDown()
  }
  
  func testSomething() {}
  
  func testNewAccountBalanceZero() {
    XCTAssertEqual(checkingAccount.balance, 0)
  }
  
  // Creates a new account and tries to write a check for 100 with 0 balance.
  func testCheckOverBudgetFails() {
    let check = checkingAccount.writeCheck(amount: 100)
    XCTAssertNil(check)
  }
  
  /*
   If a certain pre-condition isn’t met, you can opt to fail the test. For example, suppose you’re writing a test to verify an API that’s only available on iOS 14 and above. In that case, you can fail the test for iOS simulators running older versions with an informative message:
   */
  func testNewAPI() {
    guard #available(iOS 14, *) else {
      XCTFail("Only available in iOS 14 and above")
      return
    }
    // perform test
  }
  
  // Alternatively, instead of failing the test, you can skip it. XCTSkip is a type of Error that a test can throw.
  func testNewAPIButSkipInstead() throws {
    guard #available(iOS 14, *) else {
      throw XCTSkip("Only available in iOS 14 and above")
    }
    // perform test
  }
  
  
  
}

// Lets pretend this Banking class has private things inside we want to Test Assert on
//@testable import Banking
/*
 This attribute makes your internal interface visible. (Note: Private API remains private.) This technique is an excellent tool for testing, but you should never do this in production code. Always stick to the public API there.
 */


// Running the tests in playgrounds
BankingTests.defaultTestSuite.run()


/*
 Key points
 - Access control modifiers are private, fileprivate, internal, public and open. The internal access level is the default.
 - Modifiers control your code’s visible interface and can hide complexity.
 - private and fileprivate protect code from being accessed by code in other types or files, respectively.
 - public and open allow code access from another module. The open modifier additionally lets you override from other modules.
 - When you apply access modifiers to extensions, all members of the extension receive that access level.
 - Extensions that mark protocol conformance cannot have access modifiers.
 - The keyword available can be used to evolve a library by deprecating APIs.
 - You use unit tests to verify your code works as expected.
 - @testable import lets you test internal API.
 */

//: [Next](@next)
