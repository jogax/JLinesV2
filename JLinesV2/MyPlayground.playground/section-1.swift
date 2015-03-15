// Playground - noun: a place where people can play

import Foundation

var str = "Hello, playground"
var minColorCount = 0
var maxColorCount = 0
let gameSize = 7
let numColors = 0

switch gameSize {
case 5: minColorCount = 4; maxColorCount = 5
case 6: minColorCount = 4; maxColorCount = 6
case 7: minColorCount = 5; maxColorCount = 8
case 8: minColorCount = 5; maxColorCount = 9
case 9: minColorCount = 6; maxColorCount = 10
default: (0, 0)
    
}
let wert = numColors == 0 ? (minColorCount + Int(arc4random()) % (maxColorCount - minColorCount)) : numColors
