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
    
    @IBAction func Back(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
 
    
    @IBAction func revealButtonTouched(sender: UIButton) {
        
        let buttonIndex : Int = find(theRevealButtons,sender)!
        //println("the button index is \(buttonIndex)")
        
        //keep the count of number of blocks removed! TBD
        
        if (selectCount < 5) {
            theRevealButtons[buttonIndex].removeFromSuperview()
          
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
       // theImageView.layer.contents = UIImage(named: "chair.jpg")?.CGImage
        thebackgroundImage.layer.cornerRadius = 8.0
        thebackgroundImage.clipsToBounds = true
        
        //add one layer for all game elements
        let gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        
        //need to get the level by checking some parameter and change it to level1 or level2
        
        let level = Level(levelNumber: 2)
       // println("anagrams: \(level.puzzles)")
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

