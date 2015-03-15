//
//  MyGameView.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 09.03.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class MyGameView: UIView {

    var gameSize: Int?
    var gameNumber: Int?
    var package: Package?
    var volumeNr: Int?

    //var gameboard: Array2D<Point>?
    var gameboard: GameBoard?
    //var lines: [LineType:Line]?

    var error: String?
    var startPointX: Int?
    var startPointY: Int?
    var aktColor: LineType?
    var nextLevel: Bool?
    var alertNotReady: Bool?
    var rectSize: CGFloat?
    var moveCount: Int?
    var parent: UIViewController    //var gameEnded: ()->()?
    var gameEnded: (Bool)->()

    init(frame: CGRect, gameSize: Int, gameNumber: Int, package: Package, volumeNr: Int, parent: UIViewController, gameEnded: (Bool)->()) {
        self.gameSize = gameSize
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
            (OK, numColors, gameboard, error, lines) = package.getGame(volumeNr, numberIn: gameNumber - 1)
            if OK {
                self.gameboard = GameBoard(gameArray: gameboard, lines: lines, gameSize: gameSize, numColors: numColors)
                //self.gameboard!.gameArray = gameboard
                self.gameboard!.lines = lines
            }
            
        } else {
            
            self.gameboard = GameBoard(gameSize: gameSize)
            //self.gameboard!.gameArray = gameboard
            //self.gameboard!.lines = lines
        }
        super.init(frame: frame)

    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.anyObject() as UITouch
        
        let (OK, x, y) = getXYPositionInGrid(touch.locationInView(self))
        if (OK && (gameboard!.gameArray[x, y]!.originalPoint || gameboard!.gameArray[x, y]!.inLinePoint)) {
            startPointX = x
            startPointY = y
            aktColor = gameboard!.gameArray[x, y]!.color
            gameboard!.gameArray[x, y]!.inLinePoint = true
            let point = gameboard!.gameArray[x, y]!
            let line = gameboard!.lines[aktColor!]!
            if line.points.count == 0  { // leer
                line.addPoint(point) // add actuelle Point
            } else {
                deleteEndLine(point, line: line, calledFrom: "touchesBegan")
                line.addPoint(point)
                setNeedsDisplay()
                //drawGame(self.frame, inBoard: gameboard, lines: lines)
            }
        }
        else {
            startPointX = nil
            startPointY = nil
        }
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.anyObject() as UITouch
        let (OK, x, y) = getXYPositionInGrid(touch.locationInView(self))
        if OK && startPointX != nil && startPointY != nil {
            if x != startPointX || y != startPointY {
                //println("tochesMoved: x:\(x), y:\(y), startPointX: \(startPointX), startPointY: \(startPointY)")
                let point: Point = gameboard!.gameArray[x, y]!
                if !((point.originalPoint && point.color != aktColor!) || abs(x - startPointX!) > 1 || abs(y - startPointY!) > 1) {  // can be moved here
                    
                    if point.color != .Unknown && point.color != aktColor!  {  // here another line
                        println("point.color: \(point.color), aktColor: \(aktColor!)")
                        point.earlierColor = point.color
                        deleteEndLine(point,line: gameboard!.lines[point.color]!, calledFrom: "touchesMoved1")  // delete endpart of line, inclusive point
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
                    setNeedsDisplay()
                    //drawGame(self.frame, inBoard: gameboard, lines: lines)
                    startPointX = x
                    startPointY = y
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        let (OK, x, y) = getXYPositionInGrid(point)
        if OK && startPointX != nil && startPointY != nil {
            if checkIfGameEnded() {
                nextLevel = false
                alertNotReady = true
                println("Game ended!!!")
                
                var gameEndAlert:UIAlertController?
                
                gameEndAlert = UIAlertController(title: "Level complete!",
                    message: "You have completed the level in \(moveCount) moves",
                    preferredStyle: .Alert)
                
                let firstAction = UIAlertAction(title: "next level",
                    style: UIAlertActionStyle.Default,
                    handler: {(paramAction:UIAlertAction!) in
                        self.gameEnded(true)
                    }
                )
                
                let secondAction = UIAlertAction(title: "Stop",
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
        let xPos = point.x - bounds.origin.x
        let yPos = point.y - bounds.origin.y
        
        //println("xPos: \(xPos), yPos: \(yPos)")
        
        
        if xPos < 0 || xPos > bounds.size.width || yPos < 0 || yPos > bounds.size.height {return (false, 0, 0)}
        let x = Int(xPos / rectSize!)
        let y = Int(yPos / rectSize!)
        return (true, x, y)
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
        
        if gameboard!.lines[aktColor!]!.pointInLine(point) {
            deleteEndLine(point, line: gameboard!.lines[aktColor!]!, calledFrom: "moved")
        }
        if !gameboard!.lines[aktColor!]!.lineEnded {
            gameboard!.gameArray[x, y]!.color = aktColor!
            gameboard!.gameArray[x, y]!.inLinePoint = true
            gameboard!.lines[aktColor!]!.addPoint(gameboard!.gameArray[x, y]!)
            setNeedsDisplay()
            //drawGame(self.frame, inBoard: gameboard, lines: lines)
        }
    }
    
    func checkIfGameEnded () -> Bool {
        for column in 0..<gameSize! {
            for row in 0..<gameSize! {
                if gameboard!.gameArray[column, row]!.color == .Unknown {return false}
            }
        }
        for (color, line) in gameboard!.lines {
            if !line.lineEnded {return false}
        }
        return true
    }
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        //setNeedsDisplay()
        // Setup our context
        //let opaque = false
        //let scale: CGFloat = 0
        //let font = UIFont(name: "Arial", size: 14.0)
        let size = rect.size
        let multiplicator:CGFloat = 0.90
        let origin = rect.origin
        
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 4.0)
        CGContextStrokeRect(context, rect)
        
        CGContextBeginPath(context)
        
        rectSize = rect.width / CGFloat(gameSize!)
        
        let rad:CGFloat = (rectSize! * multiplicator * 0.8) / 2
        let endAngle = CGFloat(2*M_PI)
        
        
        
        CGContextSetLineWidth(context, 2.0)
        
        CGContextSetLineWidth(context, 0.5)
        for ind in 1..<gameSize! {
            CGContextMoveToPoint(context, CGFloat(Int(rect.origin.x) + ind * Int(rectSize!)), rect.origin.y)
            CGContextAddLineToPoint(context, CGFloat(Int(rect.origin.x) + ind * Int(rectSize!)), rect.origin.y + rect.size.height)
            CGContextMoveToPoint(context, CGFloat(rect.origin.x), CGFloat(ind * Int(rectSize!) + Int(rect.origin.y)))
            CGContextAddLineToPoint(context, CGFloat(rect.origin.x + rect.size.width), CGFloat(ind * Int(rectSize!) + Int(rect.origin.y)))
            CGContextStrokePath(context)
        }
        
        
        for column in 0..<gameSize! {
            for row in 0..<gameSize! {
                let colortype = gameboard!.gameArray[column, row]!.color
                if gameboard!.gameArray[column, row]!.color != .Unknown && gameboard!.gameArray[column, row]!.originalPoint {
                    //println("\n row: \(row), cloumn:\(column), originalpoint: \(gameboard[row, column]!.originalPoint) \n")
                    let color = colortype.color
                    let xCent = rect.origin.x + CGFloat(column) * CGFloat(rectSize!) + CGFloat(rectSize!) / CGFloat(2)
                    let yCent = rect.origin.y + CGFloat(row) * CGFloat(rectSize!) + CGFloat(rectSize!) / CGFloat(2)
                    CGContextAddArc(context, xCent, yCent, rad, 0, endAngle, 1)
                    
                    CGContextSetFillColorWithColor(context, color)
                    CGContextSetStrokeColorWithColor(context,color)
                    //CGContextSetLineWidth(context, 4.0)
                    
                    // draw the path
                    CGContextDrawPath(context, kCGPathFillStroke);
                }
            }
        }
        
        let lineWidth = rad * 1.2
        CGContextSetLineWidth(context, lineWidth)
        
        for (color, line) in gameboard!.lines {
            for ind in 0..<line.points.count {
                //println("color: \(color), count of points: \(line.points.count) \n")
                
                CGContextSetStrokeColorWithColor(context, color.color)
                
                let pointX = line.points[ind].column
                let pointY = line.points[ind].row
                
                let coordX = rect.origin.x + CGFloat(pointX) * rectSize! + rectSize! / 2
                let coordY = rect.origin.y + CGFloat(pointY) * rectSize! + rectSize! / 2
                
                if ind == 0 {
                    CGContextMoveToPoint(context,coordX, coordY)
                } else {
                    CGContextAddLineToPoint(context, coordX, coordY)
                }
                
            }
            
            CGContextStrokePath(context)
        }
        
        
        
        
        
    }
    

}
