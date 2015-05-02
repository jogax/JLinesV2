// Playground - noun: a place where people can play

import Foundation

let file = "file.txt"

if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
    let dir = dirs[0] //documents directory
    let path = dir.stringByAppendingPathComponent(file);
    let text = "some text blablabla"
    
    //writing
    text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    
    //reading
    let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
}

import UIKit

class MyCustomView :UIView{
    
    
    //Write your code in drawRect
    override func drawRect(rect: CGRect) {
        var myBezier = UIBezierPath()
        myBezier.moveToPoint(CGPoint(x: 0, y: 0))
        myBezier.addLineToPoint(CGPoint(x: 100, y: 0))
        myBezier.addLineToPoint(CGPoint(x: 50, y: 100))
        myBezier.closePath()
        UIColor.blackColor().setStroke()
        myBezier.stroke()
    }
    
    
}

var view = MyCustomView(frame: CGRectMake(0, 0, 100, 100))
view.backgroundColor = UIColor.whiteColor()