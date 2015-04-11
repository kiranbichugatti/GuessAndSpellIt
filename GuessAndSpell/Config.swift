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

// sound effects
let SoundDing = "ding.mp3"
let SoundWrong = "wrong.m4a"
let SoundWin = "win.mp3"
let AudioEffectFiles = [SoundDing, SoundWrong, SoundWin]
let TileSideLength: CGFloat = 50.0


//Random number generator
func randomNumber(#minX:UInt32, #maxX:UInt32) -> Int {
    let result = (arc4random() % (maxX - minX + 1)) + minX
    return Int(result)
}