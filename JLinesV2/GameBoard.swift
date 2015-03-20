//
//  GameBoard.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 12.03.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation

struct Member: Hashable {
    var x: Int
    var y: Int
    var checked: Bool
    var hashValue: Int {
        return x * 100 + y
    }
}

func ==(lhs: Member, rhs: Member) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}



class GameBoard {
    struct Area {
        var points:Array<Member>
        var countNotCheckedMembers: Int
        
        init () {
            points = Array<Member>()
            countNotCheckedMembers = 0
        }
    }

    
    var gameArray: Array2D<Point>
    var directions: Array2D<Directions>
    var tempGameArray: Array2D<Point>?
    var tempDirections: Array2D<Directions>?
    var lowCountDirections: Array<(Int, Int)>?
    var lines: [LineType:Line]
    var gameSize: Int
    var numColors: Int?
    var countMoves: Int = 0
    var areas = [Int:Area]()
    
    init (gameArray: Array2D<Point>, lines: [LineType:Line], gameSize: Int, numColors: Int) {
        
        self.gameSize = gameSize
        self.numColors = numColors
        self.gameArray = gameArray
        self.lines = lines
        self.directions = Array2D<Directions>(columns:gameSize, rows: gameSize)
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
        self.directions = Array2D<Directions>(columns:gameSize, rows: gameSize)
        
        self.lines = [LineType:Line]()
        
        numColors = random(minColorCount, max: maxColorCount + 1)

        (gameArray, lines) = generateGameArray()
        
    }

    
    func generateGameArray() -> (Array2D<Point>, [LineType:Line]) {

        let countColors = LineType.LastColor.rawValue - 1
        tempGameArray = Array2D<Point>(columns: gameSize, rows: gameSize)
        tempDirections = Array2D<Directions>(columns: gameSize, rows: gameSize)
      
        for column in 0..<gameSize {  // empty Array generieren
            for row in 0..<gameSize {
                tempGameArray![column, row] = Point(column: column, row: row, type: LineType.Unknown, originalPoint: false, inLinePoint: false, size: gameSize, delegate: checkDirections)
                tempDirections![column, row] = Directions()
            }
        }
        lowCountDirections = Array<(Int, Int)>()
        checkDirections()
        //analyzeGameboard()

        var lines = [LineType:Line]()
        var x1 = 0
        var y1 = 0
        var x2 = 0
        var y2 = 0
        var line: Line
        
        var repeat = false
        

        for ind in 0..<numColors! {
        //for ind in 0..<2 {
            let color = LineType(rawValue: (LineType.Red.rawValue + ind))!
            /*
            if lowCountDirections!.count > 0 {
                (x1, y1) = lowCountDirections![0]
            } else {
                (x1, y1) = getRandomPoint()
            }
            */
            
            if areas[0]!.points.count > 5 {
                (x1, y1) = getRandomPoint()
            } else {
                x1 = areas[0]!.points[0].x
                y1 = areas[0]!.points[0].y
            }
            tempGameArray![x1, y1]!.color = color
            tempGameArray![x1, y1]!.originalPoint = true
            
            
            let line = Line(lineType: color)
            lines[color] = line
            lines[color]!.point1 = Point(column: x1, row: y1, type: color, originalPoint: true, inLinePoint: false, size:gameSize, delegate: checkDirections)
            
            lines[color] = generateLineFromPoint(x1, y: y1, color: color)
            
        }
        return (tempGameArray!, lines)
        
    }
    
