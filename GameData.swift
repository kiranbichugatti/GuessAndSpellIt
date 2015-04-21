//
//  GameData.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 4/2/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation

class GameData {
    var points:Int = 0 {
        didSet {
            //custom setter - keep the score positive
            points = max(points, 0)
        }
    }
    var revealHintLeft: Int = 3
    var badLetterHintLeft:Int = 3
    var correctLetterHintLeft :Int = 3
}