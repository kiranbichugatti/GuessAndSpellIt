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

    
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var hintImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var thebackgroundImage: UIImageView!
    @IBOutlet weak var remainingReveal: UILabel!
    @IBOutlet var theRevealButtons: [UIButton]!
    @IBOutlet weak var RevealHint: UIButton!
    @IBOutlet weak var removeHint: UIButton!
    @IBOutlet weak var correctHint: UIButton!
    @IBOutlet weak var flashHint: UIButton!
    
    var selectCount: Int = 0 {
        didSet { 
            remainingReveal.text = "Remaining Reveals: \(5 - selectCount)"
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
           UIView.animateWithDuration(0.8,
                delay:0.01,
                options:UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    
                    let newPoint = CGPointMake(buttonAtIndex.center.x,
                        buttonAtIndex.center.y - 70)

                    println("point is: \(newPoint)")
                    buttonAtIndex.center = newPoint
                },
                completion: {
                    (value:Bool) in
                    self.theRevealButtons[buttonIndex].hidden = true
            })
            //animateButton(buttonAtIndex)
            
            selectCount++
        }
        
    }
    

    @IBAction func flashHintTouched(sender: UIButton) {
        var left = controller.flash()
        var timer = NSTimer()
        for but in theRevealButtons {
            UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                but.alpha = 0.7
                }, completion: {
                    (value:Bool) in
                    but.alpha = 1.0
            })
        }
        sender.setTitle(toString(left), forState: UIControlState.Normal)
        if left == 0 {sender.enabled = false}
    }

    
    func startNewPuzzle() {
        controller.currentPuzzle += 1
        if controller.currentPuzzle > level.puzzles.count {
            initNewLevel()
            controller.currentPuzzle = 1
        }
        controller.DrawRandomPuzzles(thebackgroundImage)
        
        for button in theRevealButtons {
            button.hidden = false
            button.enabled = true
        }
        selectCount = 0
        updateGUI()
        //controller.returntempLevelData()
    }
    
    func initNewLevel(){
        if controller.currentLevel < 3 {
            controller.currentLevel = controller.currentLevel + 1
            level = Level(levelNumber:controller.currentLevel)
            controller.level = level
            controller.tempLevelData = NSMutableArray(array: level.puzzles)
        } else {
            //all game is finished. Congrats!
        }
    }
    
    //we need this to update the reveal info and hints.
    func updateGUI(){
        
        if (controller.isMatched){
            
            //remove all the buttons on the image, we can add some effect later
            for button in theRevealButtons {
                UIView.animateWithDuration(1.0, animations:{
                    button.hidden = true
                })
                
            }
            
            scoreLabel.text = "Score: \(controller.currentScore())"
            
            var tempuser = User?()
            tempuser = User()
            let balance: AnyObject? = controller.currentScore()
            
            //use var instead of let
            var mybalance = balance as NSNumber
            tempuser?.updateUserWithScore(mybalance)
            
        }
        progress.text = "Level \(controller.currentLevel)/\(controller.currentPuzzle)"
        
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
    
    func setupGUI() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        hintImage.backgroundColor = UIColor(patternImage: UIImage(named: "hint.png")!)
        progress.text = "Level \(controller.currentLevel)/\(controller.currentPuzzle)"
        
        
        // theImageView.layer.contents = UIImage(named: "chair.jpg")?.CGImage
        thebackgroundImage.layer.cornerRadius = 8.0
        thebackgroundImage.clipsToBounds = true
        
        //add one layer for all game elements
        self.view.addSubview(gameView)
        controller.gameView = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.viewControllerInstance = self
        controller.onPuzzleSolved =  self.startNewPuzzle
        
        self.initNewLevel()
        //self.startNewPuzzle()
        self.updateUserDetails()
        
        updateGUI()
        setupGUI()
        
    }
    
    func updateUserDetails(){
        
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if(delegate?.presentUser != nil){
            var dict = delegate?.presentUser
            // Setting the Current User Name
            let userName : AnyObject? = dict?.objectForKey("userName")
            var names = userName as NSString
            userLabel.text = "Hi: \(names)"
            
            
            //
            
            //      Get present Game Level
//            let level: AnyObject? = dict?.objectForKey("presentLevel")
//            var presentLevel = level as NSNumber
//            println("Present Level ===== \(presentLevel)")
            //
            // setting user current Score
            let balance: AnyObject? = dict?.objectForKey("score")
            
            var mybalance = balance as NSNumber
            controller.score = mybalance.integerValue
            scoreLabel.text = "Score: \(controller.currentScore())"
            
            let levels: AnyObject? = dict?.objectForKey("presentLevel")
            
         //   var presentLevels = levels as NSNumber
          //  totalLevels.text = "Present Level: \(presentLevels)"
            
            //
        }
        else{
            userLabel.text = "Hi Guest"
            //totalLevels.text = ""
        }
    }

    @IBAction func homeButton(sender: UIButton) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func pauseButton(sender: UIButton) {
        //let vc:ViewController = RootViewController()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.startNewPuzzle()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

