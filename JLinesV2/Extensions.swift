//
//  Extensions.swift
//  JogaxLinesV1
//
//  Created by Jozsef Romhanyi on 03.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    static func loadJSONFromBundle(fileName: String) -> (Dictionary <String, AnyObject>?, NSData?) {
        //if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
        if   let path = NSBundle.mainBundle().pathForResource(fileName,ofType:"json") {

            
            var error: NSError?
            let data: NSData? = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: &error)
            if let data = data {
                
                let dictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                    options:NSJSONReadingOptions(), error: &error)
                
                if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                    return (dictionary,data)
                } else {
                    println("Level file \(fileName) is not valid JSON: \(error!)")
                    return (nil,nil)
                }
            } else {
                println("Could not load level file: \(fileName), error: \(error!)")
            }
        } else {
            println("Could not find level file \(fileName)")
            return (nil,nil)
        }
        return (nil,nil)
    }
    
}


extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    

}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIButton {
    

    func setupDepression() {
        addTarget(self, action: "didTouchDown:", forControlEvents: .TouchDown)
        addTarget(self, action: "didTouchDragExit:", forControlEvents: .TouchDragExit)
        addTarget(self, action: "didTouchUp:", forControlEvents: .TouchUpInside)
    }
    
    func didTouchDown(button:MyButton) {
        UIView.animateWithDuration(0.07){
            self.transform = CGAffineTransformMakeScale(0.98, 0.98)
            self.setNeedsDisplay()
        }
    }
    
    func didTouchDragExit(button:MyButton) {
        UIView.animateWithDuration(0.07){
            self.transform = CGAffineTransformMakeScale(1, 1)
            self.setNeedsDisplay()
        }
    }
    
    func didTouchUp(button:MyButton) {
        UIView.animateWithDuration(0.07){
            self.transform = CGAffineTransformMakeScale(1, 1)
            self.setNeedsDisplay()
        }
    }
    
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
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
    
    func moveToCenter(rect: CGRect) {
        frame.origin.x = (rect.size.width - frame.size.width) / 2
    }
    
}









