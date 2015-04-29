//
//  GameStatus.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 20.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import CoreData

class GameStatusX: NSManagedObject {

    @NSManaged var countLines: NSNumber
    @NSManaged var countMoves: NSNumber
    @NSManaged var countSeconds: NSNumber
    @NSManaged var gameName: String
    @NSManaged var gameNumber: NSNumber
    @NSManaged var timeStamp: NSDate

}
