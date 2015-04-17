//
//  GameController.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import QuartzCore
import AVFoundation

import UIKit

class GameController: TileDragDelegateProtocol {
    
    var gameView: UIView!
    var level: Level!
    var isMatched = false
    var gameover = false
    private var score = 0
    var viewControllerInstance: ViewController!
    var tempLevelData : NSMutableArray!
    var currentTileOrigin : CGPoint!
    var targetViewArray : [[CGFloat]] = []
    var targetCheckPoint:[Int] = []
    
    private var tiles: [TileView] = []
    private var targets: [TargetView] = []

    private var puzzlesDatasource = [String]()
    private var data:GameData
    private var filled : Int = 0
    private var selectedTileView:[TileView] = []
    private var currentIndex : Int!
    private var audioController:  AudioController
    private var puzzleWord: String = ""
    
    var onPuzzleSolved: (( ) -> ( ))!
    

    
 
    init() {
        self.data = GameData()
        self.audioController = AudioController()
        audioController.preloadAudioEffects(AudioEffectFiles)
        
        //initialize a mutable array which is the same as the level.puzzle array
    }
    
    
    func DrawRandomPuzzles (theImageView: UIImageView, choosenLevel: Level) {
        
        println("inside randompuzzle")
        //1
        assert(level.puzzles.count > 0, "no level loaded")
        
        currentIndex = randomNumber(minX:0, maxX:UInt32(tempLevelData.count-1))
        
        let puzzlePair = tempLevelData[currentIndex] as NSMutableArray
        
        
        //3
        let puzzleImage = puzzlePair[0] as String
        
        populatePuzzleImage(theImageView, imageurl: puzzleImage)
        puzzleWord = puzzlePair[1] as String
        
        //4
        let puzzleWordLength = countElements(puzzleWord)
        
        //5
        println("Image \(puzzleImage)")
        println("phrase1[\(puzzleWordLength)]: \(puzzleWord)")
        
        //calculate the tile size
        //let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(puzzleWordLength)) - TileMargin
        let tileSide = TileSideLength
        let targetSide = TargetSideLength
        
        //get the left margin for first tile
        var xOffset = (ScreenWidth - CGFloat(puzzleWordLength) * (tileSide + TileMargin)) / 5.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset += tileSide / 2.0
        
        
        // initialize the target list
        targets = []
        
        targetCheckPoint = []
        
        //create targets
        for(index,letter) in enumerate(puzzleWord) {
            if letter != " " {
                let target = TargetView(letter: letter)
                target.center = CGPointMake(xOffset + CGFloat(index)*(targetSide + TileMargin), ScreenHeight/4*3.2)
                
                targetViewArray.append([target.center.x - TargetSideLength/2, target.center.y - TargetSideLength/2 ])
                targetCheckPoint.append(-1)
                
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
    
    func tileView(tileView: TileView, didDragToPoint point: CGPoint, from : CGPoint) {
        
        var checked = 0
        var i : Int
        var selectedWord = ""
       
        var targetView: TargetView?
        for i in 0...targets.count-1 {
            if CGRectContainsPoint(targets[i].frame, point) && targetCheckPoint[i] == -1 {
                targetView = targets[i]

                println("the letter is placed at \(i)")
                if let j = find(tiles, tileView) {
                    println("tileView is at index : \(j)")
                    targetCheckPoint[i] = j
                }

                println("the array is: \(targetCheckPoint)")
                break
            }
        }
        
        /*for tv in targets {
            if CGRectContainsPoint(tv.frame, point) {
                targetView = tv
                break
            }
        }*/
        
        //1 check if target was found
        if let foundTargetView = targetView {
            
            self.placeTile(tileView, targetView: targetView!)
            
            if filled==targets.count {

                for i in targetCheckPoint {
                    selectedWord = selectedWord + [tiles[i].letter]
                }
                
                println("selected : \(selectedWord)")
                
                if puzzleWord == selectedWord {
                    isMatched = true
                    puzzleSucceed()
                } else {
                    isMatched = false
                }
                
                updateColor()
               // self.viewControllerInstance.updateGUI()
                
            }
            
        } else {
            //tile is not in the target, we need to bring it back to original place
            
            UIView.animateWithDuration(0.2, animations: {
                
                tileView.center = from
                
                }, completion: nil)
        }
        
        }


    func placeTile(tileView: TileView, targetView: TargetView) {
        
        //selectedTileView.append(tileView)
        
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
         audioController.playEffect(SoundDing)
    }
    
    func targetClicked(indexInArray: Int) {
        
        filled--
        
        var tileIndex = targetCheckPoint[indexInArray]
        println("tileIndex is : \(tileIndex)")
        targetCheckPoint[indexInArray] = -1
        targets[indexInArray].hidden = false
        //var x = targetViewArray[indexInArray][2] as CGFloat
        //var y = targetViewArray[indexInArray][3] as CGFloat
        var clickedTileView = tiles[tileIndex]
        clickedTileView.center = clickedTileView.origin
        clickedTileView.image = UIImage(named:"tile")
        clickedTileView.userInteractionEnabled = true
        
        if filled == targets.count - 1 {
            for i in targetCheckPoint {
                if i > -1 {
                    tiles[i].image = UIImage(named : "tile")
                }
            }
        }
        
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
    
    func updateColor(){
        
        var color = "redblock"
        if isMatched {
            color="greenblock"
           audioController.playEffect(SoundWin)
        } else {
            audioController.playEffect(SoundWrong)
        }
        
        //should we do it here?.. when the new game starts, it crashes here.
        for i in targetCheckPoint {
            if i > -1 {
                var theTile = tiles[i]
                theTile.image = UIImage(named:color)
            }
        }

    }
    
    func puzzleSucceed(){
        
        
        //text to voice
        
        let synth = AVSpeechSynthesizer()
        var puzzleWordToUtter = AVSpeechUtterance(string: puzzleWord)
        
        //bring up the modal
        //give the bonus points
        data.points+=level.points
        score += level.points
        
        //remove the instance from the level array
        
        tempLevelData.removeObjectAtIndex(currentIndex)
        
        audioController.playEffect(SoundDing)
        //text to voice framework
        puzzleWordToUtter.rate = 0.1
        synth.speakUtterance(puzzleWordToUtter)
        
        //remove all the blocks, call updateGUI function
        
        
        //success animation
        
        let firstTarget = targets[0]
        let startX:CGFloat = 0
        let endX:CGFloat = ScreenWidth + 300
        let startY = firstTarget.center.y
        
        
        let stars = StardustView(frame: CGRectMake(startX, startY, 10, 10))
        
        gameView.addSubview(stars)
        gameView.sendSubviewToBack(stars)
        
        
        UIView.animateWithDuration(3.0,
            delay:0.5,
            options:UIViewAnimationOptions.CurveEaseOut,
            animations:{
                stars.center = CGPointMake(endX, startY)
            }, completion: {(value:Bool) in
                //game finished
                stars.removeFromSuperview()
                //when animation is finished, show menu
                self.clearBoard()
                
                 self.onPuzzleSolved()
        })
        self.viewControllerInstance.updateGUI()
        
        //need to work on counting the puzzle and call the level dynamically //and different image is not getting covered

        
        
        
    }
    
    
    //clear the tiles and targets
    func clearBoard() {
        tiles.removeAll(keepCapacity: false)
        targets.removeAll(keepCapacity: false)
        filled = 0
        
        for view in gameView.subviews  {
            view.removeFromSuperview()
        }
    }
    
    func currentScore() -> Int {
        return score
    }
    
    func currentPuzzleIndex() -> Int {
        if currentIndex != nil {
        return currentIndex
        } else {
            return 0
        }
    }
    
    func levelFinished() {
        //start new game, go to next level
    }

    
}




