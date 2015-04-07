// Playground - noun: a place where people can play

import Foundation

let file = "file.txt"

if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
    let dir = dirs[0] //documents directory
    let path = dir.stringByAppendingPathComponent(file);
    let text = "some text blablabla"
    
    //writing
    text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    
    //reading
    let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
}