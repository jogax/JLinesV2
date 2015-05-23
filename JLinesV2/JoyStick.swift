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
    var color: LineType = .Unknown
    var knopf = UIView()
    var speedX: CGFloat = 0.0
    var speedY: CGFloat = 0.0
    var direction = JoystickDirections.None
    var startTouchPoint = CGPoint(x: 0, y: 0)
    var aktTouchPoint = CGPoint(x: 0, y: 0)
    var timer: NSTimer?
    let speedCorrection: CGFloat = 1

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GV.notificationCenter.addObserver(self, selector: "changeColor", name: GV.notificationColorChanged, object: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setJoyStickLayout () {

        self.layer.borderColor = GV.SilverColor.CGColor
        self.layer.cornerRadius = GV.joyStickRadius / 1.7
        self.layer.borderWidth = 2.8
        self.layer.shadowColor = GV.BlackColor.CGColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSizeMake(GV.joyStickRadius / 12, GV.joyStickRadius / 12)

        self.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.5)
        let knopfSize = CGFloat(Int(GV.joyStickRadius / 1.2))
        
        knopf.frame.size = CGSizeMake(knopfSize, knopfSize)
        
        knopf.center.x = self.bounds.midX
        knopf.center.y = self.bounds.midY
        knopf.layer.cornerRadius = GV.joyStickRadius / 2.4
        knopf.backgroundColor = UIColor.redColor()
        knopf.hidden = false
        
        self.addSubview(knopf)
        
   }
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        startTouchPoint = touch.locationInView(self)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("makeStep"), userInfo: nil, repeats: true)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resetJoystick()
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.first as! UITouch
        aktTouchPoint = touch.locationInView(self)
        var distanceX = (aktTouchPoint.x - startTouchPoint.x) / speedCorrection
        var distanceY = (aktTouchPoint.y - startTouchPoint.y) / speedCorrection
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        //let maxX = self.bounds.midX - knopf.bounds.midX
        //let maxY = self.bounds.midY - knopf.bounds.midY
        if abs(distanceX) > abs(distanceY) {
            distanceY = 0
            y = self.bounds.midY
            x = self.bounds.midX + distanceX
            direction = distanceX > 0 ? .Right : .Left
        } else {
            distanceX = 0
            x = self.bounds.midX
            y = self.bounds.midY + distanceY
            direction = distanceY > 0 ? .Up : .Down
        }
        GV.speed = CGSizeMake(distanceX, distanceY)
        
        knopf.center.x = x
        knopf.center.y = y
    }

    func makeStep () {
        GV.notificationCenter.postNotificationName(GV.notificationJoystickMoved, object: nil)
    }

    func changeColor () {
        self.color = GV.aktColor
        knopf.backgroundColor = color.uiColor
        knopf.setNeedsDisplay()
        resetJoystick()
    }

    func resetJoystick() {
        knopf.center.x = self.bounds.midX
        knopf.center.y = self.bounds.midY
        speedX = 0
        speedY = 0
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }

}
