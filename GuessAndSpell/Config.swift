//
//  Config.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/27/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import UIKit

//UI Constants
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let TileMargin: CGFloat = 10.0
let TileSideLength: CGFloat = 40.0


//Random number generator
func randomNumber(#minX:UInt32, #maxX:UInt32) -> Int {
    let result = (arc4random() % (maxX - minX + 1)) + minX
    return Int(result)
}