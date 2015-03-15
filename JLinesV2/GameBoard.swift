//
//  GameBoard.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 12.03.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation

class GameBoard {
    
    var gameArray: Array2D<Point>
    var lines: [LineType:Line]
    var gameSize: Int
    var numColors: Int?
    var countMoves: Int = 0
    
    init (gameArray: Array2D<Point>, lines: [LineType:Line], gameSize: Int, numColors: Int) {
        
        self.gameSize = gameSize
        self.numColors = numColors
        self.gameArray = gameArray
        self.lines = lines

    }
    
    init (gameSize: Int) {
        let minMaxColorCount = [ // Key: gameSize, worth: min & max count of colors
            5:(4, 5),
            6:(4, 6),
            7:(5, 8),
            8:(5, 9),
            9:(6, 10)
        ]
        self.gameSize = gameSize
        var (minColorCount, maxColorCount) = minMaxColorCount[gameSize]!
        
        self.gameArray =  Array2D<Point>(columns:gameSize, rows: gameSize)
        
        
        //sleep(10)
        self.lines = [LineType:Line]()
        
        numColors = random(minColorCount, max: maxColorCount)

        (gameArray, lines) = generateGameArray()
        
    }

    
    func generateGameArray() -> (Array2D<Point>, [LineType:Line]) {

        let countColors = LineType.LastColor.rawValue - 1
        
        var gameArray = Array2D<Point>(columns:gameSize, rows: gameSize)
        
        //sleep(2)
        for column in 0..<gameSize {  // empty Array generieren
            for row in 0..<gameSize {
                gameArray[column, row] = Point(column: column, row: row, type: LineType.Unknown, originalPoint: false, inLinePoint: false)
                println("column:\(column), row:\(row)")
            }
        }
        var lines = [LineType:Line]()
        var x1 = 0
        var y1 = 0
        var x2 = 0
        var y2 = 0
        var repeat = false

        println("numColors: \(numColors)")
        for ind in 0..<numColors! {

            let color = LineType(rawValue: (LineType.Red.rawValue + ind))!
            do {
                repeat = false
                
                x1 = random(0, max: gameSize)
                y1 = random(0, max: gameSize)

                if gameArray[x1, y1]!.color != LineType.Unknown {
                    repeat = true
                } else {
                    gameArray[x1, y1]!.color = color
                    gameArray[x1, y1]!.originalPoint = true
                    x2 = random(0, max: gameSize)
                    y2 = random(0, max: gameSize)
                    println("x1: \(x1), y1:\(y1), x2: \(x2), y2:\(y2)")
                    if gameArray[x2, y2]!.color != LineType.Unknown {
                        repeat = true
                        gameArray[x1, y1]!.color = LineType.Unknown
                    } else {
                        println("OK: \(x1), \(y1)")
                        gameArray[x2, y2]!.color = color
                        gameArray[x2, y2]!.originalPoint = true
                    }

                }
            
            } while repeat
            
            let line = Line(lineType: color)
            lines[color] = line
            lines[color]!.point1 = Point(column: x1, row: y1, type: color, originalPoint: true, inLinePoint: false)
            lines[color]!.cnt += 1
            lines[color]!.point2 = Point(column: x2, row: y2, type: color, originalPoint: true, inLinePoint: false)
        }
        return (gameArray, lines)

    }
    func random(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min)))
    }
}
