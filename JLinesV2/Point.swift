//
//  Point.swift
//  JogaxLinesV1
//
//  Created by Jozsef Romhanyi on 07.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation


struct Directions {
    var left: Int
    var right: Int
    var up: Int
    var down: Int
    var count: Int
    var countDirections: Int
    
    init() {
        left = 0
        right = 0
        up = 0
        down = 0
        count = 0
        countDirections = 0
    }
}

class Point: Printable, Hashable {
    
    var column: Int
    var row: Int
    var checkDirections: ()->()
    var color: LineType {
        didSet {
            if color != oldValue {
                checkDirections()
            }
        }
    }
    var originalPoint: Bool
    var inLinePoint: Bool
    var earlierColor: LineType
    var gameSize: Int
    var areaNumber: Int
    var directions: Directions
    
    init(column: Int, row: Int, type: LineType, originalPoint: Bool, inLinePoint: Bool, size: Int, delegate: ()->()) {
        self.column = column
        self.row = row
        self.color = type
        self.originalPoint = originalPoint
        self.inLinePoint = inLinePoint
        self.earlierColor = LineType.Unknown
        self.gameSize = size
        self.checkDirections = delegate
        self.areaNumber = -1
        self.directions = Directions()
    }
    
    var description: String {
        return String("\n column: \(column), row: \(row), type: \(color), originalPoint: \(originalPoint), inLinePoint: \(inLinePoint)")
    }
    
    var hashValue: Int {
        return (column + 1) * (row + 1)
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color == rhs.color
}

