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
struct GlobalVariables {
    static var touchPoint = CGPointZero
    static var gameSize = 5
    static var gameNr = 0
    static var maxGameNr = 0
    static var lineCount: Int = 0 {
        didSet {
            let lineString = GlobalVariables.language.getText("lines")
            GlobalVariables.lineCountLabel.text = "\(GlobalVariables.lineCount) / \(GlobalVariables.lines.count) \(lineString))"
        }
    }
    
    static var moveCount: Int = 0 {
        didSet {
            let step = GlobalVariables.language.getText("steps")
            let target = GlobalVariables.language.getText("target")
            GlobalVariables.moveCountLabel.text = "\(GlobalVariables.moveCount) \(step) / \(GlobalVariables.lines.count) \(target)"
        }
    }
    static var rectSize: CGFloat = 0
    static var lines = [LineType:Line]()
    static let multiplicator:CGFloat = 0.90
    static var timeAdder = 1
    static let language = Language()
    static var timeCount: Int = 0
    
    
    // globale Labels
    
    static let moveCountLabel = UILabel()
    static let lineCountLabel = UILabel()
    
}



class Game: UIView, Printable {
    let multiplicator:CGFloat = 0.90
    
    //var gameboard: Array2D <Point>?
    //var lines: [LineType:Line]
    //var error: String
    //var maxNumber: Int
    var number: Int
    var volumeNr: Int
    //var gameSize: Int
    var firstPoint: CGPoint?
    var vBounds: CGRect?
    //var rectSize: CGFloat?
    //var startPointX: Int?
    //var startPointY: Int?
    //var aktColor: LineType?
     //var moveCount: Int
    var parent: PagedViewController
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
    var timeLeft: Int = 30
    let timeLeftOrig = 30
    var timerLabel      = UILabel()
    var gameNumber      = UILabel()
    let forwardButton   = UIButton()
    let backwardButton  = UIButton()
    let repeatButton    = UIButton()
    let settingsButton  = UIButton()
    let backButton      = UIButton()
    var settingsViewController: UIViewController?


