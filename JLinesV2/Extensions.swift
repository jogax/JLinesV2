//
//  Extensions.swift
//  JogaxLinesV1
//
//  Created by Jozsef Romhanyi on 03.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation

extension Dictionary {
    static func loadJSONFromBundle(fileName: String) -> (Dictionary <String, AnyObject>?, NSData?) {
        //if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
        if   let path = NSBundle.mainBundle().pathForResource(fileName,ofType:"json") {

            
            var error: NSError?
            let data: NSData? = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: &error)
            if let data = data {
                
                let dictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                    options:NSJSONReadingOptions(), error: &error)
                
                if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                    return (dictionary,data)
                } else {
                    println("Level file \(fileName) is not valid JSON: \(error!)")
                    return (nil,nil)
                }
            } else {
                println("Could not load level file: \(fileName), error: \(error!)")
            }
        } else {
            println("Could not find level file \(fileName)")
            return (nil,nil)
        }
        return (nil,nil)
    }
    
}

extension Array {
    func find<T: Equatable> (item: T) -> Int? {
        for (idx, element) in enumerate(self) {
            if element as T == item {
                return idx
            }
        }
        return nil
    }

    mutating func remove <T: Equatable> (item: T) {
        if let index = find(item) {
            removeAtIndex(index)
        }

    }

}






