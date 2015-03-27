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
    
    @IBOutlet weak var theImageView: UIView!
    @IBOutlet var theRevealButtons: [UIButton]!
    
    required init(coder aDecoder: NSCoder) {
        controller = GameController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        theImageView.layer.contents = UIImage(named: "chair.jpg")?.CGImage
        theImageView.layer.cornerRadius = 8.0
        theImageView.clipsToBounds = true
        
        //add one layer for all game elements
        let gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        
        let level2 = Level(levelNumber: 2)
        println("anagrams: \(level2.puzzles)")
        controller.level = level2
        controller.dealRandomAnagram()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

