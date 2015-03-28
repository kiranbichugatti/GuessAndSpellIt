//
//  GameController.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation

import UIKit

class GameController {
    
    var gameView: UIView!
    var level: Level!
    private var tiles: [TileView] = []
    
    init() {
    }
    
    func DrawRandomPuzzles () {
        //1
        assert(level.puzzles.count > 0, "no level loaded")
        
        //2
        let randomIndex = randomNumber(minX:0, maxX:UInt32(level.puzzles.count-1))
        let puzzlePair = level.puzzles[randomIndex]
        
        //3
        let puzzleWord = puzzlePair[1] as String
        
        //4
        let puzzleWordLength = countElements(puzzleWord)
        
        //5
        println("phrase1[\(puzzleWordLength)]: \(puzzleWord)")
        
        //calculate the tile size
        //let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(puzzleWordLength)) - TileMargin
        let tileSide = TileSideLength
        
        //get the left margin for first tile
        var xOffset = (ScreenWidth - CGFloat(puzzleWordLength) * (tileSide + TileMargin)) / 2.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset += tileSide / 2.0
        
        //1 initialize tile list
        tiles = []
        
        //2 create tiles
        for (index, letter) in enumerate(puzzleWord) {
            //3
            if letter != " " {
                let tile = TileView(letter: letter)
                println("\(tile)")
                tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3)
                
                //4
                gameView.addSubview(tile)
                tiles.append(tile)
            }
        }
        
    }
}