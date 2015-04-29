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
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawInContext(ctx: CGContext!) {
        GV.gameRectSize = self.bounds.width / CGFloat(GV.gameSize)
        var rectSize = GV.gameRectSize
        var iRectSize = Int(rectSize)
        let endAngle = CGFloat(2*M_PI)

        //GV.gameRectSize = rectSize
        //println("name: \(self.name)")
        if name == "background" {
            CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
            CGContextSetLineWidth(ctx, 4.0)
            CGContextStrokeRect(ctx, self.bounds)
            CGContextSetLineWidth(ctx, 0.8)
            CGContextBeginPath(ctx)
            let x1 = bounds.origin.x
            let x2 = rectSize
            
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
            self.opacity = 0.30
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
            var yCent1: CGFloat = CGFloat(self.bounds.origin.y) + CGFloat(yPos1) + CGFloat(rectSize) / CGFloat(2)
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
                        
                        CGContextSetStrokeColorWithColor(ctx, color.uiColor.colorWithAlphaComponent(0.25).CGColor)
                        
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
            } //else {
                lineWidth = rad * 1.2
                
                CGContextSetLineWidth(ctx, lineWidth)

                
                if GV.lines[color]!.points.count > 0 {
                    for index in 0..<GV.lines[color]!.points.count {
                                //println("color: \(color), count of points: \(line.points.count) \n")
                        
                        CGContextSetStrokeColorWithColor(ctx, color.uiColor.CGColor)
                        
                        let pointX = GV.lines[color]!.points[index].column
                        let pointY = GV.lines[color]!.points[index].row
                        //println ("pointX:\(pointX), pointY: \(pointY)")
                        let coordX = bounds.origin.x + CGFloat(pointX) * CGFloat(GV.gameRectSize) + CGFloat(GV.gameRectSize / 2)
                        let coordY = bounds.origin.y + CGFloat(pointY) * CGFloat(GV.gameRectSize) + CGFloat(GV.gameRectSize / 2)
                        
                        if index == 0 {
                            CGContextMoveToPoint(ctx,coordX, coordY)
                        } else {
                            CGContextAddLineToPoint(ctx, coordX, coordY)
                        }

                    }
                    CGContextStrokePath(ctx)

                }
                
            }
        //}
    }


}
