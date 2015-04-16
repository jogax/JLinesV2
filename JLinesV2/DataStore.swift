//
//  DataStore.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 15.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class DataStore {
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    let request = NSFetchRequest()
    var error: NSError?
    var gameEntity: GameStatus
    var exists: Bool = true
    var entityDescription:NSEntityDescription?
    
    init(gameName: String, gameNumber: Int, countLines: Int) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        
        //2
        entityDescription = NSEntityDescription.entityForName("GameStatus", inManagedObjectContext:managedObjectContext!)
        gameEntity = GameStatus(entity:entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        gameEntity.countLines = countLines
        gameEntity.gameName = gameName
        gameEntity.gameNumber = gameNumber
        gameEntity.countMoves = 0
        gameEntity.countSeconds = 0
        
        exists = getObject(gameName, gameNumber: gameNumber, countLines: countLines)
        println("gameName:\(gameName), gameNumber: \(gameNumber), exists: \(exists)")
        managedObjectContext?.save(&error)
        if let err = error {
            let errorMessage = GlobalVariables.language.getText("errorBySaveData",par:String(_cocoaString: err))
            println("\(errorMessage)")
        }
    }
    
    func update(countMoves: Int, countSeconds: Int) {
        gameEntity.countMoves = countMoves
        gameEntity.countSeconds = countSeconds
        managedObjectContext?.save(&error)
        if let err = error {
            let errorMessage = GlobalVariables.language.getText("errorBySaveData",par:String(_cocoaString: err))
            println("\(errorMessage)")
        }
        //
        //println("\(gameEntity)")
    }
   
    func getObject(gameName: String, gameNumber: Int, countLines: Int)->Bool {
        
        request.entity = entityDescription
 
        //request.predicate = NSPredicate(format: "gameName == %@ AND gameNumber == %@", gameName, gameNumber)
        let p1 = NSPredicate(format: "gameName = %@", gameName)
        let p2 = NSPredicate(format: "gameNumber = %ld", gameNumber)
        request.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([p1, p2])
        var results = managedObjectContext?.executeFetchRequest(request, error: &error)
        if error != nil {
            println("err: \(error)")
        }
        let match = results?.first as! NSManagedObject

        //println("\(gameEntity)")
        
        gameEntity.gameName = match.valueForKey("gameName")! as! String
        gameEntity.gameNumber = match.valueForKey("gameNumber")! as! NSInteger
        gameEntity.countLines = match.valueForKey("countLines")! as! NSInteger
        gameEntity.countMoves = match.valueForKey("countMoves")! as! NSInteger
        gameEntity.countSeconds = match.valueForKey("countSeconds")! as! NSInteger
        //println("\(gameEntity)")
        return gameEntity.countMoves > 0
    }
    
    func getData()->(Int, Int) {
        return (gameEntity.countMoves as Int, gameEntity.countSeconds as Int)
    }
    
}