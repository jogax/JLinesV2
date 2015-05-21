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
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setJoyStickLayout () {

        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = GV.joyStickRadius / 1.7
        self.layer.borderWidth = 1.0
        //self.backgroundColor = color

        self.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.5)
        
        knopf.frame.size = CGSizeMake(GV.joyStickRadius / 1.2, GV.joyStickRadius / 1.2)
        
        knopf.center.x = self.bounds.midX
        knopf.center.y = self.bounds.midY
        knopf.layer.cornerRadius = GV.joyStickRadius / 2.4
        knopf.backgroundColor = UIColor.redColor()
        knopf.hidden = false
        
        self.addSubview(knopf)
        
        shadow.shadowColor = UIColor.whiteColor().CGColor
        shadow.shadowOffset = CGSizeMake(5,5)
        shadow.shadowOpacity = 1.0
        shadow.backgroundColor = UIColor.whiteColor().CGColor
        //knopf.layer.addSublayer(shadow)
   }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        startTouchPoint = touch.locationInView(self)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        knopf.center.x = self.bounds.midX
        knopf.center.y = self.bounds.midY
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        aktTouchPoint = touch.locationInView(self)
        var distanceX = (aktTouchPoint.x - startTouchPoint.x) / 10
        var distanceY = (aktTouchPoint.y - startTouchPoint.y) / 10
        //distanceX = abs(distanceX) > GV.joyStickRadius / 100 ? distanceX : 0 / 4
        //distanceY = abs(distanceY) > GV.joyStickRadius / 100 ? distanceY : 0 / 4
        var x: CGFloat = 0
        var y: CGFloat = 0
        //let maxX = self.bounds.midX - knopf.bounds.midX
        //let maxY = self.bounds.midY - knopf.bounds.midY
        if abs(distanceX) > abs(distanceY) {
            distanceY = 0
            y = self.bounds.midY
            x = self.bounds.midX + distanceX
        } else {
            distanceX = 0
            x = self.bounds.midX
            y = self.bounds.midY + distanceY
        }
        //x = x - knopf.bounds.midX < self.bounds.minX ? self.bounds.minX : x
        //x = x - knopf.bounds.midX > self.bounds.maxX ? self.bounds.maxX : x
        
        knopf.center.x = x
        knopf.center.y = y
    }

}
