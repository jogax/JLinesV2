//
//  Extensions.swift
//  JogaxLinesV1
//
//  Created by Jozsef Romhanyi on 03.02.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit

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


extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
/*
    func characterAtIndex(index: Int) -> Character? {
        var cur = 0
        for char in self {
            if cur == index {
                return char
            }
            cur++
        }
        return nil
    }
*/    
    func characterAtIndex(index:Int) -> unichar
    {
        return self.utf16[index]
    }
    
    // Allows us to use String[index] notation
    subscript(index:Int) -> unichar
        {
            return characterAtIndex(index)
    }



}










