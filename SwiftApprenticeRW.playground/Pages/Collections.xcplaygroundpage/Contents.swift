//: [Previous](@previous)

import Foundation

// Create an array with default values
let allZeros = Array(repeating: 0, count: 5) // [0, 0, 0, 0, 0]

//MARK: - Array slice
var players = ["Alice", "Bob", "Cindy", "Dan"]
// This will share storage with the players array instead of making new copy right away.
let upcomingPlayerSlice = players[1...2]
// Cast to array to make a copy from an array slice.
let copy = Array(players[1...2])


//MARK: - Range Contains
players[1...3].contains("Bob")

//MARK: - Dictionary (Reserve Capacity)
var pairs: [String: Int] = [:]
pairs.reserveCapacity(20)
// Using reserveCapacity(_:) is an easy way to improve performance when you have an idea of how much data the dictionary needs to store.

//MARK: - isEmpty > count check
/*
 Note: If you want to know whether a collection has elements or not, it is always better to use the isEmpty property than comparing count to zero.
 Although arrays and dictionaries compute count in constant time, not every collection is guaranteed to do so.
 For example, count on a String needs to loop through all of its characters.
 isEmpty, by contrast, always runs in constant time no matter how many values there are for every collection type.
 */

// MARK: - Dictionary: Add/ Remove
var bobData = [
  "name": "Bob",
  "profession": "Card Player",
  "country": "USA"
]

// 2 ways to add (subscripting or method)
bobData.updateValue("CA", forKey: "state")
bobData["city"] = "San Francisco"

bobData.removeValue(forKey: "state")
bobData["city"] = nil

/*
 Note: If you’re using a dictionary that has values that are optional types, dictionary[key] = nil still removes the key completely.
 If you want keep the key and set the value to nil you must use the updateValue method.
 */

// MARK: - Key Points
/*
 Key points
 Sets
 - Are unordered collections of unique values of the same type.
 - Are most useful when you need to know whether something is included in the collection or not.
 
 Dictionaries
 -Are unordered collections of key-value pairs.
 -The keys are all of the same type, and the values are all of the same type.
 -Use subscripting to get values and to add, update or remove pairs.
 -If a key is not in a dictionary, lookup returns nil.
 -The key of a dictionary must be a type that conforms to the Hashable protocol.
 -Basic Swift types such as String, Int, Double are Hashable out of the box.
 
 Arrays:
 - Are ordered collections of values of the same type.
 - Use subscripting, or one of the many properties and methods, to access and update elements.
 - Be wary of accessing an index that’s out of bounds.
 */

//: [Next](@next)
