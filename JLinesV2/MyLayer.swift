//
//  BGView.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 30.03.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class MyLayer: CALayer {
    
    var color: LineType = .Unknown
    
    override init() {
        super.init()
        let dummy = CALayer()
        self.addSublayer(dummy)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeLineForLayer() {
        var previousX = -1
        var previousY = -1
        var previousCoordX: CGFloat = -1.0
        var previousCoordY: CGFloat = -1.0
        var pointX = -1
        var pointY = -1
        var coordX: CGFloat = -1
        var coordY: CGFloat = -1
        var line = GV.lines[color]!
        let correction = GV.gameRectSize / 100
        println("line length: \(line.points.count)")
        if GV.lines[color]!.points.count > 0 {
            for index in 0..<line.points.count {
                
                previousX = pointX
                previousY = pointY
                previousCoordX = coordX
                previousCoordY = coordY
                
                pointX = line.points[index].column
                pointY = line.points[index].row
                
                coordX = frame.origin.x + CGFloat(pointX) * CGFloat(GV.gameRectSize) + CGFloat(GV.gameRectSize / 2.25) - correction * CGFloat(pointX)
                coordY = frame.origin.y + CGFloat(pointY) * CGFloat(GV.gameRectSize) + CGFloat(GV.gameRectSize / 2.25) - correction * CGFloat(pointY)
                println("gameRectSize: \(GV.gameRectSize), x: \(pointX), y: \(pointY), coordX: \(coordX), coordY: \(coordY)")
                
                var layer = line.points[index].layer
                let radius:CGFloat = GV.gameRectSize * 0.12
                if index > 0 {
                    println("layer.name: \(layer.name)")
                    if layer.name == nil && previousX >= 0  {
                        layer.name = "Layer-\(pointX)-\(pointY)"
                        layer.backgroundColor = color.uiColor.CGColor
                        layer.hidden = false
                        layer.frame.origin.x = min(previousCoordX, coordX) - radius / 2.25
                        layer.frame.origin.y = min(previousCoordY, coordY) - radius / 2.25
                        println("previousX: \(previousX), x: \(pointX), previousY: \(previousY), y: \(pointY), index: \(index), layer.name: \(layer.name) jetzt generiert\n================\n")
                        if pointX != previousX || pointY != previousY {  // only when something changed!
                            if previousX == pointX {
                                layer.frame.size.width = radius * 2
                                layer.frame.size.height = GV.gameRectSize + 2 * radius
                            } else {
                                layer.frame.size.height = radius * 2
                                layer.frame.size.width = GV.gameRectSize + 2 * radius
                            }
                            layer.cornerRadius = radius
                            self.addSublayer(layer)
                        }
                    }
                }
                
            }
        }
        println("self.sublayers.count: \(self.sublayers.count)")
        if color != .Unknown && self.sublayers.count > line.points.count {
            
        }
        if color != .Unknown && self.sublayers.count < line.points.count {
            
        }
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawInContext(ctx: CGContext!) {
        //GV.gameRectSize = self.bounds.width / CGFloat(GV.gameSize)
        var rectSize = GV.gameRectSize
        var iRectSize = Int(rectSize)
        let endAngle = CGFloat(2*M_PI)
        let oneGrad:CGFloat = CGFloat(M_PI) / 180
        //GV.gameRectSize = rectSize
        //println("name: \(self.name)")
        if name == "background" {
            CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
            CGContextSetLineWidth(ctx, 4.0)
            CGContextStrokeRect(ctx, self.bounds)
            CGContextSetLineWidth(ctx, 0.8)
            CGContextBeginPath(ctx)
             
            for ind in 1..<GV.gameSize {
                CGContextMoveToPoint(ctx, CGFloat(Int(bounds.origin.x) + ind * Int(rectSize)), bounds.origin.y)
                CGContextAddLineToPoint(ctx, CGFloat(Int(bounds.origin.x) + ind * Int(rectSize)), bounds.origin.y + bounds.size.height)
                CGContextMoveToPoint(ctx, CGFloat(bounds.origin.x), CGFloat(ind * Int(rectSize) + Int(bounds.origin.y)))
                CGContextAddLineToPoint(ctx, CGFloat(bounds.origin.x + bounds.size.width), CGFloat(ind * Int(rectSize) + Int(bounds.origin.y)))
            }
            CGContextStrokePath(ctx)
        }

        if self.name == "point" {
            //println("touchPointX: \(GV.touchPoint.x), touchPoointY: \(GV.touchPoint.y)")
            self.opacity = 0.20
            let rad = CGFloat(rectSize / 1.5)
            let xCent: CGFloat = CGFloat(GV.touchPoint.x)
            let yCent: CGFloat = CGFloat(GV.touchPoint.y)
           
            CGContextAddArc(ctx, xCent, yCent, rad, 0, endAngle, 1)
            CGContextSetFillColorWithColor(ctx, color.uiColor.CGColor)
            CGContextSetStrokeColorWithColor(ctx,color.uiColor.CGColor)
            CGContextDrawPath(ctx, kCGPathFillStroke)

        }
        
        if self.name == "line" {
            let rad:CGFloat = (rectSize * GV.multiplicator * 0.8) / 2
            
            let colortype = GV.lines[color]
            //println("line:\(GV.lines[color]!.color), length: \(GV.lines[color]!.points.count)")
            
            let xPos1 = GV.lines[color]!.point1!.column * iRectSize
            let yPos1 = GV.lines[color]!.point1!.row * iRectSize
            
            let xCent1: CGFloat = CGFloat(self.bounds.origin.x) + CGFloat(xPos1) + CGFloat(rectSize) / CGFloat(2)
            let yCent1: CGFloat = CGFloat(self.bounds.origin.y) + CGFloat(yPos1) + CGFloat(rectSize) / CGFloat(2)
            CGContextAddArc(ctx, xCent1, yCent1, rad, 0, endAngle, 1)
            CGContextSetFillColorWithColor(ctx, color.uiColor.CGColor)
            CGContextSetStrokeColorWithColor(ctx,color.uiColor.CGColor)
            CGContextDrawPath(ctx, kCGPathFillStroke);
            
            let xPos2 = GV.lines[color]!.point2!.column * iRectSize
            let yPos2 = GV.lines[color]!.point2!.row * iRectSize
            let xCent2: CGFloat = CGFloat(self.bounds.origin.x) + CGFloat(xPos2) + CGFloat(rectSize) / CGFloat(2)
            var yCent2: CGFloat = CGFloat(self.bounds.origin.y) + CGFloat(yPos2) + CGFloat(rectSize) / CGFloat(2)
            CGContextAddArc(ctx, xCent2, yCent2, rad, 0, endAngle, 1)
            
            CGContextSetFillColorWithColor(ctx, color.uiColor.CGColor)
            CGContextSetStrokeColorWithColor(ctx,color.uiColor.CGColor)
            CGContextDrawPath(ctx, kCGPathFillStroke);
            
            var lineWidth: CGFloat = 0.0

            if GV.lines[color]!.lineEnded {
                
                lineWidth = CGFloat(GV.gameRectSize)
                
                CGContextSetLineWidth(ctx, lineWidth)
                if GV.lines[color]!.points.count > 0 {
                    for index in 0..<GV.lines[color]!.points.count {
                        
                        CGContextSetStrokeColorWithColor(ctx, color.uiColor.colorWithAlphaComponent(0.10).CGColor)
                        
                        let pointX = GV.lines[color]!.points[index].column
                        let pointY = GV.lines[color]!.points[index].row
                        //println ("pointX:\(pointX), pointY: \(pointY)")
                        let coordX = self.bounds.origin.x + (CGFloat(pointX) * rectSize) + rectSize / 2
                        let coordY = self.bounds.origin.y + (CGFloat(pointY) * rectSize) + rectSize / 2
                        let size = rectSize / 64
                        //if GV.lines[color]!.point1 == GV.lines[color]!.points[index] {
                            //println("bounds.width: \(self.bounds.width), color: \(color.colorName), coordX: \(coordX), coordY: \(coordY), width: \(size), heigth: \(size)")
                            CGContextStrokeRect(ctx, CGRect(x: coordX, y: coordY, width: size, height: size))
                        //}
                    }
                    //CGContextStrokePath(ctx)
                    
                }
            }
/*
            lineWidth = rad * 0.8
            
            CGContextSetLineWidth(ctx, lineWidth)
            let constant: CGFloat = 1 / 4
            let edgeRad = GV.gameRectSize * constant
            var pointX = -1
            var pointY = -1
            var oldPointX = -1
            var oldPointY = -1
            var center = CGPoint(x: 0,y: 0)
            //println("color: \(color)")
            if GV.lines[color]!.points.count > 0 {
                for index in 0..<GV.lines[color]!.points.count {
                            //println("color: \(color), count of points: \(line.points.count) \n")
                    
                    CGContextSetStrokeColorWithColor(ctx, color.uiColor.CGColor)
                    oldPointX = pointX
                    oldPointY = pointY
                    pointX = GV.lines[color]!.points[index].column
                    pointY = GV.lines[color]!.points[index].row
                    let edge = GV.lines[color]!.points[index].edge
                    //println ("pointX:\(pointX), pointY: \(pointY)")
                    let coordX = bounds.origin.x + CGFloat(pointX) * CGFloat(GV.gameRectSize) + CGFloat(GV.gameRectSize / 2)
                    let coordY = bounds.origin.y + CGFloat(pointY) * CGFloat(GV.gameRectSize) + CGFloat(GV.gameRectSize / 2)
                    if index == 0 {
                        CGContextMoveToPoint(ctx,coordX, coordY)
                    } else {
                        if edge == Edge.None {
                            CGContextAddLineToPoint(ctx, coordX, coordY)
                        } else {
                            if edge == .LeftUp {
                                if oldPointX == pointX {  // line comming from up
                                    CGContextAddLineToPoint(ctx, coordX, coordY - GV.gameRectSize * constant)
                                } else {
                                    CGContextAddLineToPoint(ctx, coordX - GV.gameRectSize * constant, coordY)
                                }
                                CGContextStrokePath(ctx)
                                center = CGPoint(x: coordX - GV.gameRectSize * constant, y: coordY - GV.gameRectSize * constant)
                                CGContextAddArc(ctx, center.x, center.y, edgeRad, oneGrad * 90, oneGrad * 360, 1)
                                if oldPointX == pointX { // line goes to left
                                    CGContextMoveToPoint(ctx,coordX - GV.gameRectSize * constant, coordY)
                                } else {
                                    CGContextMoveToPoint(ctx,coordX, coordY - GV.gameRectSize * constant)
                                }
                            }
                            if edge == .RightUp {
                                if oldPointX == pointX {  // line comming from up
                                    CGContextAddLineToPoint(ctx, coordX, coordY - GV.gameRectSize * constant)
                                } else {
                                    CGContextAddLineToPoint(ctx, coordX + GV.gameRectSize * constant, coordY)
                                }
                                CGContextStrokePath(ctx)
                                center = CGPoint(x: coordX + GV.gameRectSize * constant, y: coordY - GV.gameRectSize * constant)
                                CGContextAddArc(ctx, center.x, center.y, edgeRad, oneGrad * 180, oneGrad * 90, 1)
                                if oldPointX == pointX { // line goes to left
                                    CGContextMoveToPoint(ctx,coordX + GV.gameRectSize * constant, coordY)
                                } else {
                                    CGContextMoveToPoint(ctx,coordX, coordY - GV.gameRectSize * constant)
                                }
                            }
                            if edge == .LeftDown {
                                if oldPointX == pointX {  // line comming from up
                                    CGContextAddLineToPoint(ctx, coordX, coordY + GV.gameRectSize * constant)
                                } else {
                                    CGContextAddLineToPoint(ctx, coordX - GV.gameRectSize * constant, coordY)
                                }
                                CGContextStrokePath(ctx)
                                center = CGPoint(x: coordX - GV.gameRectSize * constant, y: coordY + GV.gameRectSize * constant)
                                CGContextAddArc(ctx, center.x, center.y, edgeRad, oneGrad * 365, oneGrad * 265, 1)
                                if oldPointX == pointX { // line goes to left
                                    CGContextMoveToPoint(ctx,coordX - GV.gameRectSize * constant, coordY)
                                } else {
                                    CGContextMoveToPoint(ctx,coordX, coordY + GV.gameRectSize * constant)
                                }
                            }
                            if edge == .RightDown {
                                if oldPointX == pointX {  // line comming from up
                                    CGContextAddLineToPoint(ctx, coordX, coordY + GV.gameRectSize * constant)
                                } else {
                                    CGContextAddLineToPoint(ctx, coordX + GV.gameRectSize * constant, coordY)
                                }
                                CGContextStrokePath(ctx)
                                center = CGPoint(x: coordX + GV.gameRectSize * constant, y: coordY + GV.gameRectSize * constant)
                                CGContextAddArc(ctx, center.x, center.y, edgeRad, oneGrad * 275, oneGrad * 175, 1)
                                if oldPointX == pointX { // line goes to left
                                    CGContextMoveToPoint(ctx,coordX + GV.gameRectSize * constant, coordY)
                                } else {
                                    CGContextMoveToPoint(ctx,coordX, coordY + GV.gameRectSize * constant)
                                }
                            }
                        }
                        
                    }

                }
                CGContextStrokePath(ctx)

            }
*/
        }
        
    }


}
