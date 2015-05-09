//
//  LineGame.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 12.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit




class Game: UIView, Printable {
    let multiplicator:CGFloat = 0.90
    
    let countdown = false
    var firstPoint: CGPoint?
    var vBounds = CGRect()
    var parent: PagedViewController
    var package: Package?
    var vOrigin = CGPoint()
    var vSize = CGSize()
    var forwardPfeilRect: CGRect?
    var backwardPfeilRect: CGRect?
    var firstGameView: MyGameView?
    var secondGameView: MyGameView?
    var timeLeft: Int = 30
    let timeLeftOrig = 30
    var gameContainer   = UIView()
    var timerLabel      = UILabel()
    var gameNumber      = UILabel()
    let forwardButton   = UIButton()
    let backwardButton  = UIButton()
    let repeatButton    = UIButton()
    let settingsButton  = UIButton()
    let backButton      = UIButton()
    var settingsViewController: UIViewController?
    var timer: NSTimer?
    var gameNrPar = ""


    init (frame: CGRect, package: Package, parent: PagedViewController) {
        self.package = package
        self.parent = parent
        var device = UIDevice.currentDevice()					//Get the device object
        
        super.init(frame: frame)
        self.backgroundColor = GV.lightSalmonColor
        self.hidden = false
        let size = frame.size
        let origin = frame.origin

        device.beginGeneratingDeviceOrientationNotifications()			//Tell it to start monitoring the accelerometer for orientation
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "orientationChanged:",
            name: UIDeviceOrientationDidChangeNotification,
            object: nil)
        
        
        //gameContainer = UIView()
        gameContainer.backgroundColor = GV.lightSalmonColor
        gameContainer.layer.name = "gameContainer"
        self.addSubview(gameContainer)
        //gameContainer.frame = CGRect(x: 0,y: 0,width: 200,height: 200)
        //gameContainer.addSubview(secondGameView)
        
        self.addSubview(forwardButton)
        self.addSubview(backwardButton)
        self.addSubview(repeatButton)
        self.addSubview(settingsButton)
        self.addSubview(backButton)
        self.addSubview(timerLabel)
        self.addSubview(gameNumber)
        self.addSubview(GV.lineCountLabel)
        self.addSubview(GV.moveCountLabel)
        
        setupLayout()
        setNeedsLayout()
        setNeedsUpdateConstraints()
        
        vSize = gameContainer.frame.size
        vOrigin = gameContainer.frame.origin
        vBounds = CGRect(origin: vOrigin, size: vSize)
        //vOrigin = CGPoint(  x: GV.horNormWert,
        //                    y: GV.vertNormWert * 8)
        
        
        //firstGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: vSize), package: package, parent: parent, gameEnded: nextAction)
        firstGameView = MyGameView(frame:vBounds, package: package, parent: parent, gameEnded: nextAction)
        firstGameView!.backgroundColor = GV.lightSalmonColor
        
        gameContainer.addSubview(firstGameView!)
        //vSize = CGSize(width: GV.horNormWert * 38, height: GV.horNormWert * 38)
        
        
        
        
        
        //let linksPfeil = UIImage(named: "pfeillinks.jpg") as UIImage?
        //let rechtsPfeil = UIImage(named: "pfeilrechts.jpg") as UIImage?
        //let repeatPfeil = UIImage(named: "repeat.jpg") as UIImage?
        //let settingsBild = UIImage(named: "settings.jpg") as UIImage?
        //let backBild = UIImage(named: "back.jpg") as UIImage?
        
        forwardButton.setImage(GV.images.getPfeilrechts(), forState: .Normal)
        forwardButton.setupDepression()
        forwardButton.layer.name = "forwardButton"
        backwardButton.setImage(GV.images.getPfeillinks(), forState: .Normal)
        backwardButton.setupDepression()
        backwardButton.layer.name = "backwardButton"
        repeatButton.setImage(GV.images.getRestart(), forState: .Normal)
        repeatButton.setupDepression()
        settingsButton.setImage(GV.images.getSettings(), forState: .Normal)
        settingsButton.setupDepression()
        backButton.setImage(GV.images.getBack(), forState: .Normal)
        backButton.setupDepression()
        
        //let buttonSize = GV.horNormWert * 4
        //let lowerButtonsY = GV.vertNormWert * 36

