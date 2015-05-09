//
//  MyDevice.swift
//  JLinesV2
//
//  Created by Jozsef Romhanyi on 05.05.15.
//  Copyright (c) 2015 Jozsef Romhanyi. All rights reserved.
//

import Foundation
import UIKit

class MyDevice {
    
    var deviceType: String
//    private var sizes = [String:CGFloat]()
    
    init () {
        let testDevice = UIDevice().deviceType
        var devType = UIDevice.currentDevice().localizedModel
        if let pos = devType.rangeOfString(" Simulator") {
            devType.replaceRange(pos, with: "")
        }
        let orientation = UIDevice.currentDevice().orientation
        let screen = UIScreen.mainScreen().nativeBounds
        let screenSize = (screen.width, screen.height)
        switch screenSize {
            case (640,960):
                devType += "4"
            case (640,1136):
                devType += "5"
            case (750,1334):
                devType += "6"
            case (1080, 1920):
                devType += "6 Plus"
            case (1536, 2048):
                devType += " Air"

        default:
                let devType1 = devType
        }

        switch orientation {
            case .Portrait, .PortraitUpsideDown, .FaceUp, .FaceDown:
                devType += " Portrait"
        case .LandscapeLeft, .LandscapeRight:
                devType += " Landscape"
            default:
                let x = 0
        }
        let screenWidth  = UIScreen.mainScreen().fixedCoordinateSpace.bounds.width
        let screenHeight = UIScreen.mainScreen().fixedCoordinateSpace.bounds.height
        let nativeScale = UIScreen.mainScreen().nativeBounds
        self.deviceType = devType
    }
}