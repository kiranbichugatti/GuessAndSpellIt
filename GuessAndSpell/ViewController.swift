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
   
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var thebackgroundImage: UIImageView!
    
    @IBOutlet weak var remainingReveal: UILabel!
    
    @IBOutlet var theRevealButtons: [UIButton]!
    
    var animator:UIDynamicAnimator!
    var gravityBehavior:UIGravityBehavior!
    
    
    var selectCount: Int = 0 {
        didSet {
            println("remaining reveal : \(5 - selectCount)")
            
            remainingReveal.text = "Remaining Reveal: \(5 - selectCount)"
        }
    }
  
    
    required init(coder aDecoder: NSCoder) {
        controller = GameController()
        gamedata = GameData()
        super.init(coder: aDecoder)
    }
   
    var matched:Bool =  false {
        didSet {
            if controller.isMatched == true {
                println("ismatched inside didset \(controller.isMatched)")
                matched = controller.isMatched
                updateGUI()
            }
            
        }
    }
    
    @IBAction func Back(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
 
    @IBAction func revealButtonTouched(sender: UIButton) {
        
        let buttonIndex : Int = find(theRevealButtons,sender)!
        let buttonAtIndex = theRevealButtons[buttonIndex]
        let newPoint = CGPointMake(buttonAtIndex.center.x,
            buttonAtIndex.center.y - 70)

        if (selectCount < 5) {
            UIView.animateWithDuration(2,
                delay:0.01,
                options:UIViewAnimationOptions.CurveEaseInOut,
                animations: {

                   
                self.theRevealButtons[buttonIndex].alpha = 0
                      buttonAtIndex.center = newPoint
                
                buttonAtIndex.transform  = CGAffineTransformIdentity
                    
                },
                completion: {
                    (value:Bool) in
                     buttonAtIndex.center = newPoint
                  //  self.theRevealButtons[buttonIndex].removeFromSuperview()
                    
                    
            })
            selectCount++
        }
       
        controller.revealBlock()
        
    }
    
    //create a function to pick a new game which should have new image, username, userscore
    
    func StartNewGame() {
        
        
    }
    
    //we need this to update the reveal info and hints.
    func updateGUI(){
        println("matched? \(controller.isMatched)")
        if (controller.isMatched){
            //remove all the buttons on the image, we can add some effect later
            for button in theRevealButtons {
                button.removeFromSuperview()
            }
        }
     //   scoreLabel.text = "Score: " + gamedata.points
        
        //update hints view
        
        //update reveals left text
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //this should be done dynamically
          thebackgroundImage.layer.cornerRadius = 8.0
        thebackgroundImage.clipsToBounds = true
        
        //add one layer for all game elements
        let gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        
        //need to get the level by checking some parameter and change it to level1 or level2
        
        let level = Level(levelNumber: 2)

        controller.level = level
        controller.tempLevelData = NSMutableArray(array: level.puzzles)
        controller.DrawRandomPuzzles(thebackgroundImage,choosenLevel: level)
        
        updateGUI()
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