    func random(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min)))
    }
    
    func getRandomPoint () -> (Int, Int) {
        var randomSet: [(x:Int, y:Int)]
        randomSet = []
        for x in 0..<gameSize {
            for y in 0..<gameSize {
                if tempGameArray![x, y]!.color == .Unknown {
                    randomSet.append(x: x, y: y)
                }
            }
        }
        return randomSet[random(0, max: randomSet.count)]
    }
    
    func generateLineFromPoint(x: Int, y: Int, color:LineType) -> Line {
        println("arrays:\(areas.count)")
        for ind in 0..<areas.count {
            println("areas[ind].count:\(areas[ind]!.points.count)")
        }
        let line = Line(lineType: color)
        lines[color] = line
        while line.length == 0 {
            let point = Point(column: x, row: y, type: color, originalPoint: true, inLinePoint: false, size:gameSize, delegate: checkDirections)
            lines[color]!.point1 = point
            lines[color]!.addPoint(point)
            println("color: \(color), line.count: \(line.length), aktX: \(x), aktY:\(y)")

            let emptyPointsCount = areas[0]!.points.count  // nehme die 1st area
            
            var otherEmptyPointsCount = 0
            for col in 0..<gameSize {
                for row in 0..<gameSize {
                    if tempGameArray![col, row]!.color == LineType.Unknown {otherEmptyPointsCount++}
                }
            }
            otherEmptyPointsCount -= emptyPointsCount
            var lineLength = 0
            if emptyPointsCount < 6 {
                lineLength = emptyPointsCount
            } else {
                lineLength = random(3, max: emptyPointsCount - (numColors! - lines.count) * 3)
            }
            var aktX: Int = x
            var aktY: Int = y
            
            while line.length < lineLength {
                var randomSet: [(x:Int, y:Int)]
                randomSet = []
                if aktX > 0 && tempGameArray![aktX - 1, aktY]!.color == .Unknown {
                    let setX = aktX - 1
                    let setY = aktY
                    randomSet.append(x: setX, y: setY)
                }
                
                if aktX < gameSize - 1 && tempGameArray![aktX + 1, aktY]!.color == .Unknown {
                    let setX = aktX + 1
                    let setY = aktY
                    randomSet.append(x: setX, y: setY)
                }
                
                if aktY > 0 && tempGameArray![aktX, aktY - 1]!.color == .Unknown {
                    let setX = aktX
                    let setY = aktY - 1
                    randomSet.append(x: setX, y: setY)
                }
                if aktY < gameSize - 1 && tempGameArray![aktX, aktY + 1]!.color == .Unknown {
                    let setX = aktX
                    let setY = aktY + 1
                    randomSet.append(x: setX, y: setY)}
                
                var nextX: Int
                var nextY: Int
                
                (aktX, aktY) = randomSet[random(0, max: randomSet.count)]
                tempGameArray![aktX, aktY]!.color = color
                tempGameArray![aktX, aktY]!.inLinePoint = true
                lines[color]!.point2 = Point(column: aktX, row: aktY, type: color, originalPoint: false, inLinePoint: true, size:gameSize, delegate: checkDirections )
                println("color: \(color), line.count: \(line.length), aktX: \(aktX), aktY:\(aktY)")
                line.addPoint(tempGameArray![aktX, aktY]!)
            }
            for ind in 0..<lines[color]!.length {
                lines[color]!.points[ind].originalPoint = false
            }
            
            lines[color]!.point2!.originalPoint = true
            let x2 = lines[color]!.point2!.column
            let y2 = lines[color]!.point2!.row
            lines[color]!.firstPoint().originalPoint = true
            lines[color]!.lastPoint().originalPoint = true
            tempGameArray![x2, x2]!.originalPoint = true
            println("point1: \(lines[color]!.point1), point2: \(lines[color]!.point2)")
            printGameboard()
            for ind in 0..<areas.count {
                if areas[ind]!.points.count < 3 { //zu kurze Area --> line weglöschen!
                    while lines[color]!.points.count > 0 {
                        let x = lines[color]!.lastPoint().column
                        let y = lines[color]!.lastPoint().row
                        tempGameArray![x, y]!.color = .Unknown
                        lines[color]!.removeLastPoint()
                    }
                }
            }
        }
        return lines[color]!
    }
    
    func printGameboard() {
        var lineString = "+"
        for i in 0..<gameSize {lineString += "---+"}
        println (lineString)
        for y in 0..<gameSize {
            var printString = "| "
            for x in 0..<gameSize {
                var p: String
                switch tempGameArray![x, y]!.color {
                    case .Unknown: p = "\(tempGameArray![x, y]!.areaNumber)"
                    case .Red: p = "R"
                    case .Green: p = "G"
                    case .Blue: p = "B"
                    case .Magenta: p = "M"
                    case .Yellow: p = "Y"
                    case .Purple: p = "P"
                    case .Orange: p = "O"
                    case .Cyan: p = "C"
                    case .Brown: p = "K"
                    default: p = " "
                }
                if !tempGameArray![x, y]!.originalPoint {p = p.lowercaseString}
                printString += p + " | "
            }
            println("\(printString)")
            println("\(lineString)")
        }
    }
    
    func analyzeGameboard() {
        self.areas = [Int:Area]()
        var area = Area()
        for x in 0..<gameSize {
            for y in 0..<gameSize {
                tempGameArray![x, y]!.areaNumber = -1
            }
        }
        var areaNumber = 0
        for x in 0..<gameSize {
            for y in 0..<gameSize {
                if tempGameArray![x, y]!.color == .Unknown &&
                tempGameArray![x, y]!.areaNumber == -1 {
                    area.points.append(Member(x: x, y: y, checked: false))
                    tempGameArray![x, y]!.areaNumber = areaNumber
                    area.countNotCheckedMembers++
                    while area.countNotCheckedMembers > 0 {
                        for (index, member) in enumerate(area.points) {
                            if !member.checked {
                                let x = member.x
                                let y = member.y
                                if tempGameArray![x, y]!.directions.left > 0 &&
                                    tempGameArray![x - 1, y]!.color == .Unknown &&
                                    tempGameArray![x - 1, y]!.areaNumber == -1 {
                                    
                                    tempGameArray![x - 1, y]!.areaNumber == areaNumber
                                    area.points.append(Member(x: x - 1, y: y, checked: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.right > 0 &&
                                    tempGameArray![x + 1, y]!.color == .Unknown &&
                                    tempGameArray![x + 1, y]!.areaNumber == -1 {
                                        
                                    tempGameArray![x + 1, y]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x + 1, y: y, checked: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.up > 0 &&
                                    tempGameArray![x, y - 1]!.color == .Unknown &&
                                    tempGameArray![x, y - 1]!.areaNumber == -1 {

                                    tempGameArray![x, y - 1]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x, y: y - 1, checked: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.down > 0 &&
                                    tempGameArray![x, y + 1]!.color == .Unknown &&
                                    tempGameArray![x, y + 1]!.areaNumber == -1 {
                                    
                                    tempGameArray![x, y + 1]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x, y: y + 1, checked: false))
                                    area.countNotCheckedMembers++
                                }
                                area.points[index].checked = true
                                area.countNotCheckedMembers--
                                //println("index: \(index), x: \(x), y:\(y), notChecked: \(area.countNotCheckedMembers), areaNumber: \(areaNumber)")
                            }
                        }
                    }
                    self.areas[areaNumber] = area
                    area = Area()
                    areaNumber++
                }
                
            }
        }
    }
    
    func checkDirections() {
        if let point = tempGameArray![0, 0] { 
            var lowCountDir = Array<(Int, Int)>()
            for x in 0..<gameSize {
                for y in 0..<gameSize {
                    var dir = Directions()
                    if tempGameArray![x, y]!.color != .Unknown {
                        tempGameArray![x, y]!.directions = dir
                    } else {
                        if x > 0 {
                            var col = x - 1
                            while col >= 0 && tempGameArray![col, y]!.color == .Unknown {
                                col--
                                dir.left++
                            }
                        }
                        
                        if x < gameSize - 1 {
                            var col = x + 1
                            while col <= gameSize - 1 && tempGameArray![col, y]!.color == .Unknown {
                                col++
                                dir.right++
                            }
                        }
                        
                        if y > 0 {
                            var row = y - 1
                            while row >= 0 && tempGameArray![x, row]!.color == .Unknown {
                                row--
                                dir.up++
                            }
                        }

                        if y < gameSize - 1 {
                            var row = y + 1
                            while row <= gameSize - 1 && tempGameArray![x, row]!.color == .Unknown {
                                row++
                                dir.down++
                            }
                        }
                        dir.count = dir.left + dir.right + dir.up + dir.down
                        dir.countDirections = dir.left > 0 ? 1 : 0
                        dir.countDirections += dir.right > 0 ? 1 : 0
                        dir.countDirections += dir.up > 0 ? 1 : 0
                        dir.countDirections += dir.down > 0 ? 1 : 0
                        if dir.countDirections < 2 {
                            lowCountDir.append(x, y)
                        }
                        tempGameArray![x, y]!.directions = dir
                    }
                }
            }
            self.lowCountDirections = lowCountDir
            analyzeGameboard()
        }
    }
    
}

