//
//  JoyStick.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 19.05.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit
import Foundation

class JoyStick: UIView {
    var color: UIColor
    var knopf = CALayer()
    var shadow = CALayer()
    override init(frame: CGRect) {
        color = UIColor.clearColor()
        super.init(frame: frame)
        /*
        */
        //self.hidden = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setJoyStickLayout () {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = GV.joyStickRadius / 1.7
        self.layer.borderWidth = 1.0
        self.backgroundColor = color
        knopf.backgroundColor = UIColor.brownColor().CGColor
        knopf.frame = CGRectMake(self.frame.origin.x + self.frame.width / 4, self.frame.origin.y + self.frame.width / 4, self.frame.width / 2, self.frame.width / 2)
        knopf.hidden = false
        self.layer.addSublayer(knopf)
        shadow.shadowColor = UIColor.whiteColor().CGColor
        shadow.shadowOffset = CGSizeMake(5,5)
        shadow.shadowOpacity = 1.0
        shadow.backgroundColor = UIColor.whiteColor().CGColor
        knopf.addSublayer(shadow)        
   }
}
