// Playground - noun: a place where people can play

import UIKit
import Foundation

var str: NSMutableString = "Hello, playground"
var anotherstr = str as NSString

let len: Int =  str.length


var randomIndex = Int(arc4random_uniform(UInt32(len)))

anotherstr.substringWithRange(NSRange(location: randomIndex, length: 1))

