//
//  GameController.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import QuartzCore

import UIKit

class GameController: TileDragDelegateProtocol {
    
    var gameView: UIView!
    var level: Level!
    private var tiles: [TileView] = []
    private var targets: [TargetView] = []
    private var puzzlesDatasource = [String]()
    
    
    init() {
        
    }
    
    
    
    func DrawRandomPuzzles (theImageView: UIImageView, choosenLevel: Level) {
        //1
        assert(level.puzzles.count > 0, "no level loaded")
        
        //2
        let randomIndex = randomNumber(minX:0, maxX:UInt32(level.puzzles.count-1))
        let puzzlePair = level.puzzles[randomIndex]
        
        //3
        let puzzleImage = puzzlePair[0] as String
        
        populatePuzzleImage(theImageView, imageurl: puzzleImage)
        let puzzleWord = puzzlePair[1] as String
        
        //4
        let puzzleWordLength = countElements(puzzleWord)
        
        //5
        println("Image \(puzzleImage)")
        println("phrase1[\(puzzleWordLength)]: \(puzzleWord)")
        
        //calculate the tile size
        //let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(puzzleWordLength)) - TileMargin
        let tileSide = TileSideLength
        
        //get the left margin for first tile
        var xOffset = (ScreenWidth - CGFloat(puzzleWordLength) * (tileSide + TileMargin)) / 5.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset += tileSide / 2.0
        
        
        // initialize the target list
         targets = []
        
        //create targets
        for(index,letter) in enumerate(puzzleWord) {
            if letter != " " {
                let target = TargetView(letter: letter, sideLength: tileSide)
                target.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3.2)
                
                gameView.addSubview(target)
                targets.append(target)
            }
        }
        
        //1 initialize tile list
        tiles = []
        
        //2 create random letters
        
        var shuffledPuzzleWord : String = shuffle(puzzleWord)
        
        //Split the shuffled string into half
        
        let len = countElements(shuffledPuzzleWord)
        let halfLEn = len/2
        
        let halfOfString = advance(shuffledPuzzleWord.startIndex, halfLEn)
       
        let firstWord = shuffledPuzzleWord.substringWithRange(Range<String.Index>(start:advance(shuffledPuzzleWord.startIndex, 0),end: advance(shuffledPuzzleWord.startIndex,halfLEn)))
        
        let secondWord = shuffledPuzzleWord.substringFromIndex(halfOfString)
        
        
        //4 create tiles
        
        for (index, letter) in enumerate(firstWord) {
            //5
            if letter != " " {
                let tile = TileView(letter: letter)
               // println("\(tile)")
                tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3.6)
                
                //6 supply the drag delegate to tiles
                tile.dragDelegate = self
                
                gameView.addSubview(tile)
                tiles.append(tile)
            }
        }
        
        for (index, letter) in enumerate(secondWord) {
            //5
            if letter != " " {
                let tile = TileView(letter: letter)
                // println("\(tile)")
                tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3.9)
                
                //6 supply the drag delegate to tiles
                
                tile.dragDelegate = self
                
                gameView.addSubview(tile)
                tiles.append(tile)
            }
        }
   }
    
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        var targetView: TargetView?
        for tv in targets {
            if CGRectContainsPoint(tv.frame, point) && !tv.isMatched {
                targetView = tv
                break
            }
        }
    }

    
    
    func shuffle(puzzleWord: String)-> NSString {
        
        var puzzleLetters = randomStringWithLength(5)
        
        var selectedword = puzzleWord+puzzleLetters
        var newWord = selectedword.capitalizedString
        
        var shuffledWord: String = ""
         println("new word \(newWord)")
    
        while countElements(newWord) > 0 {
            
            // Get the random index
            var length = countElements(newWord)
            var position = Int(arc4random_uniform(UInt32(length)))
            
            // Get the character at that random index
            var subString = newWord[advance(newWord.startIndex, position)]
            // Add the character to the shuffledWord string
            shuffledWord.append(subString)
            // Remove the character from the original selectedWord string
            newWord.removeAtIndex(advance(newWord.startIndex, position))
         }
        println("shuffled word \(shuffledWord)")

        
        return shuffledWord
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    

    func populatePuzzleImage(theImageView: UIImageView, imageurl: String) {
        
        theImageView.image = UIImage(named: imageurl)
        
       /* if let url = NSURL(string: imageurl) {
            if let data = NSData(contentsOfURL: url){
                println("inside image data0 \(data)")
                
                let image = UIImage(data: data)
               
                theImageView.layer.contents = UIImage(data: data)?.CGImage
                
                //theImageView.contentMode = UIViewContentMode.ScaleAspectFit
                
                //theImageView.layer.contents =  UIImage(data: data)?.CGImage // returns blank, need to ask professor
                
            }
        } */
    }
}




