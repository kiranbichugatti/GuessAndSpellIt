//
//  GameController.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import QuartzCore
//import AVFoundation

import UIKit

class GameController: TileDragDelegateProtocol {
    
    var gameView: UIView!
    var level: Level!
    var isMatched = false
    var gameover = false
   // var viewcontrollerInstance: ViewController
    
    private var tiles: [TileView] = []
    private var targets: [TargetView] = []
    private var puzzlesDatasource = [String]()
    private var data:GameData
    private var filled : Int = 0
 
    init() {
        self.data = GameData()
       // self.viewcontrollerInstance = ViewController()
        
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
                
                println("tile location is \(tile.center)")
                
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
    
    
    func shuffle(puzzleWord: String)-> NSString {
        
        var len = countElements(puzzleWord)
        var puzzleLetters = randomStringWithLength(14 - len)
        
        var newWord = puzzleWord+puzzleLetters
        
        println("selected word \(newWord)")
       // var newWord = selectedword.capitalizedString
        
        var shuffledWord: String = ""
    
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
        println("random letters \(letters)")
        
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
      
    }
    
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        
        var checked = 0
        
       
        var targetView: TargetView?
        for tv in targets {
            if CGRectContainsPoint(tv.frame, point) && !tv.isMatched {
                targetView = tv
                break
            }
        }
        
        //1 check if target was found
        if let foundTargetView = targetView {
            
            
            println("filled \(targets.count)")
            
                for lett in targets {
                    
                    self.placeTile(tileView, targetView: targetView!)
                    
                    
                    if foundTargetView.letter != tileView.letter {
                        
                        checked--
                    
                        println("targetView unmatched:\(foundTargetView.letter)")
                    
                        tileView.userInteractionEnabled = true
                    
                       //tileView.image = UIImage(named: "greenblock")!
                       isMatched = false
                    
                    //check for finished game
                  // self.checkForSuccess(tileView)
                    
                     } else {
                         println("targeview matched \(tileView.letter)")
                        checked++
                        isMatched = true
                    }
                }
        }
        
        if (filled == targets.count) {
             println("inside filled == target.count \(filled)")
            if(checked == targets.count) {
                println("checked \(checked)")
                tileView.image = UIImage(named: "greenblock")
                isMatched = true
            } else {
                println("checked  else \(checked)")
                tileView.image = UIImage(named: "redblock")
                isMatched = true
            }
        }
        
         /* //check for finished game
               // checkForSuccess()
                
                //give points
                data.points += level.points
        
                var tileviewCGpointCoordinate = tileView.center
                println("tile view coordinates\(tileviewCGpointCoordinate)")
               
                tileView.userInteractionEnabled = true
                
                tileView.image = UIImage(named: "redblock")!

                //2  Animate
                
                UIView.animateWithDuration(0.75,
                    delay:0.00,
                    options:UIViewAnimationOptions.CurveEaseOut,
                    animations: {
                        
                        //the below code will bring the tile slightly below the target view
                        tileView.center = CGPointMake(tileView.center.x + CGFloat(randomNumber(minX:0, maxX:50)-30),
                            tileView.center.y + CGFloat(randomNumber(minX:20, maxX:80)))
                        
                        //Need to find the exact origin of the tileview so, we can send the tile back to its original location not working now.
                        //tileView.center = CGPointMake(tilevieworiginX,tilevieworiginY)
                        
                          tileView.transform = CGAffineTransformIdentity
                        tileView.alpha = 1
                    },
                    completion: {
                        (value:Bool) in
                        tileView.hidden = false
                })
                
        
                //4. take out points
                data.points -= level.points/2 */
               
    }


    func placeTile(tileView: TileView, targetView: TargetView) {
        //1
        targetView.isMatched = true
        tileView.isMatched = true
        
        //2
        tileView.userInteractionEnabled = false
        
        //3
        UIView.animateWithDuration(0.35,
            delay:0.00,
            options:UIViewAnimationOptions.CurveEaseOut,
            //4
            animations:{
                tileView.center = targetView.center
                tileView.transform = CGAffineTransformIdentity
            },
            //5
            completion: {
                (value:Bool) in
                targetView.hidden = true
        })
        filled++
    }
    
    func checkForSuccess(tileview:TileView) {
        for targetView in targets {
            //no success, bail out
            if !targetView.isMatched {
               return
            }
        }
        gameover = true
        
        //call text to voice
        
       // viewcontrollerInstance.updateGUI()
        println("Game Over!")
        
        
    }
    

    
    
    //these functions are for hints record
    func revealBlock(){
        data.revealHintLeft -= 1
    }
    
    func getMoreReveal(){
        data.revealHintLeft += 1
    }
    
    func getCorrectLetter(){
        data.correctLetterHintLeft -= 1
    }
    
    func getRidOfBadLetter(){
        data.badLetterHintLeft -= 1
    }
    
    //if success
    func getBonus(){
        data.points += level.points
    }
    
}