        //forwardButton.frame = CGRect(x: GV.horNormWert * 33, y: lowerButtonsY, width: buttonSize, height: buttonSize)
        //backwardButton.frame = CGRect(x: GV.horNormWert * 4, y: lowerButtonsY, width: buttonSize, height: buttonSize)
        //settingsButton.frame = CGRect(x: GV.horNormWert * 14, y: lowerButtonsY, width: buttonSize, height: buttonSize)
        //repeatButton.frame   = CGRect(x: GV.horNormWert * 24, y: lowerButtonsY, width: buttonSize, height: buttonSize)
        //backButton.frame = CGRect(x: GV.horNormWert * 36, y: GV.vertNormWert * 3, width: buttonSize / 3, height: buttonSize / 3)
        //timerLabel.frame = CGRect(x: GV.horNormWert * 36, y: GV.vertNormWert * 6, width: buttonSize, height: GV.horNormWert * 2)
        //GV.lineCountLabel.frame = CGRect(x: GV.horNormWert * 2, y: GV.vertNormWert * 6, width: GV.horNormWert * 14, height: GV.horNormWert * 2)
        //GV.moveCountLabel.frame = CGRect(x: GV.horNormWert * 18, y: GV.vertNormWert * 6, width: GV.horNormWert * 18, height: GV.horNormWert * 2)
        //gameNumber.frame = CGRect(x: GV.horNormWert * 2, y: GV.vertNormWert * 3, width: GV.horNormWert * 30, height: GV.horNormWert * 3)
        
        GV.language.callBackWhenNewLanguage(self.updateLanguage)
        
        forwardButton.backgroundColor = UIColor.clearColor()
        repeatButton.backgroundColor = GV.lightSalmonColor
        backButton.backgroundColor = GV.lightSalmonColor

