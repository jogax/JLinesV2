//
//  CloudData.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 20.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import CloudKit

class CloudData {
    var container: CKContainer
    var privatDB: CKDatabase
    var publicDB: CKDatabase
    var wait = true
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privatDB = container.privateCloudDatabase
    }
    
    func saveRecord(gameData: GameData) {
        deleteIfExists(gameData)
        let gameDataRecord = CKRecord(recordType: "GameStatus")
        gameDataRecord.setValue(gameData.gameName, forKey: "gameName")
        gameDataRecord.setValue(gameData.gameNumber, forKey: "gameNumber")
        gameDataRecord.setValue(gameData.countLines, forKey: "countLines")
        gameDataRecord.setValue(gameData.countMoves, forKey: "countMoves")
        gameDataRecord.setValue(gameData.countSeconds, forKey: "countSeconds")
        gameDataRecord.setValue(gameData.timeStemp, forKey: "timeStamp")
        privatDB.saveRecord(gameDataRecord, completionHandler: { returnRecord, error in
            if let err = error {
                println("error: \(err)")
            }
        })
    }
    
    func deleteIfExists(gameData: GameData) {
        var wait = true
        let p1 = NSPredicate(format: "gameName = %@", gameData.gameName)
        let p2 = NSPredicate(format: "gameNumber = %ld", gameData.gameNumber)
        let predicate = NSCompoundPredicate.andPredicateWithSubpredicates([p1, p2])
        let query = CKQuery(recordType: "GameStatus", predicate: predicate)
        privatDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                self.wait = false
            } else {
                //println("results:\(results.count)")
                self.wait = false
            }
        }
            
    }
    
    func fetchAllRecords() -> MyGames {
        var myGames = MyGames()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "GameStatus", predicate: predicate)
        privatDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
               self.wait = false
            }
            else
            {
                for (ind, result) in enumerate(results!) {
                    let match = result as! CKRecord
                    var gameData = GameData()
                    gameData.gameName = match.valueForKey("gameName")! as! String
                    gameData.gameNumber = match.valueForKey("gameNumber")! as! NSInteger
                    gameData.countLines = match.valueForKey("countLines")! as! NSInteger
                    gameData.countMoves = match.valueForKey("countMoves")! as! NSInteger
                    gameData.countSeconds = match.valueForKey("countSeconds")! as! NSInteger
                    //gameData.timeStemp = match.valueForKey("timeStamp")! as! NSDate
                    let volume = GV.volumeNr
                    //println("volume:\(volume), number: \(gameData.gameNumber), countLines: \(gameData.countLines), countMoves: \(gameData.countMoves)")
                    myGames.volumes[volume].games[gameData.gameNumber - 1] = gameData
                }
                self.wait = false
            }
        }
        while wait
        {
            let a = 0
        }
        return myGames
    }
}