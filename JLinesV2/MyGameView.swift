//
//  MyGameView.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 09.03.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class MyGameView: UIView {

    var gameNumber: Int?
    var package: Package?
    var volumeNr: Int?

    //var gameboard: Array2D<Point>?
    var gameboard: GameBoard?
    //var lines: [LineType:Line]?

    var error: String?
    var startPointX: Int?
    var startPointY: Int?
    var aktColor: LineType = .Unknown
    var nextLevel: Bool?
    var alertNotReady: Bool?
    var rectSize: CGFloat?
    //var moveCount: Int = 0
    var parent: UIViewController    //var gameEnded: ()->()?
    var gameEnded: (Bool)->()
    var lastColor = LineType.Unknown
    
    var bgLayer = MyLayer()
    var lineLayers = [LineType:MyLayer]()
    var pointLayer: MyLayer?
    var dataStore: DataStore
    

    init(frame: CGRect, gameNumber: Int, package: Package, volumeNr: Int, parent: UIViewController, gameEnded: (Bool)->()) {
        self.parent = parent
        self.gameEnded = gameEnded
        var gameboard: Array2D<Point>
        var error: String
        var lines: [LineType:Line]
        //gameEnded = {return ()}
        var OK = true
        var numColors = 0
        let maxGameNumber = package.getMaxNumber(volumeNr)
        if gameNumber <= maxGameNumber {
            (OK, numColors, gameboard, error, lines) = package.getGameNew(volumeNr, numberIn: gameNumber - 1)
            if OK {
                self.gameboard = GameBoard(gameArray: gameboard, lines: lines, numColors: numColors)
                //self.gameboard!.gameArray = gameboard
                GlobalVariables.lines = lines
            }
            
        } else {
            
            self.gameboard = GameBoard()
            //self.gameboard!.gameArray = gameboard
            //self.gameboard!.lines = lines
        }
        
        dataStore = DataStore(gameName: package.getVolumeName(volumeNr) as String, gameNumber: gameNumber, countLines: numColors)
        super.init(frame: frame)
        
        bgLayer.frame = CGRect(origin: self.frame.origin, size: self.frame.size)
        bgLayer.backgroundColor = UIColor.whiteColor().CGColor
        bgLayer.color = .Unknown
        bgLayer.name = "background"
        
        self.layer.addSublayer(bgLayer)
        bgLayer.setNeedsDisplay()

        let linesCount = GlobalVariables.lines.count
        for index in 0..<linesCount {
            let color = LineType(rawValue: (LineType.Red.rawValue + index))!
            lineLayers[color] = MyLayer()
            lineLayers[color]!.color = color
            
            lineLayers[color]!.frame = CGRect(origin: self.frame.origin, size: self.frame.size)
            lineLayers[color]!.name = "line"
            self.layer.addSublayer(lineLayers[color])
            lineLayers[color]!.setNeedsDisplay()
        }
        
        

    }
    
    func restart() {
        for index in 0..<GlobalVariables.lines.count
        {
            let color = LineType(rawValue: (LineType.Red.rawValue + index))!
            let line = GlobalVariables.lines[color]!
            while line.points.count > 0 {
                let x = line.lastPoint().column
                let y = line.lastPoint().row
                if line.lastPoint() != line.point1 && line.lastPoint() != line.point2 {
                    gameboard!.gameArray[x, y]!.color = .Unknown
                    gameboard!.gameArray[x, y]!.originalPoint = false
                }
                gameboard!.gameArray[x, y]!.inLinePoint = false
                line.removeLastPoint()
            }
            line.point1!.inLinePoint = false
            line.point2!.inLinePoint = false            
            lineLayers[color]!.setNeedsDisplay()
        }
        GlobalVariables.lineCount = 0
        GlobalVariables.moveCount = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        
        let (OK, x, y) = getXYPositionInGrid(touch.locationInView(self))
        if (OK && (gameboard!.gameArray[x, y]!.originalPoint || gameboard!.gameArray[x, y]!.inLinePoint)) {
            
            startPointX = x
            startPointY = y
            aktColor = gameboard!.gameArray[x, y]!.color
            if aktColor != lastColor {
                lastColor = aktColor
            }
            
            GlobalVariables.lineCount = getEndedLinesCount()
            GlobalVariables.lineCountLabel.text = "\(GlobalVariables.lineCount) / \(GlobalVariables.lines.count) vonal"
            
            pointLayer = MyLayer()
            pointLayer!.name = "point"
            let originX = touch.locationInView(self).x - CGFloat(GlobalVariables.rectSize / 2)
            let originY = touch.locationInView(self).y - CGFloat(GlobalVariables.rectSize / 2)
            pointLayer!.frame = CGRect(origin: self.frame.origin, size: self.frame.size)
            //pointLayer!.frame = CGRect(x: originX, y: originY, width: CGFloat(GlobalVariables.rectSize), height: CGFloat(GlobalVariables.rectSize))
        
            pointLayer!.backgroundColor = UIColor.clearColor().CGColor
            pointLayer!.color = aktColor
            self.layer.addSublayer(pointLayer)
            pointLayer!.setNeedsDisplay()
            
            
            gameboard!.gameArray[x, y]!.inLinePoint = true
            let point = gameboard!.gameArray[x, y]!
            let line = GlobalVariables.lines[aktColor]!
            if line.points.count == 0  { // leer
                line.addPoint(point) // add actuelle Point
            } else {
                deleteEndLine(point, line: line, calledFrom: "touchesBegan")

                line.addPoint(point)
                //setNeedsDisplay()
                //drawGame(self.frame, inBoard: gameboard, lines: lines)
            }
        }
        else {
            startPointX = nil
            startPointY = nil
        }
        lineLayers[aktColor]!.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        let (OK, x, y) = getXYPositionInGrid(touch.locationInView(self))
        if OK && startPointX != nil && startPointY != nil {
            
            let originX = touch.locationInView(self).x - CGFloat(GlobalVariables.rectSize / 2)
            let originY = touch.locationInView(self).y - CGFloat(GlobalVariables.rectSize / 2)
            pointLayer!.setNeedsDisplay()
            
            //pointLayer!.frame.origin.x = originX
            //pointLayer!.frame.origin.y = originY
            
            if x != startPointX || y != startPointY {
                //println("tochesMoved: x:\(x), y:\(y), startPointX: \(startPointX), startPointY: \(startPointY)")
                let point: Point = gameboard!.gameArray[x, y]!
                if !((point.originalPoint && point.color != aktColor) || abs(x - startPointX!) > 1 || abs(y - startPointY!) > 1) {  // can be moved here
                    
                    if point.color != .Unknown && point.color != aktColor  {  // here another line
                        //println("point.color: \(point.color), aktColor: \(aktColor)")
                        point.earlierColor = point.color
                        deleteEndLine(point,line: GlobalVariables.lines[point.color]!, calledFrom: "touchesMoved1")  // delete endpart of line, inclusive point
                    }
                    
                    if x != startPointX && y != startPointY {
                        if !gameboard!.gameArray[x, startPointY!]!.originalPoint {
                            moved(x, y: startPointY!)  // when diagonal, then 2 steps: first left/rigth
                            moved(x, y:y)
                        }
                    } else {
                        moved(x, y: y)
                    }
                    //deleteEndLine(point, line: lines[point.type]!, calledFrom: "touchesMoved2")
                    //pointLayer!.frame.origin.y = originY

                    lineLayers[aktColor]!.setNeedsDisplay()
                    //drawGame(self.frame, inBoard: gameboard, lines: lines)
                    startPointX = x
                    startPointY = y
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        let point = touch.locationInView(self)
        let (OK, x, y) = getXYPositionInGrid(point)
        if OK && startPointX != nil && startPointY != nil {
            pointLayer!.removeFromSuperlayer()
            pointLayer = nil
            GlobalVariables.lineCount = getEndedLinesCount()
            GlobalVariables.moveCount++
            dataStore.update(GlobalVariables.moveCount, countSeconds: GlobalVariables.timeCount)

            if checkIfGameEnded() {
                GlobalVariables.timeAdder = 0
                nextLevel = false
                alertNotReady = true
                //println("Game ended!!!")
                
                var gameEndAlert:UIAlertController?
                var messageTxt = ""
                if GlobalVariables.lineCount == GlobalVariables.lines.count {
                    messageTxt = GlobalVariables.language.getText("congratulations")
                }
                messageTxt += GlobalVariables.language.getText("task solved",par:"\(GlobalVariables.lineCount)", "\(GlobalVariables.timeCount)")

                gameEndAlert = UIAlertController(title: GlobalVariables.language.getText("task completed"),
                    message: messageTxt,
                    preferredStyle: .Alert)
                
                let firstAction = UIAlertAction(title: GlobalVariables.language.getText("next level"),
                    style: UIAlertActionStyle.Default,
                    handler: {(paramAction:UIAlertAction!) in
                        self.gameEnded(true)
                    }
                )
                
                let secondAction = UIAlertAction(title: GlobalVariables.language.getText("Stop"),
                    style: UIAlertActionStyle.Cancel,
                    handler: {(paramAction:UIAlertAction!) in
                        //self.gameEnded()
                    }
                    
                )
                
                gameEndAlert!.addAction(firstAction)
                gameEndAlert!.addAction(secondAction)
                /*
                self.presentViewController(gameEndAlert!,
                    animated: true,
                    completion: nil)
                */
                parent.presentViewController(gameEndAlert!,
                    animated:true,
                    completion: nil)
            }
        }
    }
    
    func getXYPositionInGrid(point:CGPoint) -> (Bool, Int, Int) {
        GlobalVariables.touchPoint = point
        let xPos = point.x - bounds.origin.x
        let yPos = point.y - bounds.origin.y
        
        
        
        if xPos < 0 || xPos > bounds.size.width || yPos < 0 || yPos > bounds.size.height {return (false, 0, 0)}
        let x = Int(xPos / CGFloat(GlobalVariables.rectSize))
        let y = Int(yPos / CGFloat(GlobalVariables.rectSize))
        //println("xPos: \(xPos), x: \(x), yPos: \(yPos), y: \(y)")
        if x < GlobalVariables.gameSize && y < GlobalVariables.gameSize {return (true, x, y)}
        return (false, 0, 0)
    }
    
    
    func deleteEndLine(aktPoint: Point, line: Line, calledFrom: String) {
        //println("deleteEndLine: caller: \(calledFrom), pColor: \(aktPoint.type), lColor: \(line.lineType), aktColor: \(aktColor!)")
        let point = (aktPoint.originalPoint && aktPoint != line.firstPoint()) ? line.firstPoint() : aktPoint
        while line.points.count != 0 && line.lastPoint() != point {
            let tempX = line.lastPoint().column
            let tempY = line.lastPoint().row
            if !gameboard!.gameArray[tempX, tempY]!.originalPoint {gameboard!.gameArray[tempX, tempY]!.color = .Unknown}
            gameboard!.gameArray[tempX, tempY]!.inLinePoint = false
            line.removeLastPoint()
        }
        gameboard!.gameArray[line.lastPoint().column, line.lastPoint().row]?.inLinePoint = false
        line.removeLastPoint()
    }
    
    func moved(x: Int, y:Int) {
        //println("moved: x: \(x), y: \(y), index: \(x * gameSize + y)")
        let point = gameboard!.gameArray[x, y]!
        
        if GlobalVariables.lines[aktColor]!.pointInLine(point) {
            deleteEndLine(point, line: GlobalVariables.lines[aktColor]!, calledFrom: "moved")
        }
        if !GlobalVariables.lines[aktColor]!.lineEnded {
            gameboard!.gameArray[x, y]!.color = aktColor
            gameboard!.gameArray[x, y]!.inLinePoint = true
            GlobalVariables.lines[aktColor]!.addPoint(gameboard!.gameArray[x, y]!)
            lineLayers[aktColor]!.setNeedsDisplay()
        }
    }
    
    func checkIfGameEnded () -> Bool {
        for column in 0..<GlobalVariables.gameSize {
            for row in 0..<GlobalVariables.gameSize {
                if gameboard!.gameArray[column, row]!.color == .Unknown {return false}
            }
        }
        for (color, line) in GlobalVariables.lines {
            if !line.lineEnded {return false}
        }
        return true
    }
    
    func getEndedLinesCount() -> Int{
        var count = 0
        for index in 0..<GlobalVariables.lines.count {
            count += GlobalVariables.lines[LineType(rawValue: (LineType.Red.rawValue + index))!]!.lineEnded ? 1 : 0

        }
       //println("aktColor: \(aktColor), count:\(count)")
        return count
    }

}
