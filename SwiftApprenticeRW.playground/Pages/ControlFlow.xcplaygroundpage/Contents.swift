//: [Previous](@previous)

import Foundation

// Includes the 5
let closedRange = 0...5
// Does not include the 5
let halfOpenRange = 0..<5

//MARK: - For Loop
// Conditional For loop
let count = 10
var sum = 0
for i in 1...count where i % 2 == 1 {
  sum += 1
}
sum

//MARK: - Advanced Switch Statements
let hourOfDay = 12
var timeOfDay = ""

// Comma separation
switch hourOfDay {
case 0, 1, 2, 3, 4, 5:
  timeOfDay = "Early morning"
case 6, 7, 8, 9, 10, 11:
  timeOfDay = "Morning"
case 12, 13, 14, 15, 16:
  timeOfDay = "Afternoon"
case 17, 18, 19:
  timeOfDay = "Evening"
case 20, 21, 22, 23:
  timeOfDay = "Late evening"
default:
  timeOfDay = "INVALID HOUR!"
}

timeOfDay

// Ranges
switch hourOfDay {
case 0...5:
  timeOfDay = "Early morning"
case 6...11:
  timeOfDay = "Morning"
case 12...16:
  timeOfDay = "Afternoon"
case 17...19:
  timeOfDay = "Evening"
case 20..<24:
  timeOfDay = "Late evening"
default:
  timeOfDay = "INVALID HOUR!"
}

timeOfDay


//: [Next](@next)
