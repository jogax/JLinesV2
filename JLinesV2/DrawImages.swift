//
//  DrawImages.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 30.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit

class DrawImages {
    var pfeillinks = UIImage()
    var pfeilrechts = UIImage()
    var settings = UIImage()
    var restart = UIImage()
    init() {
        self.pfeillinks = drawPfeillinks(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.pfeilrechts = pfeillinks.imageRotatedByDegrees(180.0, flip: false)
        self.settings = drawSettings(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.restart = drawRestart(CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    func drawPfeillinks(frame: CGRect) -> UIImage {
        let opaque = false
        let scale: CGFloat = 1
        let size = CGSize(width: frame.width, height: frame.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        
        CGContextSetLineWidth(ctx, 4.0)
        CGContextBeginPath(ctx)
        
        let adder:CGFloat = 10.0
        let p1 = CGPoint(x: frame.origin.x + adder, y: frame.height / 2)
        let p2 = CGPoint(x: frame.origin.x + adder + frame.width / 4,   y: frame.origin.y + frame.height / 4)
        let p3 = CGPoint(x: frame.origin.x + adder + frame.width / 4,   y: frame.origin.y + frame.height / 2.5)
        let p4 = CGPoint(x: frame.origin.x - adder + frame.width,       y: frame.origin.y + frame.height / 2.5)
        let p5 = CGPoint(x: frame.origin.x - adder + frame.width,       y: frame.height   - frame.height / 2.5)
        let p6 = CGPoint(x: frame.origin.x + adder + frame.width / 4,   y: frame.height   - frame.height / 2.5)
        let p7 = CGPoint(x: frame.origin.x + adder + frame.width / 4,   y: frame.height   - frame.height / 4)
        CGContextMoveToPoint(ctx, p1.x, p1.y)
        CGContextAddLineToPoint(ctx, p2.x, p2.y)
        CGContextAddLineToPoint(ctx, p3.x, p3.y)
        CGContextAddLineToPoint(ctx, p4.x, p4.y)
        CGContextAddLineToPoint(ctx, p5.x, p5.y)
        CGContextAddLineToPoint(ctx, p6.x, p6.y)
        CGContextAddLineToPoint(ctx, p7.x, p7.y)
        CGContextAddLineToPoint(ctx, p1.x, p1.y)
        //CGContextSetAlpha(ctx, 0)
        CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0, 1)
        CGContextStrokePath(ctx)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }

    func drawRestart(frame: CGRect) -> UIImage {
        let opaque = false
        let scale: CGFloat = 1
        let size = CGSize(width: frame.width, height: frame.height)
        let endAngle = CGFloat(2*M_PI)
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(ctx, 4.0)
        CGContextBeginPath(ctx)
        
        let adder:CGFloat = frame.width / 20
        let r0 = frame.width * 0.5
        
        let center1 = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + adder + r0 * 1.10)
        let center2 = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height - adder - r0 * 1.30)
        
        
        let oneGrad:CGFloat = CGFloat(M_PI) / 180
        let minAngle1 = 330 * oneGrad
        let maxAngle1 = 210 * oneGrad
        println("1 Grad: \(oneGrad)")
        
        let minAngle2 = 150 * oneGrad
        let maxAngle2 = 30 * oneGrad
        
        CGContextAddArc(ctx, center1.x, center1.y, r0, minAngle1, maxAngle1, 1)
        CGContextStrokePath(ctx)
        
        CGContextAddArc(ctx, center2.x, center2.y, r0, minAngle2, maxAngle2, 1)
        CGContextStrokePath(ctx)
 
        let p1 = pointOfCircle(r0, center: center1, angle: minAngle1)
        let p2 = CGPoint(x: p1.x - 30, y: p1.y - 70)
        let p3 = CGPoint(x: p1.x - 30, y: p1.y - 10)
        let p4 = pointOfCircle(r0, center: center2, angle: minAngle2)
        let p5 = CGPoint(x: p4.x + 20, y: p4.y + 30)
        let p6 = CGPoint(x: p4.x + 30, y: p4.y + 15)
       
        CGContextMoveToPoint(ctx, p1.x, p1.y)
        CGContextAddLineToPoint(ctx, p2.x, p2.y)
        CGContextStrokePath(ctx)
        CGContextMoveToPoint(ctx, p1.x, p1.y)
        CGContextAddLineToPoint(ctx, p3.x, p3.y)
        CGContextStrokePath(ctx)
        CGContextMoveToPoint(ctx, p4.x, p4.y)
        CGContextAddLineToPoint(ctx, p5.x, p5.y)
        CGContextStrokePath(ctx)
        CGContextMoveToPoint(ctx, p4.x, p4.y)
        CGContextAddLineToPoint(ctx, p6.x, p6.y)
        CGContextStrokePath(ctx)
        
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }

    func drawSettings(frame: CGRect) -> UIImage {
        let opaque = false
        let scale: CGFloat = 1
        let size = CGSize(width: frame.width, height: frame.height)
        let endAngle = CGFloat(2*M_PI)

        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(ctx, 3.0)
        CGContextBeginPath(ctx)
        
        let adder:CGFloat = 10.0
        let center = CGPoint(x: frame.origin.x + frame.width / 2, y: frame.origin.y + frame.height / 2)
        let r0 = frame.width / 2.2 - adder
        let r1 = frame.width / 3.0 - adder
        let r2 = frame.width / 4.0 - adder
        let count: CGFloat = 8
        let countx2 = count * 2
        let firstAngle = (endAngle / countx2) / 2

        CGContextSetFillColorWithColor(ctx,
            UIColor.whiteColor().CGColor)

        //CGContextSetRGBFillColor(ctx, UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).CGColor);
        for ind in 0..<Int(count) {
            let minAngle1 = firstAngle + CGFloat(ind) * endAngle / count
            let maxAngle1 = minAngle1 + endAngle / countx2
            let minAngle2 = maxAngle1
            let maxAngle2 = minAngle2 + endAngle / countx2
            
            
            let startP = pointOfCircle(r1, center: center, angle: maxAngle1)
            let midP1 = pointOfCircle(r0, center: center, angle: maxAngle1)
            let midP2 = pointOfCircle(r0, center: center, angle: maxAngle2)
            let endP = pointOfCircle(r1, center: center, angle: maxAngle2)
            CGContextAddArc(ctx, center.x, center.y, r0, max(minAngle1, maxAngle1) , min(minAngle1, maxAngle1), 1)
            CGContextStrokePath(ctx)
            CGContextMoveToPoint(ctx, startP.x, startP.y)
            CGContextAddLineToPoint(ctx, midP1.x, midP1.y)
            CGContextStrokePath(ctx)
            CGContextAddArc(ctx, center.x, center.y, r1, max(minAngle2, maxAngle2), min(minAngle2, maxAngle2), 1)
            CGContextStrokePath(ctx)
            CGContextMoveToPoint(ctx, midP2.x, midP2.y)
            CGContextAddLineToPoint(ctx, endP.x, endP.y)
            CGContextStrokePath(ctx)
        }
        CGContextFillPath(ctx)
        
        CGContextAddArc(ctx, center.x, center.y, r2, 0, endAngle, 1)
        CGContextStrokePath(ctx)
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }

    func getPfeillinks () -> UIImage {
        return pfeillinks
    }
    
    func getPfeilrechts () -> UIImage {
        return pfeilrechts
    }
    
    func getSettings () -> UIImage {
        return settings
    }
    
    func getRestart () -> UIImage {
        return restart
    }

    func pointOfCircle(radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
        let pointOfCircle = CGPoint (x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        return pointOfCircle
    }

}
