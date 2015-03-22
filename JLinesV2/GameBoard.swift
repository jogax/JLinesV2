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
    var endPoint: Bool
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
        var hasEndPoints: Bool
        var countEndPoints: Int
        var countNotCheckedMembers: Int
        
        init () {
            points = Array<Member>()
            countNotCheckedMembers = 0
            hasEndPoints = false
            countEndPoints = 0
        }
    }

    
    var gameArray: Array2D<Point>
    //var directions: Array2D<Directions>
    var tempGameArray: Array2D<Point>?
    //var tempDirections: Array2D<Directions>?
    var lowCountDirections: Array<(Int, Int)>?
    var lines: [LineType:Line]
    var gameSize: Int = 0
    var numColors: Int = 0
    var countMoves: Int = 0
    var areas = [Int:Area]()
    var areaNr = 0
    
    
    init (gameArray: Array2D<Point>, lines: [LineType:Line], gameSize: Int, numColors: Int) {
        
        self.gameSize = gameSize
        self.numColors = numColors
        self.gameArray = gameArray
        self.lines = lines
        //self.directions = Array2D<Directions>(columns:gameSize, rows: gameSize)
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
        //self.directions = Array2D<Directions>(columns:gameSize, rows: gameSize)
        
        self.lines = [LineType:Line]()
        
        numColors = random(minColorCount, max: maxColorCount)

        (gameArray, lines) = generateGameArray()
        
    }

    
    func generateGameArray() -> (Array2D<Point>, [LineType:Line]) {

        //let countColors = LineType.LastColor.rawValue - 1
        tempGameArray = Array2D<Point>(columns: gameSize, rows: gameSize)
        //tempDirections = Array2D<Directions>(columns: gameSize, rows: gameSize)
      
        for column in 0..<gameSize {  // empty Array generieren
            for row in 0..<gameSize {
                tempGameArray![column, row] = Point(column: column, row: row, type: LineType.Unknown, originalPoint: false, inLinePoint: false, size: gameSize, delegate: checkDirections)
                //tempDirections![column, row] = Directions()
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
        
        //var repeat = false
        

        for ind in 0..<self.numColors {
        //for ind in 0..<2 {
            let color = LineType(rawValue: (LineType.Red.rawValue + ind))!
            
            
            (x1, y1) = getRandomPoint()
            
            tempGameArray![x1, y1]!.color = color
            tempGameArray![x1, y1]!.originalPoint = true
            
            /*
            let line = Line(lineType: color)
            lines[color] = line
            lines[color]!.point1 = Point(column: x1, row: y1, type: color, originalPoint: true, inLinePoint: false, size:gameSize, delegate: checkDirections)
            */
            lines[color] = generateLineFromPoint(x1, y: y1, color: color)
            
        }
        return (tempGameArray!, lines)
        
    }
    
    func random(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max + 1 - min)))
    }
    
    func getRandomPoint () -> (Int, Int) {
        var randomSet: [(x:Int, y:Int)]
        randomSet = []
        

        var area = areas[self.areaNr]!
        for (index, member) in enumerate(area.points) {
            if !area.hasEndPoints || area.points[index].endPoint {
                let x = area.points[index].x
                let y = area.points[index].y
                randomSet.append(x: x, y: y)
            }

        }
        return randomSet[random(0, max: randomSet.count - 1)]
    }
    
    func generateLineFromPoint(x: Int, y: Int, color:LineType) -> Line {
        println("arrays:\(areas.count)")
        for ind in 0..<areas.count {
            println("areas[ind].count:\(areas[ind]!.points.count)")
        }
        let line = Line(lineType: color)
        let left = 0
        let up = 1
        let right = 2
        let down = 3
        
        var leftUpRightDown = random(left, max: down)
        
        while line.length < 3 {
            let point = Point(column: x, row: y, type: color, originalPoint: true, inLinePoint: true, size:gameSize, delegate: checkDirections)
            line.point1 = point
            line.point2 = point
            line.addPoint(point)
            println("color: \(color), line.count: \(line.length), aktX: \(x), aktY:\(y)")

            let emptyPointsCount = areas[areaNr]!.points.count  // nehme die 1st area
            
            var allEmptyPointsCount = 0
            var otherEmptyPointsCount = 0
            for col in 0..<gameSize {
                for row in 0..<gameSize {
                    if tempGameArray![col, row]!.color == LineType.Unknown {allEmptyPointsCount++}
                }
            }
            otherEmptyPointsCount = allEmptyPointsCount - emptyPointsCount
            
            var lineLength = 0
            var restLinesCount = numColors - self.lines.count
            var areasCount = areas.count
            
            if emptyPointsCount < 6 || restLinesCount == 1 || areasCount == restLinesCount {
                lineLength = emptyPointsCount + 1
            } else {
                if emptyPointsCount >  9 {
                    lineLength = random(3, max: emptyPointsCount - (restLinesCount - areasCount) * 3)
                } else {
                    lineLength = 3
                }
            }
            var aktX: Int = x
            var aktY: Int = y
            
            while line.length < lineLength {
                var randomSet: [(x:Int, y:Int)]
                randomSet = []
                var cnt = 0
                while randomSet.count == 0 || cnt > 3 {
                    switch leftUpRightDown {
                    case left:
                        if aktX > 0 && tempGameArray![aktX - 1, aktY]!.color == .Unknown {
                            let setX = aktX - 1
                            let setY = aktY
                            randomSet.append(x: setX, y: setY)
                        }
                    case up:
                        if aktX < gameSize - 1 && tempGameArray![aktX + 1, aktY]!.color == .Unknown {
                            let setX = aktX + 1
                            let setY = aktY
                            randomSet.append(x: setX, y: setY)
                        }
                    case right:
                        if aktY > 0 && tempGameArray![aktX, aktY - 1]!.color == .Unknown {
                            let setX = aktX
                            let setY = aktY - 1
                            randomSet.append(x: setX, y: setY)
                        }
                    default:
                        if aktY < gameSize - 1 && tempGameArray![aktX, aktY + 1]!.color == .Unknown {
                            let setX = aktX
                            let setY = aktY + 1
                            randomSet.append(x: setX, y: setY)}
                    }
                    if randomSet.count == 0 {
                        if ++leftUpRightDown > down {leftUpRightDown = 0}
                        cnt++
                    }
                }
                
                
                if randomSet.count == 0 {
                    lineLength = line.length
                } else {
                    (aktX, aktY) = randomSet[random(0, max: randomSet.count - 1)]
                    tempGameArray![aktX, aktY]!.color = color
                    tempGameArray![aktX, aktY]!.inLinePoint = true
                    line.point2 = Point(column: aktX, row: aktY, type: color, originalPoint: false, inLinePoint: true, size:gameSize, delegate: checkDirections )
                    println("color: \(color), line.count: \(line.length), aktX: \(aktX), aktY:\(aktY)")
                    line.addPoint(tempGameArray![aktX, aktY]!)
                }
            }
            for ind in 0..<line.length {
                line.points[ind].originalPoint = false
            }
            
            line.point2!.originalPoint = true
            let x2 = line.point2!.column
            let y2 = line.point2!.row
            line.firstPoint().originalPoint = true
            line.lastPoint().originalPoint = true
            tempGameArray![x2, x2]!.originalPoint = true
            println("point1: \(line.point1), point2: \(line.point2)")
            //printGameboard()
            for ind in 0..<areas.count {
                if areas[ind]!.points.count < 3 || areas[ind]!.countEndPoints == 3  {//> 2 && areas[ind]!.points.count < 6) { //zu kurze Area or zu viele EndPoints --> line weglöschen!
                    while line.points.count > 2 {
                        let x = line.lastPoint().column
                        let y = line.lastPoint().row
                        tempGameArray![x, y]!.color = .Unknown
                        line.removeLastPoint()
                        //printGameboard()
                    }
                }
            }
        }
        
        lines[color] = line

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
        var minAreaLength = 1000
        for x in 0..<gameSize {
            for y in 0..<gameSize {
                if tempGameArray![x, y]!.color == .Unknown &&
                tempGameArray![x, y]!.areaNumber == -1 {
                    area.points.append(Member(x: x, y: y, checked: false, endPoint: false))
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
                                    
                                    tempGameArray![x - 1, y]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x - 1, y: y, checked: false, endPoint: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.right > 0 &&
                                    tempGameArray![x + 1, y]!.color == .Unknown &&
                                    tempGameArray![x + 1, y]!.areaNumber == -1 {
                                        
                                    tempGameArray![x + 1, y]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x + 1, y: y, checked: false, endPoint: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.up > 0 &&
                                    tempGameArray![x, y - 1]!.color == .Unknown &&
                                    tempGameArray![x, y - 1]!.areaNumber == -1 {

                                    tempGameArray![x, y - 1]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x, y: y - 1, checked: false, endPoint: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.down > 0 &&
                                    tempGameArray![x, y + 1]!.color == .Unknown &&
                                    tempGameArray![x, y + 1]!.areaNumber == -1 {
                                    
                                    tempGameArray![x, y + 1]!.areaNumber = areaNumber
                                    area.points.append(Member(x: x, y: y + 1, checked: false, endPoint: false))
                                    area.countNotCheckedMembers++
                                }
                                if tempGameArray![x, y]!.directions.countDirections == 1 {
                                    area.hasEndPoints = true
                                    area.countEndPoints++
                                    area.points[index].endPoint = true
                                }
                                area.points[index].checked = true
                                area.countNotCheckedMembers--
                                //println("index: \(index), x: \(x), y:\(y), notChecked: \(area.countNotCheckedMembers), areaNumber: \(areaNumber)")
                            }
                        }
                    }
                    self.areas[areaNumber] = area
                    if minAreaLength > area.points.count {
                        minAreaLength = area.points.count
                        self.areaNr = areaNumber
                    }
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

