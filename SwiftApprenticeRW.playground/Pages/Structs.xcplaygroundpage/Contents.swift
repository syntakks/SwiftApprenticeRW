//: [Previous](@previous)

import Foundation
// Structs are value types. When mutating properties of a struct, it's really just making a copy of the struct under the hood.

// MARK: - Computed Properties
struct TV {
  var height: Double
  var width: Double
  
  // 1 (Computed Property)
  var diagonal: Int {
    // 2
    let result = (height * height +
      width * width).squareRoot().rounded()
    // 3
    return Int(result)
  }
}

/*
 1). You use an Int type for your diagonal property. Although height and width are each a Double, TV sizes are usually advertised as nice, round numbers such as 50” rather than 49.52”. Instead of the usual assignment operator = to assign a value as you would for a stored property, you use curly braces to enclose your computed property’s calculation.
 2). As you’ve seen before in this book, geometry can be handy; once you have the width and height, you can use the Pythagorean theorem to calculate the diagonal length. You use the rounded method to round the value with the standard rule: If it the decimal is 0.5 or above, it rounds up; otherwise, it rounds down.
 3). Now that you’ve got a properly-rounded number, you return it as an Int. Had you converted result directly to Int without rounding first, the result would have been truncated, so 109.99 would have become 109.
 Computed properties don’t store any values; they return values based on calculations. From outside of the structure, a computed property can be accessed just like a stored property.
 */

// MARK: - Get/ Set
struct TV2 {
  var height: Double
  var width: Double
  
  var diagonal: Int {
    // 1
    get {
      // 2
      let result = (height * height +
        width * width).squareRoot().rounded()
      return Int(result)
    }
    set {
      // 3
      let ratioWidth = 16.0
      let ratioHeight = 9.0
      // 4
      let ratioDiagonal = (ratioWidth * ratioWidth +
        ratioHeight * ratioHeight).squareRoot()
      height = Double(newValue) * ratioHeight / ratioDiagonal
      width = height * ratioWidth / ratioHeight
    }
  }
}

/*
 1). Because you want to include a setter, you now have to be explicit about which calculations comprise the getter and which the setter, so you surround each code block with curly braces and precede it with either get or set. This specificity isn’t required for read-only computed properties, as their single code block is implicitly a getter.
 2). You use the same code as before to get the computed value.
 3). For a setter, you usually have to make some kind of assumption. In this case, you provide a reasonable default value for the screen ratio.
 4). The formulas to calculate height and width, given a diagonal and a ratio, are a bit deep. You could work them out with a bit of time, but I’ve done the dirty work for you and provided them here. The important parts to focus on are:
 - The newValue constant lets you use whatever value was passed in during the assignment.
 - Remember, the newValue is an Int, so to use it in a calculation with a Double, you must first convert it to a Double.
 - Once you’ve done the calculations, you assign the height and width properties of the TV structure.
 - In addition to setting the height and width directly, you can set them indirectly by setting the diagonal computed property. When you set this value, your setter will calculate and store the height and width.

 - Notice that there’s no return statement in a setter — it only modifies the other stored properties. With the setter in place, you have a nice little screen size calculator:
 */


// MARK: - Property Observer (willSet/ didSet)
struct Level {
  static var highestLevel = 1
  let id: Int
  var boss: String
  var unlocked: Bool {
    didSet {
      if unlocked && id > Self.highestLevel {
        Self.highestLevel = id
      }
    }
  }
}

// MARK: - Limiting a Variable
struct LightBulb {
  static let maxCurrent = 40
  var current = 0 {
    didSet {
      if current > LightBulb.maxCurrent {
        print("""
              Current is too high,
              falling back to previous setting.
              """)
        current = oldValue
      }
    }
  }
}

// MARK: - Lazy Properties
/*
 Lazy properties
 If you have a property that might take some time to calculate, you don’t want to slow things down until you actually need the property. Say hello to the lazy stored property. It is useful for such things as downloading a user’s profile picture or making a serious calculation.

 Look at this example of a Circle structure that uses pi in its circumference calculation:
 */
struct Circle {
  lazy var pi = {
    ((4.0 * atan(1.0 / 5.0)) - atan(1.0 / 239.0)) * 4.0
  }()
  var radius = 0.0
  var circumference: Double {
    mutating get {
      pi * radius * 2
    }
  }
  init(radius: Double) {
    self.radius = radius
  }
}
// NOTE: The value for pi is not set until it is first used. Then it keeps the value of pi in memory.
// ALSO NOTE: Since this is a struct, the getter on "circumference" needs to be mutating, as the first call to pi, changes the structs properties, thus mutating the value type.

// MARK: - init() in extensions to preserve automatically generated memberwise initializer.
/*
 Keeping the compiler-generated initializer using extensions
 With the SimpleDate structure, you saw that once you added your own init(), the compiler-generated memberwise initializer disappeared. It turns out that you can keep both if you add your init() to an extension to SimpleDate:
 */

struct SimpleDate {
  var month = "January"
  var day = 1
  
  func monthsUntilWinterBreak() -> Int {
    months.firstIndex(of: "December")! -
    months.firstIndex(of: month)!
  }
  
  mutating func advance() {
    day += 1
  }
}

extension SimpleDate {
  init(month: Int, day: Int) {
    self.month = months[month-1]
    self.day = day
  }
}

/*
 init(month:day:) gets added to SimpleDate without sacrificing the automatically generated memberwise initializer. You can create an instance using the month index Int instead of the month name String. Hooray!
 */



//: [Next](@next)
