//
//  MyButton.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 29.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class MyButton: UIButton {
    var touch = ""
    init() {
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        setupDepression()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).CGColor)
        //CGContextStrokeRect(ctx, self.bounds)
        CGContextSetLineWidth(ctx, 0.1)
        CGContextBeginPath(ctx)
        CGContextStrokeRect(ctx, rect)
        let radius = rect.height / 4
        CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMinY(rect))
        CGContextAddArcToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius)
        CGContextAddArcToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius)
        CGContextAddArcToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius)
        CGContextAddArcToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius)
        if self.touch == "didTouchDown" {
            CGContextSetFillColorWithColor(ctx, UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).CGColor);
        } else {
            CGContextSetFillColorWithColor(ctx, UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).CGColor);
        }
        CGContextFillPath(ctx);
        
        
        CGContextStrokePath(ctx)
    }
    
    
    
}

///An extension to allow a depressing animation when touched down
extension MyButton {
    override func setupDepression() {
        addTarget(self, action: "didTouchDown:", forControlEvents: .TouchDown)
        addTarget(self, action: "didTouchDragExit:", forControlEvents: .TouchDragExit)
        addTarget(self, action: "didTouchUp:", forControlEvents: .TouchUpInside)
    }
    
    override func didTouchDown(button:MyButton) {
        self.touch = "didTouchDown"
        UIView.animateWithDuration(0.07){
            self.transform = CGAffineTransformMakeScale(0.98, 0.98)
            self.setNeedsDisplay()
        }
    }
    
    override func didTouchDragExit(button:MyButton) {
        self.touch = "didTouchDragExit"
        UIView.animateWithDuration(0.07){
            self.transform = CGAffineTransformMakeScale(1.01, 1.01)
            self.setNeedsDisplay()
        }
    }
    
    override func didTouchUp(button:MyButton) {
        self.touch = "didTouchUp"
        UIView.animateWithDuration(0.07){
            self.transform = CGAffineTransformMakeScale(1, 1)
            self.setNeedsDisplay()
        }
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let exitExtension: CGFloat = 5
        let outerBounds: CGRect = CGRectInset(self.bounds, -exitExtension, -exitExtension)
        let touchOutside: Bool = !CGRectContainsPoint(outerBounds, touch.locationInView(self))
        if touchOutside {
            let previousTouchInside = CGRectContainsPoint(outerBounds, touch.previousLocationInView(self))
            if previousTouchInside {
                sendActionsForControlEvents(.TouchDragExit)
                return false
            } else {
                sendActionsForControlEvents(.TouchDragOutside)
                return false
            }
        }
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }
    
    override func moveToCenter(rect: CGRect) {
        frame.origin.x = (rect.size.width - frame.size.width) / 2
    }
    
}
