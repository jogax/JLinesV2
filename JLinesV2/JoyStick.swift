//
//  JoyStick.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 19.05.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit
import Foundation

enum JoystickDirections: Int {
        case None = 0, Right, Left, Up, Down
}

class JoyStick: UIView {
    var color: UIColor
    var knopf = UIView()
    var shadow = CALayer()
    var speed: CGFloat = 0.0
    var direction = JoystickDirections.None
    var startTouchPoint = CGPoint(x: 0, y: 0)
    var aktTouchPoint = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        color = UIColor.clearColor()
        super.init(frame: frame)
        /*
        */
        //self.hidden = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setJoyStickLayout () {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = GV.joyStickRadius / 1.7
        self.layer.borderWidth = 1.0
        self.backgroundColor = color
        knopf.backgroundColor = UIColor.redColor()
        knopf.frame.size = CGSizeMake(GV.joyStickRadius / 1.2, GV.joyStickRadius / 1.2)
        knopf.center = self.center
        knopf.layer.cornerRadius = GV.joyStickRadius / 2.4
        knopf.hidden = false
        self.addSubview(knopf)
        shadow.shadowColor = UIColor.whiteColor().CGColor
        shadow.shadowOffset = CGSizeMake(5,5)
        shadow.shadowOpacity = 1.0
        shadow.backgroundColor = UIColor.whiteColor().CGColor
        knopf.layer.addSublayer(shadow)
   }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        startTouchPoint = touch.locationInView(self)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        knopf.center = self.center
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        aktTouchPoint = touch.locationInView(self)
        var distanceX = aktTouchPoint.x - startTouchPoint.x
        var distanceY = aktTouchPoint.y - startTouchPoint.y
        distanceX = abs(distanceX) > GV.joyStickRadius / 4 ? distanceX : 0 / 4
        distanceY = abs(distanceY) > GV.joyStickRadius / 4 ? distanceY : 0 / 4
        if abs(distanceX) > abs(distanceY) {
            distanceY = 0
        } else {
            distanceX = 0
        }
        
        if distanceX != 0 || distanceY != 0 {
            direction = abs(distanceX) > abs(distanceY) ?
            distanceX > 0 ? JoystickDirections.Right:JoystickDirections.Left : distanceY > 0 ? JoystickDirections.Down : JoystickDirections.Up
            if direction == .Right || direction == .Left {
                knopf.center.x = GV.joyStickRadius / 4 + distanceX
            } else {
                knopf.center.y = GV.joyStickRadius / 4 + distanceY
            }
        }
    }

}
