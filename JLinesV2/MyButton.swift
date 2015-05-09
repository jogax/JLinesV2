//
//  MyButton.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 29.04.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import UIKit

class MyButton: UIButton {
    init() {
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        //self.backgroundColor = GV.springGreenColor
        self.layer.cornerRadius = 8
        //self.layerGradient()
        setupDepression()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