    init (frame: CGRect, package: Package, volumeNr: Int, number: Int, parent: PagedViewController) {
        self.number = number
        //(gameboard, error, lines) = package.getGameNew(volumeNr, numberIn: number - 1)
        self.number = number
        GlobalVariables.maxGameNr = package.getMaxNumber(volumeNr)
        self.volumeNr = volumeNr
        self.package = package
        self.volumeNr = volumeNr
        GlobalVariables.gameSize = package.getGameSize(volumeNr)
        //moveCount = 0
        self.parent = parent
        
        GlobalVariables.gameNr = number
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
        self.hidden = false
        let size = frame.size
        let origin = frame.origin
        
        vSize = CGSize(width: size.width * multiplicator, height: size.width * multiplicator)
        vOrigin = CGPoint(  x: origin.x + (size.width - vSize!.width) / 2,
                            y: origin.y + (size.height - vSize!.height) / 3)
        
        
        vBounds = CGRect(origin: vOrigin!, size: vSize!)
        
        gameContainer = UIView(frame: CGRect(origin: vOrigin!, size: vSize!))
        gameContainer!.backgroundColor = UIColor.clearColor()
        
        firstGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: vSize!), gameNumber: self.number, package: package, volumeNr: volumeNr, parent: parent, gameEnded: nextAction)
        firstGameView!.backgroundColor = UIColor.clearColor()

        self.addSubview(gameContainer!)
        gameContainer!.addSubview(firstGameView!)
        //gameContainer.addSubview(secondGameView)
        
        
        
        let linksPfeil = UIImage(named: "pfeillinks.jpg") as UIImage?
        let rechtsPfeil = UIImage(named: "pfeilrechts.jpg") as UIImage?
        let repeatPfeil = UIImage(named: "repeat.jpg") as UIImage?
        let settingsBild = UIImage(named: "settings.jpg") as UIImage?
        forwardButton.setImage(rechtsPfeil, forState: .Normal)
        backwardButton.setImage(linksPfeil, forState: .Normal)
        repeatButton.setImage(repeatPfeil, forState: .Normal)
        settingsButton.setImage(settingsBild, forState: .Normal)
        
        let normWert = bounds.size.width * 0.15
        forwardButton.frame = CGRect(x: bounds.size.width - bounds.size.width * 0.1 - normWert, y: vOrigin!.y + vSize!.height * 1.1, width: normWert, height: normWert)
        backwardButton.frame = CGRect(x: bounds.size.width * 0.1, y: vOrigin!.y + vSize!.height * 1.1, width: normWert, height: normWert)
        settingsButton.frame = CGRect(x: bounds.size.width / 3, y: vOrigin!.y + vSize!.height * 1.1, width: normWert, height: normWert)
        repeatButton.frame = CGRect(x: bounds.size.width * 2 / 3 - normWert, y: vOrigin!.y + vSize!.height * 1.1, width: normWert, height: normWert)

        
        forwardButton.backgroundColor = UIColor.whiteColor()
        backwardButton.backgroundColor = UIColor.whiteColor()
        repeatButton.backgroundColor = UIColor.whiteColor()

        //button.setTitle("TestforwardButton", forState: UIControlState.Normal)
        forwardButton.addTarget(self, action: "nextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        backwardButton.addTarget(self, action: "nextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        repeatButton.addTarget(self, action: "repeatButton:", forControlEvents: UIControlEvents.TouchUpInside)
        settingsButton.addTarget(self, action: "settingsButton:", forControlEvents: UIControlEvents.TouchUpInside)

        timerLabel.frame = CGRect(x: bounds.origin.x + bounds.size.width - 50, y: vOrigin!.y - 30, width: 40, height: 20)
        timerLabel.text = "\(timeLeft)"
        timerLabel.backgroundColor = UIColor.whiteColor()
        
        gameNumber.frame = CGRect(x: bounds.origin.x + bounds.size.width / 2 - 40, y: vOrigin!.y - 70, width: 200, height: 20)
        gameNumber.text =  GlobalVariables.language.getText("gameNumber",par: "\(GlobalVariables.gameNr)")//"Játék sorszáma: \(GlobalVariables.gameNr)"
        
        GlobalVariables.lineCountLabel.frame = CGRect(x: bounds.origin.x + 10, y: vOrigin!.y - 30, width: 100, height: 20)        
        GlobalVariables.moveCountLabel.frame = CGRect(x: bounds.origin.x + bounds.size.width / 2 - 40, y: vOrigin!.y - 30, width: 150, height: 20)
        GlobalVariables.lineCount = 0
        GlobalVariables.moveCount = 0

        backwardButton.hidden = true
        self.addSubview(forwardButton)
        self.addSubview(backwardButton)
        self.addSubview(repeatButton)
        self.addSubview(settingsButton)
        self.addSubview(timerLabel)
        self.addSubview(gameNumber)
        self.addSubview(GlobalVariables.lineCountLabel)
        self.addSubview(GlobalVariables.moveCountLabel)

        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)


    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func countDown () {
        timeLeft -= GlobalVariables.timeAdder
        GlobalVariables.timeCount += GlobalVariables.timeAdder
        timerLabel.text = "\(timeLeft)"
        if timeLeft == 0 {
            GlobalVariables.timeAdder = 0
            var timeEndAlert:UIAlertController?
            var messageTxt = GlobalVariables.language.getText("restart")
            timeEndAlert = UIAlertController(title: GlobalVariables.language.getText("timeout"),
                message: messageTxt,
                preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {(paramAction:UIAlertAction!) in
                    self.firstGameView!.restart()
                    self.timeLeft = self.timeLeftOrig
                    GlobalVariables.timeCount = 0
                    GlobalVariables.timeAdder = 1
                }
            )
            
            
            GlobalVariables.lineCount = 0
            timeEndAlert!.addAction(OKAction)
            parent.presentViewController(timeEndAlert!,
                animated:true,
                completion: nil)

        }
        
    }
    
    func repeatButton(sender:UIButton)
    {
        firstGameView!.restart()
        timeLeft = timeLeftOrig
        GlobalVariables.timeCount = 0
    }

    func settingsButton(sender:UIButton)
    {
//        GlobalVariables.timeAdder = 0
//        parent.performSegueWithIdentifier("segueToSettings", sender:self)
        settingsViewController = SettingsViewController(callBack: continueAfterSetting)
        parent.presentViewController(settingsViewController!, animated: true, completion: {
            
        })
    }
    

    func continueAfterSetting () {
    }

    func nextButton(sender:UIButton)
    {
        let forwards = sender.frame.origin.x > self.bounds.size.width / 2
        nextAction(forwards)
        timeLeft = timeLeftOrig
        GlobalVariables.timeCount = 0
    }
    
    func nextAction(forwards: Bool) {
        var adder = forwards ? 1 : -1
        if adder == -1 && number == 1 {adder = 0}
        //if adder == 1 && number == maxNumber {adder = 0}
        
        //println("adder: \(adder), number: \(number)")

        if GlobalVariables.gameNr > 0 {backwardButton.hidden = false}
        if GlobalVariables.gameNr == GlobalVariables.maxGameNr - 1 {
            forwardButton.hidden = true
        }
        
        //println("maxGameNr:\(GlobalVariables.maxGameNr)")
        var transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        
        if forwards {
            transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
        }
        
        if adder != 0 {
            UIView.transitionWithView(self.gameContainer!, duration: 0.5, options: transitionOptions, animations: {
                self.firstGameView!.removeFromSuperview()
                self.firstGameView = nil
                self.number += adder
                self.firstGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: self.vSize!), gameNumber: self.number, package: self.package!, volumeNr: self.volumeNr, parent: self.parent, gameEnded:self.nextAction )
                self.backgroundColor = UIColor.whiteColor()
                self.gameContainer!.addSubview(self.firstGameView!)
                            }, completion: {finisched in})
           timeLeft = timeLeftOrig
            GlobalVariables.timeCount = 0
            GlobalVariables.timeAdder = 1
            GlobalVariables.gameNr += adder
            GlobalVariables.moveCount = 0
            GlobalVariables.lineCount = 0
            gameNumber.text = GlobalVariables.language.getText("gameNumber", par: "\(GlobalVariables.gameNr)")//"Játék sorszáma: \(GlobalVariables.gameNr)"
           // println("sender: \(sender)")
        }
    }
    


}