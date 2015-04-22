//
//  ViewController.swift
//  GuessAndSpell
//
//  Created by uics1 on 3/9/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    private var controller:GameController
    var gamedata: GameData
   
    var gravity : UIGravityBehavior!
    var animator : UIDynamicAnimator
    var gameView : UIView
    var level : Level!
    var revealChance = 3

    
    @IBOutlet weak var puzzleLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var thebackgroundImage: UIImageView!
    @IBOutlet weak var remainingReveal: UILabel!
    @IBOutlet var theRevealButtons: [UIButton]!
    
    @IBOutlet weak var RevealHint: UIButton!
    
    var selectCount: Int = 0 {
        didSet { 
            remainingReveal.text = "Remaining Reveal: \(5 - selectCount)"
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        controller = GameController()
        gamedata = GameData()
        
        gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        animator = UIDynamicAnimator(referenceView: gameView)
        
        super.init(coder: aDecoder)
    }
   
    @IBAction func revealHintTouched(sender: UIButton) {
        var left = controller.revealBlock()
        sender.setTitle(toString(left), forState: UIControlState.Normal)
        if left == 0 {sender.enabled = false}
        if left >= 0 {selectCount--}
        
       gamedata.points -= 10
     scoreLabel.text = "Score: \(controller.currentScore())"
        
    }

    @IBAction func RemoveLetterPressed(sender: UIButton) {
        let removeLeft = controller.getRidOfBadLetter()
        sender.setTitle(toString(removeLeft), forState: UIControlState.Normal)
        if removeLeft == 0 { sender.enabled = false }
        
        gamedata.points -= 10
        updateGUI()
        
    }
    
    @IBAction func correctHintTouched(sender: UIButton) {
        var left = controller.getCorrectLetter()
        sender.setTitle(toString(left), forState: UIControlState.Normal)
        if left == 0 {sender.enabled = false}
    }
    
    @IBAction func Back(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
 
    
    @IBAction func revealButtonTouched(sender: UIButton) {
        
        let buttonIndex : Int = find(theRevealButtons,sender)!
        let buttonAtIndex = theRevealButtons[buttonIndex]
        
        if (selectCount < 5) {
            UIView.animateWithDuration(2,
                delay:0.01,
                options:UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    
                    let newPoint = CGPointMake(buttonAtIndex.center.x,
                        buttonAtIndex.center.y - 70)

                    buttonAtIndex.center = newPoint
                },
                completion: {
                    (value:Bool) in
                    self.theRevealButtons[buttonIndex].hidden = true
            })
            

          
            selectCount++
        }
        
    }
    
    //create a function to pick a new game which should have new image, username, userscore
    
    func startNewPuzzle() {
        
        var level = Level(levelNumber:2)
        controller.level = level
        controller.tempLevelData = NSMutableArray(array: level.puzzles)
        controller.DrawRandomPuzzles(thebackgroundImage,choosenLevel: level)
        
        for button in theRevealButtons {
            button.hidden = false
            button.enabled = true
        }
        selectCount = 0
        
                controller.returntempLevelData()
    }
    
    //we need this to update the reveal info and hints.
    func updateGUI(){
        
        //controller.updateColor()

        if (controller.isMatched){

            //remove all the buttons on the image, we can add some effect later
            for button in theRevealButtons {
                UIView.animateWithDuration(1.0, animations:{
                    button.hidden = true
                })

            }
            //gravity = UIGravityBehavior(items: [theRevealButtons])
            //animator.addBehavior(gravity)
            
            scoreLabel.text = "Score: \(controller.currentScore())"
       
        }
        

        
      // scoreLabel.text = "Score: \(gamedata.points)"
        //println("point is \(gamedata.points)")
        
        //update hints view
        
        //update reveals left text
        
    }
    
    //detect touch, if it's in range of target tile, bring it back to original place
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch = touches.anyObject() as UITouch
        let location = touch.locationInView(self.view)
        //println("touched \(location)")
        var i = 0
        for coor in controller.targetViewArray {
            var smallx = coor[0] as CGFloat
            var smally = coor[1] as CGFloat
            var bigx = (coor[0] + TargetSideLength ) as CGFloat
            var bigy = (coor[1] + TargetSideLength ) as CGFloat

            if (location.x > smallx) && location.x < bigx && location.y > smally &&
                (location.y < bigy)&&(controller.targetCheckPoint[i] > -1) && (!controller.isMatched){
                controller.targetClicked(i)
                break
            }
            i++
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //this should be done dynamically
       // theImageView.layer.contents = UIImage(named: "chair.jpg")?.CGImage
        thebackgroundImage.layer.cornerRadius = 8.0
        thebackgroundImage.clipsToBounds = true
        
        //add one layer for all game elements
        self.view.addSubview(gameView)
        controller.gameView = gameView
        
        //get the level and puzzle number
       
        puzzleLabel.text = "Puzzle: \(controller.currentPuzzleIndex())"
        println("puzzle is \(controller.currentPuzzleIndex())")
        
        //pass a reference of viewController to gameController
        controller.viewControllerInstance = self
        
        //need to get the level by checking some parameter and change it to level1 or level2
        
        controller.onPuzzleSolved =  self.startNewPuzzle
        
        updateGUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.startNewPuzzle()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

