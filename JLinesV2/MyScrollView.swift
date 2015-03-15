//
//  MyScrollView.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 22.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class MyScrollView: UIScrollView, UIScrollViewDelegate {

    var TableNumColumns: Int?
    var TableNumRows: Int?
    var vBounds: CGRect?
    var page: Int?
    var package: Package?
    var parent: PagedViewController?
    var game: Game?
/*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
*/    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touchCount = touches.count
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        let (number, volumeNr) = convertLocationInViewToNum(point)
        let firstPage = CGRect(origin: CGPointZero, size: bounds.size)
        game = Game(frame: firstPage, package:package!, volumeNr: volumeNr, number: number, parent: parent!)
        //parent!.callSegue(game!)
        
        //self.addSubview(game!)
        parent!.view.addSubview(game!)
        self.hidden = true
        game!.backgroundColor = .whiteColor()
        //self.addSubview(game)

    }
    
    
    
    func convertLocationInViewToNum(point: CGPoint) -> (Int, Int) {
        
        let pointX = point.x % self.bounds.size.width
        let volumeNr = Int(point.x / self.bounds.size.width)
        let pointY = point.y + (self.bounds.origin.y - vBounds!.origin.y)
        
        let rectSizeX = vBounds!.size.width / CGFloat(TableNumColumns!)
        let rectSizeY = Int(vBounds!.size.height / CGFloat(TableNumRows!))

        let column = Int(pointX / rectSizeX)
        let row    = Int(pointY / CGFloat(rectSizeY))
        let number = Int(TableNumColumns! * row + column + 1)
        //println("pointX: \(pointX), pointY: \(pointY), rectSizeY: \(rectSizeY), column:\(column), row: \(row), number: \(number)")
        return (number, volumeNr)
    }
    
    func gameEnded ()->() {
        let subViews: Array = parent!.view.subviews
        if subviews.count > 1 {
            var subView: AnyObject = subViews[subViews.count - 1]
            subView.removeFromSuperview()
        }
        game = nil
        self.hidden = false
        println("subViews.count: \(subViews.count)")
    }
    

}

