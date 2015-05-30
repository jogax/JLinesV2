//
//  MyStructs.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 18.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit

enum Choosed: Int{
    case Unknown = 0, Right, Left, Settings, Restart
}
enum GameControll: Int {
    case Finger = 0, JoyStick, Accelerometer, PipeLine
}

struct GV {
    static var vBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
    //static var horNormWert: CGFloat = 0 // Geräteabhängige Constante
    //static var vertNormWert: CGFloat = 0 // Geräteabhängige Constante
    static var notificationCenter = NSNotificationCenter.defaultCenter()
    static let notificationGameControllChanged = "gameModusChanged"
    static let notificationMadeMove = "MadeMove"
    static let notificationJoystickMoved = "joystickMoved"
    static let notificationColorChanged = "colorChanged"
    static let accelerometer   = Accelerometer()
    static var aktColor: LineType = .Unknown
    static var speed: CGSize = CGSizeZero
    static var touchPoint = CGPointZero
    static var gameSize = 5
    static var gameNr = 0
    static var gameSizeMultiplier: CGFloat = 1.0
    static var maxGameNr = 0
    static var volumeNr = 0 {
        didSet {
            if oldValue != volumeNr {
                gameSize = package!.getGameSize(volumeNr)
                maxGameNr = package!.getMaxNumber(volumeNr)
            }
        }
    }
    static var maxVolumeNr = 0
    static var lineCount: Int = 0 {
        didSet {
            let lineString = GV.language.getText("lines")
            GV.lineCountLabel.text = "\(GV.lineCount) / \(GV.lines.count) \(lineString)"
        }
    }
    
    static var moveCount: Int = 0 {
        didSet {
            let step = GV.language.getText("steps")
            GV.moveCountLabel.text = "\(GV.moveCount) / \(GV.lines.count) \(step)"
        }
    }
    static var gameControll = GameControll.Finger
    static var joyStickRadius: CGFloat = 0.0
    static var rectSize: CGFloat = 0 // rectSize in Choose Table
    static var gameRectSize: CGFloat = 0 // rectSize in gameboard
    static var lines = [LineType:Line]()
    static let multiplicator:CGFloat = 0.90
    static var timeAdder = 1
    static let language = Language()
    static var timeCount: Int = 0
    static let TableNumColumns = 5
    static let TableNumRows = 6
    static var aktPage = 0
    
    static let scrollViewName = "ScrollView"
    static let dataStore = DataStore()
    //static let cloudData = CloudData()
    static var package: Package?
    static let volumeName: [Int:String] = [0:"5 x 5", 1:"6 x 6", 2:"7 x 7", 3:"8 x 8", 4:"9 x 9"]
    static let volumeNumber: [String:Int] = ["5 x 5":0, "6 x 6":1, "7 x 7":2, "8 x 8":3, "9 x 9":4]
    static var gameData = MyGames()
    static var appData = AppData()
    static var sublayer = CALayer()
    static let images = DrawImages()
    
    // Colors
    static let lightSalmonColor     = UIColor(red: 255/255, green: 160/255, blue: 122/255, alpha: 1)
    static let darkTurquoiseColor   = UIColor(red: 0/255,   green: 206/255, blue: 209/255, alpha: 1)
    static let turquoiseColor       = UIColor(red: 64/255,  green: 224/255, blue: 208/255, alpha: 1)
    static let darkBlueColor        = UIColor(red: 0/255,   green: 0/255,   blue: 139/255, alpha: 1)
    static let springGreenColor     = UIColor(red: 0/255,   green: 255/255, blue: 127/255, alpha: 1)
    static let khakiColor           = UIColor(red: 240/255, green: 230/255, blue: 140/255, alpha: 1)
    static let PaleGoldenrodColor   = UIColor(red: 238/255, green: 232/255, blue: 170/255, alpha: 1)
    static let PeachPuffColor       = UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1)
    static let SilverColor          = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
    static let BlackColor           = UIColor(red: 0/255,   green: 0/255,   blue: 0/255,    alpha: 1)
    
   
    
    // globale Labels
    
    static let moveCountLabel = UILabel()
    static let lineCountLabel = UILabel()
    
    
    // Constraints
    static let myDevice = MyDevice()
    
}

struct GameData {
    var gameName: String
    var gameNumber: Int
    var countLines: Int
    var countMoves: Int {
        didSet {
            var color: CGColor
            if countMoves > 0 {
                switch countMoves {
                    case countLines:    color = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.2).CGColor
                    case countLines + 1 ... countLines + 10:
                                        color = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.2).CGColor
                    default:            color = UIColor.clearColor().CGColor
                }
                layer.backgroundColor = color
                layer.setNeedsDisplay()
            }
        }
    }

    
    var countSeconds: Int
    var timeStemp: NSDate
    var layer: CALayer
    
    init() {
        gameName = ""
        gameNumber = 0
        countLines = 0
        countMoves = 0
        countSeconds = 0
        timeStemp = NSDate()
        layer = CALayer()
    }
    init(name: String, number: Int) {
        gameName = name
        gameNumber = number
        countLines = 0
        countMoves = 0
        countSeconds = 0
        timeStemp = NSDate()
        layer = CALayer()
    }
}
struct VolumeData {
    var volume: String
    var games = [GameData]()
    
    init(volumeIndex: Int) {
        volume = GV.package!.getVolumeName(volumeIndex) as String
        for ind in 0..<GV.TableNumRows * GV.TableNumColumns {
            games.append(GameData(name: volume, number: ind))
        }
        
    }

}


struct MyGames {
    var volumes = [VolumeData]()
    
    init() {
        for volumeIndex in 0..<GV.maxVolumeNr {
            volumes.append(VolumeData(volumeIndex: volumeIndex))
        }
    }
}

struct AppData {
    var gameControll: Int64

    init() {
        gameControll = Int64(GameControll.Finger.rawValue)
    }
}

