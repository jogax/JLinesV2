//
//  Point.swift
//  JogaxLinesV1
//
//  Created by Jozsef Romhanyi on 07.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation



class Point: Printable, Hashable {
    
    var column: Int
    var row: Int
    var color: LineType
    var originalPoint: Bool
    var inLinePoint: Bool
    var earlierColor: LineType
    
    init(column: Int, row: Int, type: LineType, originalPoint: Bool, inLinePoint: Bool) {
        self.column = column
        self.row = row
        self.color = type
        self.originalPoint = originalPoint
        self.inLinePoint = inLinePoint
        self.earlierColor = LineType.Unknown
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

