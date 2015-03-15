//
//  Package.swift
//  JLinesV1
//
//  Created by Jozsef Romhanyi on 11.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit



class Package {
    
    var moves: Int
    var time: Int
    var squereSize: Int
    var gameName: String
    var package: Dictionary<String, AnyObject>?
    var spiele: AnyObject?
    var aktSpiel: AnyObject?
    var packageVolumes: AnyObject?
    var volumeCount: Int
    var volumeName: String?
    var json: JSON?
    
    
    
    
    let BrettSize = 12
    
    init(packageName: String) {
        
        moves = 0
        time = 0
        squereSize = 0
        gameName = ""
        volumeCount = 0



        let (package, data) = Dictionary<String, AnyObject>.loadJSONFromBundle(packageName)
        json = JSON(data: data!)
        
        if let packageName = json!["packageName"].string {
            //println("\(packageName)")
        }
        if json != nil {
            
            volumeCount = (json!["volumeCount"].int)!
            
            packageVolumes = package!["packageVolume"]
        }
    }
    
    func getVolumeCount () -> Int {
        return json!["volumeCount"].int!
    }
    
    func getVolumeName (volumeNumber: Int) -> NSString {
        let gameName = json!["packageVolume"][volumeNumber]["gameName"].string
        return gameName!
    }
    
    func getGameSize (volumeNr: Int) -> Int {
        let gameSize = json!["packageVolume"][volumeNr]["size"].int!
        return gameSize
    }
    
    func getMaxNumber(volumeNr: Int) -> Int {
        var number: Int = 1
        var testWert: Int?
        do {
            testWert = json!["packageVolume"][volumeNr]["games"][number++]["points"][0][0].int
        } while testWert != nil
        return number - 1
    }
    
    func getGame (volumeNr: Int, numberIn: Int) -> (Bool, Int, Array2D<Point>, String, [LineType:Line]) {
        var number = numberIn
        let squereSize = json!["packageVolume"][volumeNr]["size"].int!
        var numColors = 0

        var spielArray =  Array2D<Point>(columns:squereSize, rows: squereSize)
        
        var error = ""
        
        //var lineArray = [Line](count: squereSize, repeatedValue: nil)
        var lines = [LineType:Line]()
        
        let testWert = json!["packageVolume"][volumeNr]["games"][number]["points"][0][0].int
        if testWert == nil {return (false, 0, spielArray, error, lines)}
        for row in 0..<squereSize {
            for column in 0..<squereSize {
                let num = json!["packageVolume"][volumeNr]["games"][number]["points"][row][column].int
                let point = Point(column: column, row: row, type: LineType(rawValue: num!)!, originalPoint: false, inLinePoint: false)
                numColors = max(num!, numColors)
                spielArray[column, row] = point
                if point.color != .Unknown {
                    point.originalPoint = true
                    let color = LineType(rawValue: num!)!
                    if lines[color] == nil {
                        lines[color] = Line(lineType: color)
                        lines[color]!.point1 = point
                        //lines[color]!.firstPoint()
                    } else {
                        lines[color]!.cnt += 1
                        lines[color]!.point2 = point
                    }
                }
            }
            
        }
        for index in 1...lines.count {
            let color = LineType(rawValue: index)!
            if lines[color]!.cnt > 2 {
                if error == "" {
                    error = "The color \(color) \(lines[color]!.cnt) times!"
                } else {
                    error = error + ", \(color) \(lines[color]!.cnt) times!"
                }
            }
        }
        //println("spielArray: \(spielArray)")
        //println("lines: \(lines)")
        return (true, numColors, spielArray, error, lines)
    }
    
}


