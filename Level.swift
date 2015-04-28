//
//  Level.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation

struct Level {
    let points: Int
    let timeToSolve: Int
    let puzzles: [NSArray]
    
    init(levelNumber: Int) {
        //1 find .plist file for this level
        let fileName = "level\(levelNumber).plist"
        let levelPath = "\(NSBundle.mainBundle().resourcePath!)/\(fileName)"
        
        //2 load .plist file
        let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath)
        
        //3 validation
        assert(levelDictionary != nil, "Level configuration file not found")
        
        //4 initialize the object from the dictionary
        self.points = levelDictionary!["points"] as! Int
        self.timeToSolve = levelDictionary!["timeToSolve"] as! Int
        self.puzzles = levelDictionary!["puzzles"] as! [NSArray]
    }
}

