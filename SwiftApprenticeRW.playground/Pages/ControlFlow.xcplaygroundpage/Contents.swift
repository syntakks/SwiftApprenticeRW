//: [Previous](@previous)

import Foundation

// Includes the 5
let closedRange = 0...5
// Does not include the 5
let halfOpenRange = 0..<5

// Conditional For loop
let count = 10
var sum = 0
for i in 1...count where i % 2 == 1 {
  sum += 1
}
sum


//: [Next](@next)
