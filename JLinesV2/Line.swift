//
//  Line.swift
//  PointCrunch
//
//  Created by Jozsef Romhanyi on 26.01.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit

enum LineType: Int, Printable {
    case Unknown = 0, Red, Green, Blue, Magenta, Yellow, Purple, Orange, Cyan, Brown, LastColor
    
    var colorName: String {
        let colorNames = [
            "none",
            "Red",
            "Green",
            "Blue",
            "Magenta",
            "Yellow",
            "Purple",
            "Orange",
            "Cyan",
            "Brown",
            "LastColor"
        ]
        
        return colorNames[rawValue]
    }
        
    var color: CGColor {
        let colorTypes = [
            UIColor.clearColor().CGColor,
            UIColor.redColor().CGColor,
            UIColor.greenColor().CGColor,
            UIColor.blueColor().CGColor,
            UIColor.magentaColor().CGColor,
            UIColor.yellowColor().CGColor,
            UIColor.purpleColor().CGColor,
            UIColor.orangeColor().CGColor,
            UIColor.cyanColor().CGColor,
            UIColor.brownColor().CGColor,
            UIColor.blackColor().CGColor
        ]
        
        return colorTypes[rawValue]
    }
    
    var description: String {
        return colorName
    }
}

func ==(lhs: LineType, rhs: LineType) -> Bool {
    return lhs.colorName == rhs.colorName
}


class Line: Hashable, Printable {
    var cnt: Int
    var point1: Point?
    var point2: Point?
    var points = [Point]()
    var color: LineType
    var lineEnded: Bool
    
    init(lineType: LineType) {
        self.color = lineType
        self.lineEnded = false
        cnt = 1
    }
    
    func addPoint(point: Point) {
        points.append(point)
        lineEnded = pointInLine(point1!) && pointInLine(point2!)
        cnt = points.count
    }
    
    func firstPoint() -> Point {
        return points[0]
    }
    
    func pointInLine(point: Point) -> Bool {
        for pnt in self.points {
            if pnt == point {
                return true
            }
        }
        return false
    }
    
    func lastPoint() -> Point {
        return points[points.count - 1]
    }

    
    func removeLastPoint() {
        points.removeAtIndex(points.count - 1)
        cnt = points.count
    }
    
    var length: Int {
        return points.count
    }
    
    var description: String {
        return "cnt: \(cnt), point1: \(point1), point2: \(point2), type: \(color) \n points: \(points)"
    }
    
    var hashValue: Int {
        return reduce(points, 0) { $0.hashValue ^ $1.hashValue }
    }
    
}

func ==(lhs: Line, rhs: Line) -> Bool {
    return lhs.points == rhs.points
}