        forwardButton.addTarget(self, action: "nextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        backwardButton.addTarget(self, action: "nextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        repeatButton.addTarget(self, action: "repeatButton:", forControlEvents: UIControlEvents.TouchUpInside)
        settingsButton.addTarget(self, action: "settingsButton:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: "backButton:", forControlEvents: UIControlEvents.TouchUpInside)

        timerLabel.text = "\(self.timeLeft)"
        if !countdown {
            timerLabel.text = "\(GV.timeCount)"
        }
        timerLabel.backgroundColor = GV.lightSalmonColor
        
        let gameName = GV.package!.getVolumeName(GV.volumeNr)
        gameNrPar = "\(GV.gameNr + 1)  \(gameName)"
        gameNumber.text =  GV.language.getText("gameNumber", par: gameNrPar ) //"Játék sorszáma: \(GV.gameNr)"
        //gameNumber.font = UIFont(name: gameNumber.font.fontName, size: GV.vertNormWert * 1.5)
        
        GV.lineCount = 0
        GV.moveCount = 0

        if GV.volumeNr == 0 && GV.gameNr == 0 {backwardButton.hidden = true}
        if GV.volumeNr == GV.maxVolumeNr - 1 && GV.gameNr == GV.maxGameNr - 1 {
            forwardButton.hidden = true
        }
        GV.timeAdder = 1
        GV.timeCount = 0
        self.timeLeft = self.timeLeftOrig
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
    }
    
    func orientationChanged(notification: NSNotification){
        setupLayout()
    }
    

    func updateLanguage() {
        let step = GV.language.getText("steps")
        let lineString = GV.language.getText("lines")
        
        GV.moveCountLabel.text = "\(GV.moveCount) / \(GV.lines.count) \(step)"
        GV.lineCountLabel.text = "\(GV.lineCount) / \(GV.lines.count) \(lineString)"
        gameNumber.text = GV.language.getText("gameNumber", par: gameNrPar)//"Játék sorszáma: \(GV.gameNr)"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func countDown () {
        if countdown {timeLeft -= GV.timeAdder}
        //println("timeLeft:\(timeLeft), timeAdder: \(GV.timeAdder), gameID: \(self.gameID)")
        GV.timeCount += GV.timeAdder
        if countdown {
            timerLabel.text = "\(self.timeLeft)"
        } else {
            timerLabel.text = "\(GV.timeCount)"
        }
        if self.timeLeft == 0 {
            GV.timeAdder = 0
            var timeEndAlert:UIAlertController?
            var messageTxt = GV.language.getText("restart")
            timeEndAlert = UIAlertController(title: GV.language.getText("timeout"),
                message: messageTxt,
                preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: {(paramAction:UIAlertAction!) in
                    self.firstGameView!.restart()
                    self.timeLeft = self.timeLeftOrig
                    GV.timeCount = 0
                    GV.timeAdder = 1
                }
            )
            
            
            GV.lineCount = 0
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
        GV.timeCount = 0
    }

    func settingsButton(sender:UIButton)
    {
//        GV.timeAdder = 0
//        parent.performSegueWithIdentifier("segueToSettings", sender:self)
        settingsViewController = SettingsViewController(callBack: continueAfterSetting)
        parent.presentViewController(settingsViewController!, animated: true, completion: {
            
        })
    }
    
    func backButton (sender: UIButton) {
        self.removeFromSuperview()
        for ind in 0..<parent.view.subviews.count {
            //println("subview: \(ind) -> \((parent.view.subviews[ind] as! UIView).layer.name)")
            timeLeft = timeLeftOrig
            GV.timeAdder = 0
            GV.timeCount = 0
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            if let name = (parent.view.subviews[ind]  as! UIView).layer.name {
                if name == GV.scrollViewName {
                    (parent.view.subviews[ind] as! UIView).hidden = false     // auswahl wieder anzeige
                    parent.updateLayers()
                    for pageNr in 0..<GV.maxVolumeNr {
                        parent.makeLayers(pageNr)
                    }
                    GV.gameRectSize = 0
                }
            }
        }
    }
    
    func continueAfterSetting () {
    }

    func nextButton(sender:UIButton)
    {
        let forwards = sender.frame.origin.x > self.bounds.size.width / 2
        nextAction(forwards)
        timeLeft = timeLeftOrig
        GV.timeCount = 0
    }
    
    func nextAction(forwards: Bool) {
        
        for ind in 0..<self.subviews.count {
            println("ind: \(ind), viewName:\(self.subviews[ind].layer.name), frame: \(self.subviews[ind].layer.frame)")
            
        }
        var adder = forwards ? 1 : -1
        if (adder == -1 && GV.gameNr == 0 && GV.volumeNr == 0) || (adder == 1 && GV.gameNr == GV.maxGameNr - 1 && GV.volumeNr == GV.maxVolumeNr - 1) {
            adder = 0
        }
        
        
        //println("maxGameNr:\(GV.maxGameNr)")
        var transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        
        if forwards {
            transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
        }
        
        
        
        if adder != 0 {
            UIView.transitionWithView(gameContainer, duration: 0.5, options: transitionOptions, animations: {
                self.firstGameView!.removeFromSuperview()
                self.firstGameView = nil
                GV.gameNr += adder
                //self.number += adder
                if GV.gameNr > GV.maxGameNr - 1 {
                    if GV.volumeNr < GV.maxVolumeNr - 1 {
                        GV.gameNr = 0
                        GV.volumeNr++
                        GV.gameRectSize = 0
                    }
                }
                
                if GV.gameNr == GV.maxGameNr - 1 && GV.volumeNr == GV.maxVolumeNr - 1 {
                    self.forwardButton.hidden = true
                }
                if GV.gameNr < 0 {
                    if GV.volumeNr > 0 {
                        GV.volumeNr--
                        GV.gameNr = GV.maxGameNr - 1
                        GV.gameRectSize = 0
                    }
                }
                self.vSize = self.gameContainer.frame.size
                self.firstGameView = MyGameView(frame:CGRect(origin: CGPointZero, size: self.vSize), package: self.package!, parent: self.parent, gameEnded:self.nextAction )
                self.backgroundColor = GV.lightSalmonColor
                self.gameContainer.addSubview(self.firstGameView!)
            }, completion: {finisched in})
            
            //println("GV.gameNr: \(GV.gameNr), GV.maxGameNr: \(GV.maxGameNr), GV.volumeNr: \(GV.volumeNr), GV.maxVolumeNr: \(GV.maxVolumeNr)")
            let hideBackwardButton = GV.gameNr == 0 && GV.volumeNr == 0
            let hideForwardButton = GV.gameNr >= GV.maxGameNr - 1  && GV.volumeNr == GV.maxVolumeNr - 1
            backwardButton.hidden = hideBackwardButton
            forwardButton.hidden = hideForwardButton
            //forwardButton.setNeedsDisplay()
            //backwardButton.setNeedsDisplay()

            timeLeft = timeLeftOrig
            GV.timeCount = 0
            GV.timeAdder = 1
            GV.moveCount = 0
            GV.lineCount = 0
            let gameName = GV.package!.getVolumeName(GV.volumeNr)
            gameNrPar  = "\(GV.gameNr + 1)  \(gameName)"
            gameNumber.text = GV.language.getText("gameNumber", par: gameNrPar)//"Játék sorszáma: \(GV.gameNr)"
           // println("sender: \(sender)")
        }
    }

    func setupLayout() {
        var constraintsArray = Array<NSObject>()
        var portrait = false
        switch UIDevice.currentDevice().orientation {
            case .Portrait, .PortraitUpsideDown, .FaceUp, .FaceDown:
                portrait = true
            default:
                portrait = false
        }
        
        
        
        timerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        gameNumber.setTranslatesAutoresizingMaskIntoConstraints(false)
        forwardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backwardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        repeatButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        gameContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        GV.lineCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        GV.moveCountLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // backButton
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: portrait ? -20.0 : -40))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: portrait ? 20.0 :20))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 10.0))

        // settingsButton
        constraintsArray.append(NSLayoutConstraint(item: settingsButton, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: settingsButton, attribute: .Top, relatedBy: .Equal, toItem: gameContainer, attribute: .Bottom, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: settingsButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: settingsButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
        
        // repeatButton
        constraintsArray.append(NSLayoutConstraint(item: repeatButton, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: repeatButton, attribute: .Top, relatedBy: .Equal, toItem: gameContainer, attribute: .Bottom, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: repeatButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: repeatButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
        
        //backwardButton

        constraintsArray.append(NSLayoutConstraint(item: backwardButton, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: settingsButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backwardButton, attribute: .Top, relatedBy: .Equal, toItem: gameContainer, attribute: .Bottom, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backwardButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: backwardButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:
            1.0, constant: 40.0))
        
        //forwardButton
        
        constraintsArray.append(NSLayoutConstraint(item: forwardButton, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -60.0))
        
        constraintsArray.append(NSLayoutConstraint(item: forwardButton, attribute: .Top, relatedBy: .Equal, toItem: gameContainer, attribute: .Bottom, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: forwardButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: forwardButton, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:
            1.0, constant: 40.0))
        
        //timerLabel
        
        constraintsArray.append(NSLayoutConstraint(item: timerLabel, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: timerLabel, attribute: .Bottom, relatedBy: .Equal, toItem: gameContainer, attribute: .Top, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: timerLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50.0))
        
        constraintsArray.append(NSLayoutConstraint(item: timerLabel, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:
            1.0, constant: 30.0))
        
        //gameNumber
        
        constraintsArray.append(NSLayoutConstraint(item: gameNumber, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameNumber, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 25.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameNumber, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 280.0))
        
        constraintsArray.append(NSLayoutConstraint(item: gameNumber, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:
            1.0, constant: 30.0))
        
        //GV.lineCountLabel
        
        constraintsArray.append(NSLayoutConstraint(item: GV.lineCountLabel, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: GV.lineCountLabel, attribute: .Bottom, relatedBy: .Equal, toItem: gameContainer, attribute: .Top, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: GV.lineCountLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 150.0))
        
        constraintsArray.append(NSLayoutConstraint(item: GV.lineCountLabel, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:
            1.0, constant: 30.0))
        
        //GV.moveCountLabel
        
        constraintsArray.append(NSLayoutConstraint(item: GV.moveCountLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 40.0))
        
        constraintsArray.append(NSLayoutConstraint(item: GV.moveCountLabel, attribute: .Bottom, relatedBy: .Equal, toItem: gameContainer, attribute: .Top, multiplier: 1.0, constant: -10.0))
        
        constraintsArray.append(NSLayoutConstraint(item: GV.moveCountLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 150.0))
        
        constraintsArray.append(NSLayoutConstraint(item: GV.moveCountLabel, attribute: .Height , relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:
            1.0, constant: 30.0))
        
        //gameContainer
        
        if portrait {
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10))
            
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 110.0))
            
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: -20.0))
            
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: .Height , relatedBy: .Equal, toItem: gameContainer, attribute: .Width, multiplier:
                1.0, constant: 0))
        } else {
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10))
            
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 10))
            
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: -20.0))
            
            constraintsArray.append(NSLayoutConstraint(item: gameContainer, attribute: .Height , relatedBy: .Equal, toItem: gameContainer, attribute: .Width, multiplier:
            1.0, constant: 0))
    }
    
        self.addConstraints(constraintsArray)
    }

}