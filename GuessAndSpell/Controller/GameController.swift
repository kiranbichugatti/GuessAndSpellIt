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
    
    var score = 0
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
    private var randomString : NSMutableString = ""
    

    
 
    init() {
        self.data = GameData()
        self.audioController = AudioController()
        audioController.preloadAudioEffects(AudioEffectFiles)
        
        //initialize a mutable array which is the same as the level.puzzle array
    }
    
    
    func DrawRandomPuzzles (theImageView: UIImageView, choosenLevel: Level) {
        //1
        assert(level.puzzles.count > 0, "no level loaded")
        isMatched = false
        
        currentIndex = randomNumber(minX:0, maxX:UInt32(tempLevelData.count-1))
        
        let puzzlePair = tempLevelData[currentIndex] as NSMutableArray
        
        let puzzleImage = puzzlePair[0] as String
        
        populatePuzzleImage(theImageView, imageurl: puzzleImage)
        puzzleWord = puzzlePair[1] as String
        
        let puzzleWordLength = countElements(puzzleWord)
        let tileSide = TileSideLength
        let targetSide = TargetSideLength
        
        //get the left margin for first tile
        var xOffsetTarget = (ScreenWidth - CGFloat(puzzleWordLength) * (tileSide + TileMargin)) / 2.0
        var xOffsetTile = (ScreenWidth - CGFloat(7) * (tileSide + TileMargin)) / 2.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffsetTarget += targetSide / 2.0
        xOffsetTile += tileSide / 2.0
        
        // initialize the target list
        targets = []
        targetViewArray = []
        targetCheckPoint = []
        
        //create targets
        for(index,letter) in enumerate(puzzleWord) {
            if letter != " " {
                let target = TargetView(letter: letter)
                target.center = CGPointMake(xOffsetTarget + CGFloat(index)*(targetSide + TileMargin), ScreenHeight/4*2.8)
                
                targetViewArray.append([target.center.x - TargetSideLength/2, target.center.y - TargetSideLength/2, 0 ])
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
                tile.center = CGPointMake(xOffsetTile + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3.2)
                
                tile.dragDelegate = self
                
                gameView.addSubview(tile)
                tiles.append(tile)
            }
        }
        
        for (index, letter) in enumerate(secondWord) {
            //5
            if letter != " " {
                let tile = TileView(letter: letter)

                tile.center = CGPointMake(xOffsetTile + CGFloat(index)*(tileSide + TileMargin), ScreenHeight/4*3.5)
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
        
        return shuffledWord
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      
        randomString  = NSMutableString(capacity: len)
        
        outerloop: for (var i=0; i < len; i++){
                        var length = UInt32 (letters.length)
                        var rand = arc4random_uniform(length)
            
                     /*   let ch = toString(letters.characterAtIndex(Int(rand)))
            
                        println(toString(letters.characterAtIndex(Int(rand))))
                        for character in puzzleWord.utf8 {
                            if(toString(character) == ch) {
                                continue outerloop
                            }
                   }*/
            
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        println("random strig \(randomString)")

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

        //1 check if target was found
        if let foundTargetView = targetView {
            
            self.placeTile(tileView, targetView: targetView!)
            
            if filled==targets.count {

                /*for i in targetCheckPoint {
                    selectedWord = selectedWord + [tiles[i].letter]
                }
                
                println("selected : \(selectedWord)")
                
                if puzzleWord == selectedWord {
                    isMatched = true
                    updateColor("greenblock")
                    audioController.playEffect(SoundWin)
                    puzzleSucceed()
                } else {
                    isMatched = false
                    updateColor("redblock")
                    audioController.playEffect(SoundWrong)
                }

                self.viewControllerInstance.updateGUI()*/
                checkAnswer()
                
            }
            
        } else {
            //tile is not in the target, we need to bring it back to original place
            
            UIView.animateWithDuration(0.2, animations: {
                
                tileView.center = from
                
                }, completion: nil)
        }
        
        }


    func placeTile(tileView: TileView, targetView: TargetView) {
 
        tileView.userInteractionEnabled = false

        UIView.animateWithDuration(0.35,
            delay:0.00,
            options:UIViewAnimationOptions.CurveEaseOut,
          
            animations:{
                tileView.center = targetView.center
                tileView.transform = CGAffineTransformIdentity
            },
         
            completion: {
                (value:Bool) in
                targetView.hidden = true
        })
        
        filled++
         audioController.playEffect(SoundDing)
    }
    
    func targetClicked(indexInArray: Int) {
        //println("target get clicked \(indexInArray)")
        
        if targetViewArray[indexInArray][2] == 0 {
            filled--
            
            var tileIndex = targetCheckPoint[indexInArray]
            println("tileIndex is : \(tileIndex)")
            targetCheckPoint[indexInArray] = -1
            targets[indexInArray].hidden = false
            
            var clickedTileView = tiles[tileIndex]
            clickedTileView.center = clickedTileView.origin
            clickedTileView.image = UIImage(named:"tile")
            clickedTileView.userInteractionEnabled = true
            
            if filled == targets.count - 1 {
                var j : Int = 0
                for i in targetCheckPoint {
                    if i > -1 {
                        if targetViewArray[j][2] == 1 {
                            tiles[i].image = UIImage(named : "greenblock")
                        } else {
                            tiles[i].image = UIImage(named : "tile")
                        }
                    }
                    j++
                }
            }
        }
    }
    
    func returnRandomSring() -> NSString {
        return randomString
    }
    
    
    //these functions are for hints record
    func revealBlock() -> Int{
        if data.revealHintLeft > 0 {
            data.revealHintLeft--
        }
        return data.revealHintLeft
    }
    
    func getMoreReveal(){
        data.revealHintLeft += 1
    }
    
    func getCorrectLetter() -> Int{
        if data.correctLetterHintLeft > 0 {
            data.correctLetterHintLeft -= 1
        }
        var indexInPuzzle = 0
        var badIndex : Int = -1
        
        for i in targetCheckPoint {
            if i == -1 {
                badIndex = indexInPuzzle
                break
            }
            if i != -1 && tiles[i].letter != puzzleWord[advance(puzzleWord.startIndex, indexInPuzzle)] {
                //println("i is: \(i) and letter is: \(puzzleWord[advance(puzzleWord.startIndex, indexInPuzzle)])")
                badIndex = indexInPuzzle
                targetClicked(badIndex)
                break
            }
            indexInPuzzle++
        }
        
        //if badindex found, bring good letter up to badIndex
        
        if badIndex != -1 {
            for tv in tiles {
                var tileIndex = find(tiles, tv)!
                if tv.letter == puzzleWord[advance(puzzleWord.startIndex, badIndex)]{
                    //found it in the target area
                    //if contains(targetCheckPoint, tileIndex) {
                    if let indexInTarget = find(targetCheckPoint, tileIndex) {
                        if targetViewArray[indexInTarget][2] == 1 {continue}
                        filled--
                        targetCheckPoint[indexInTarget] = -1
                        targets[indexInTarget].hidden = false
                    }
                    
                    var targetView = targets[badIndex]
                    
                    /*UIView.animateWithDuration(0.3,
                        animations:{
                            tv.center = targetView.center
                        })*/
                    UIView.animateWithDuration(0.2,
                        delay:0.01,
                        options:UIViewAnimationOptions.CurveEaseOut,
                        animations: {
                            tv.center = targetView.center
                            
                        },
                        completion: {
                            (value:Bool) in
                            //self.theRevealButtons[buttonIndex].hidden = true
                            targetView.hidden = true
                    })
                    
                    filled++
                    tv.userInteractionEnabled = false
                    tv.image = UIImage(named: "greenblock")
                    targetCheckPoint[badIndex] = tileIndex
                    targetViewArray[badIndex][2] = 1
                    
                    if filled == targets.count {
                        checkAnswer()
                    }
                    
                    break
                }
            }
        }
        return data.correctLetterHintLeft
    }

    
    func getRidOfBadLetter() -> Int{
        
        var count: Int = 0
        
        if data.badLetterHintLeft > 0 {
            data.badLetterHintLeft -= 1
        }
        
        let len = randomString.length
        var anotherstr = randomString as NSString
        var randomIndex = Int(arc4random_uniform(UInt32(len)-1))
        var badletter  = anotherstr.substringWithRange(NSRange(location: randomIndex, length: 1))
        
        println("bad letter : \(badletter)")
      
        outsideloop:     for tv in tiles {
                            for tt in targets {
                                println("tiles: \(tv.letter) : target letter : \(tt.letter) and bad letter: \(badletter)")
                                if (toString(tt.letter) == badletter) {
                                    continue outsideloop
                                }
                            }
                            if (toString(tv.letter) == badletter) {
                                count += 1
                                if count == 2 {break}
                                tv.removeFromSuperview()
                            }
                    }
        return data.badLetterHintLeft
        
    }
    
    func flash()-> Int{
        if data.flashHintLeft > 0 {
            data.flashHintLeft -= 1
        }
        
        return data.flashHintLeft
    }
    
    //if success
    func getBonus(){
        data.points += level.points
    }
    
    func updateColor(color:String){

        for i in targetCheckPoint {
            if i > -1 {
                var theTile = tiles[i]
                theTile.image = UIImage(named:color)
            }
        }

    }

    func returntempLevelData() -> Int {
        
        println("count of tempLevelData \(tempLevelData.count)")
        let count = tempLevelData.count
        return count
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
        
        for t in tiles {
            t.userInteractionEnabled = false
        }
        
        //success animation
        
        var xOffsetTile = (ScreenWidth + CGFloat(7) * (TileSideLength + TileMargin)) / 3.0
        

         var xOffset = (ScreenWidth + CGFloat(7)/4*2.9)
        var yOffset = (ScreenHeight )
        
        let startX:CGFloat = xOffsetTile
        
        let endX:CGFloat = ScreenWidth - 100
        let startY = yOffset
        let endY = ScreenHeight - 500
        
        let stars = StardustView(frame: CGRectMake(startX, startY, 10, 10))
        
        gameView.addSubview(stars)
        gameView.sendSubviewToBack(stars)
        
        
        UIView.animateWithDuration(3.0,
            delay:0.5,
            options:UIViewAnimationOptions.CurveEaseOut,
            animations:{
                stars.center = CGPointMake(startX, endY)
            }, completion: {(value:Bool) in
                //game finished
                stars.removeFromSuperview()
                //when animation is finished, start new game
                self.clearBoard()
                 self.onPuzzleSolved()
              
                
        })
        self.viewControllerInstance.updateGUI()
       // isMatched = false

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
    
    //clear the tiles and targets
    func clearBoard() {
        tiles.removeAll(keepCapacity: false)
        targets.removeAll(keepCapacity: false)
        
        for view in gameView.subviews  {
            view.removeFromSuperview()
        }
        filled = 0
    }
    
    func levelFinished() {
        //start new game, go to next level
        if tempLevelData.count == 0 {
            //startNewLevel()
        }
    }

    func checkAnswer() {
        var i : Int
        var selectedWord = ""
        
        for i in targetCheckPoint {
            selectedWord = selectedWord + [tiles[i].letter]
        }
                
        println("selected : \(selectedWord)")
                
        if puzzleWord == selectedWord {
            isMatched = true
            updateColor("greenblock")
            audioController.playEffect(SoundWin)
            puzzleSucceed()
        } else {
            isMatched = false
            updateColor("redblock")
            audioController.playEffect(SoundWrong)
        }

        self.viewControllerInstance.updateGUI()
    
    }
    
}




