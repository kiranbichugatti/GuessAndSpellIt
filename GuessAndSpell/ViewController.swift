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
    
    
    
    @IBOutlet weak var thebackgroundImage: UIImageView!
    
    @IBOutlet var theRevealButtons: [UIButton]!
    
    required init(coder aDecoder: NSCoder) {
        controller = GameController()
        super.init(coder: aDecoder)
    }
    
    @IBAction func Back(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
 
    
    @IBAction func revealButtonTouched(sender: UIButton) {
        
        let buttonIndex : Int = find(theRevealButtons,sender)!
        //println("the button index is \(buttonIndex)")
        
        //keep the count of number of blocks removed! TBD
        
        theRevealButtons[buttonIndex].removeFromSuperview()
        
    }
    
    //create a function to pick a new game which should have new image, username, userscore
    
    func StartNewGame() {
        
        
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
        controller.DrawRandomPuzzles(thebackgroundImage,choosenLevel: level)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

