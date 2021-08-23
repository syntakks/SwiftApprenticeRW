//: [Previous](@previous)

import Foundation

enum Month {
  case january
  case february
  case march
  case april
  case may
  case june
  case july
  case august
  case september
  case october
  case november
  case december
}
// Same enum but inline with commas.
enum Month2 {
  case january, february, march, april, may, june, july, august,
       september, october, november, december
}

// MARK: - Switching over enum type.
func semester(for month: Month) -> String {
  switch month {
  case .august, .september, .october, .november, .december:
    return "Autumn"
  case .january, .february, .march, .april, .may:
    return "Spring"
  case .june, .july:
    return "Summer"
  }
}
// MARK: - Using self.rawValue to determine property value.
// 1
enum Icon: String {
  case music
  case sports
  case weather
  
  var filename: String {
    // 2
    "\(rawValue).png"
  }
}
let icon = Icon.weather
icon.filename // weather.png

// MARK: - Unordered Raw Values
// Enum values don't have to be sequential. Coins are a good example of this.
enum Coin: Int {
  case penny = 1
  case nickel = 5
  case dime = 10
  case quarter = 25
}

// MARK: - Associated Values
/*
 Here are some unique qualities of associated values:
 
 1). Each enumeration case has zero or more associated values.
 2). The associated values for each enumeration case have their own data type.
 3). You can define associated values with label names like you would for named function parameters.
 An enumeration can have raw values or associated values, but not both.
 */
enum WithdrawalResult {
  case success(newBalance: Int)
  case error(message: String)
}

var balance = 100

func withdraw(amount: Int) -> WithdrawalResult {
  if amount <= balance {
    balance -= amount
    return .success(newBalance: balance)
  } else {
    return .error(message: "Not enough money!")
  }
}

let result = withdraw(amount: 99)

switch result {
case .success(let newBalance):
  print("Your new balance is: \(newBalance)")
case .error(let message):
  print(message)
}

// MARK: - Uninhabited Types AKA Bottom Types
// These are enums without any cases. This allows you to create name spacing and prevent creation of unnecessary objects. Math.factorial() instead of Math().factorial()
enum Math {
  static func factorial(of number: Int) -> Int {
    (1...number).reduce(1, *)
  }
}
let factorial = Math.factorial(of: 6) // 720

//: [Next](@next)
