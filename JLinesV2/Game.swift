//
//  LineGame.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 12.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit


enum Choosed: Int{
    case Unknown = 0, Right, Left, Settings, Restart
}


class Game: UIView, Printable {
    let multiplicator:CGFloat = 0.90

    //var gameboard: Array2D <Point>?
    //var lines: [LineType:Line]
    //var error: String
    var maxNumber: Int
    var number: Int
    var volumeNr: Int
    var gameSize: Int
    var firstPoint: CGPoint?
    var vBounds: CGRect?
    //var rectSize: CGFloat?
    //var startPointX: Int?
    //var startPointY: Int?
    //var aktColor: LineType?
     //var moveCount: Int
    var parent: UIViewController
    //var nextLevel: Bool?
    //var alertNotReady: Bool?
    var package: Package?
    var vOrigin: CGPoint?
    var vSize: CGSize?
    var forwardPfeilRect: CGRect?
    var backwardPfeilRect: CGRect?
    var firstGameView: MyGameView?
    var secondGameView: MyGameView?
    var gameContainer: UIView?

    init (frame: CGRect, package: Package, volumeNr: Int, number: Int, parent: UIViewController) {
        self.number = number
        //(gameboard, error, lines) = package.getGame(volumeNr, numberIn: number - 1)
        self.number = number
        self.maxNumber = package.getMaxNumber(volumeNr)
        self.volumeNr = volumeNr
        self.package = package
        self.volumeNr = volumeNr
        gameSize = package.getGameSize(volumeNr)
        //moveCount = 0
        self.parent = parent
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
        self.hidden = false
        let size = frame.size
        let origin = frame.origin
        
        vSize = CGSize(width: size.width * multiplicator, height: size.width * multiplicator)
        vOrigin = CGPoint(  x: origin.x + (size.width - vSize!.width) / 2,
                            y: origin.y + (size.height - vSize!.height) / 3)
        
        
        vBounds = CGRect(origin: vOrigin!, size: vSize!)
        //rectSize = vSize!.width / CGFloat(gameSize)
        
        gameContainer = UIView(frame: CGRect(origin: vOrigin!, size: vSize!))
        gameContainer!.backgroundColor = UIColor.blackColor()
        
        firstGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: vSize!), gameSize: gameSize, gameNumber: self.number, package: package, volumeNr: volumeNr, parent: parent, gameEnded: nextAction)
        firstGameView!.backgroundColor = UIColor.blackColor()
        //firstGameView.initialisation(gameSize, gameNumber: self.number++, package: package, volumeNr: volumeNr)
        
        
        //secondGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: vSize!), gameSize: gameSize, gameNumber: self.number++, package: package, volumeNr: volumeNr)
        //secondGameView!.backgroundColor = UIColor.whiteColor()
        //secondGameView.initialisation(gameSize, gameNumber: self.number++, package: package, volumeNr: volumeNr)

        self.addSubview(gameContainer!)
        gameContainer!.addSubview(firstGameView!)
        //gameContainer.addSubview(secondGameView)
        
        
        let forwardButton   = UIButton()
        let backwardButton  = UIButton()
        
        let linksPfeil = UIImage(named: "pfeillinks.png") as UIImage?
        let rechtsPfeil = UIImage(named: "pfeilrechts.png") as UIImage?
        forwardButton.setImage(rechtsPfeil, forState: .Normal)
        backwardButton.setImage(linksPfeil, forState: .Normal)
        
        let normWert = bounds.size.width * 0.15
        forwardButton.frame = CGRect(x: bounds.size.width - bounds.size.width * 0.1 - normWert, y: vOrigin!.y + vSize!.height * 1.1, width: normWert, height: normWert)
        backwardButton.frame = CGRect(x: bounds.size.width * 0.1, y: vOrigin!.y + vSize!.height * 1.1, width: normWert, height: normWert)
        
        
        forwardButton.backgroundColor = UIColor.clearColor()
        backwardButton.backgroundColor = UIColor.clearColor()

        //button.setTitle("TestforwardButton", forState: UIControlState.Normal)
        forwardButton.addTarget(self, action: "nextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        backwardButton.addTarget(self, action: "nextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(forwardButton)
        self.addSubview(backwardButton)


    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func nextButton(sender:UIButton)
    {
        let forwards = sender.frame.origin.x > self.bounds.size.width / 2
        nextAction(forwards)
    }
    
    func nextAction(forwards: Bool) {
        var adder = forwards ? 1 : -1
        if adder == -1 && number == 1 {adder = 0}
        //if adder == 1 && number == maxNumber {adder = 0}
        
        //println("adder: \(adder), number: \(number)")

        var transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        
        if forwards {
            transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
        }
        
        if adder != 0 {
            UIView.transitionWithView(self.gameContainer!, duration: 0.8, options: transitionOptions, animations: {
                self.firstGameView!.removeFromSuperview()
                self.firstGameView = nil
                self.number += adder
                self.firstGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: self.vSize!), gameSize: self.gameSize, gameNumber: self.number, package: self.package!, volumeNr: self.volumeNr, parent: self.parent, gameEnded:self.nextAction)
                self.backgroundColor = UIColor.whiteColor()
                self.gameContainer!.addSubview(self.firstGameView!)
                            }, completion: {finisched in})
            
           // println("sender: \(sender)")
        }
    }
    


}