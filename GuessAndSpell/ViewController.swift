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
    @IBOutlet weak var leftArrow: UIImageView!

    
    var selectCount: Int = 0 {
        didSet { 
            remainingReveal.text = "\(5 - selectCount)"
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
        leftArrow.hidden = false
        
        let delay = 3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self.leftArrow.hidden = true
        })
        
        sender.setTitle(toString(left), forState: UIControlState.Normal)
        if left == 0 {sender.enabled = false}
        if left >= 0 {selectCount--}
        
        scoreLabel.text = "Score: \(controller.currentScore())"
        
    }


    @IBAction func RemoveLetterPressed(sender: UIButton) {
        let removeLeft = controller.getRidOfBadLetter()
        sender.setTitle(toString(removeLeft), forState: UIControlState.Normal)
        if removeLeft == 0 { sender.enabled = false }
        
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

                    buttonAtIndex.center = newPoint
                },
                completion: {
                    (value:Bool) in
                    self.theRevealButtons[buttonIndex].hidden = true
            })
            
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
            if controller.currentLevel == 3 {
                var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var vc : ModalViewController = storyBoard.instantiateViewControllerWithIdentifier("modalView") as! ModalViewController
                self.presentViewController(vc, animated: true, completion: nil)
                return
            }
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
    }
    
    func initNewLevel(){
        
        if controller.currentLevel < 3 {
            controller.currentLevel = controller.currentLevel + 1
            level = Level(levelNumber:controller.currentLevel)
            controller.level = level
            
            var delegate : AppDelegate?
            delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            var dict = delegate?.presentUser
            if(delegate?.presentUser == nil)
           {
            controller.tempLevelData = NSMutableArray(array: level.puzzles)
            }
            else
            {
                
            var tempArr:NSArray  =  dict?.objectForKey("levelData") as! NSArray
            
            if(tempArr.count > 0)
            {
               controller.tempLevelData = NSMutableArray(array: tempArr)
                
            }
            else
            {
              controller.tempLevelData = NSMutableArray(array: level.puzzles)
                
            }
            }
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
            var mybalance = balance as! NSNumber
            
            var tempuserData = controller.tempLevelData as NSArray
            let tempLevel : AnyObject? = controller.currentLevel - 1
            let tempPuzzle : AnyObject? = controller.currentPuzzle 
            let tempindex : AnyObject? = controller.currentPuzzleIndex() 
            
            var Level = tempLevel as! NSNumber
            var puzzel = tempPuzzle as! NSNumber
            var index = tempindex as! NSNumber
            
            tempuser?.updateUserWithScore(mybalance, index: index, puzzle: puzzel, level: Level, levelData: tempuserData)
            
        }
        progress.text = "Level \(controller.currentLevel)/\(controller.currentPuzzle)"
        
    }
    
    //detect touch, if it's in range of target tile, bring it back to original place
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch : UITouch = touches.first as! UITouch
        let location = touch.locationInView(self.view)

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
        leftArrow.hidden = true
        
        //add one layer for all game elements
        self.view.addSubview(gameView)
        controller.gameView = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUserDetails()
        
        updateGUI()
        setupGUI()
        
        controller.viewControllerInstance = self
        controller.onPuzzleSolved =  self.startNewPuzzle
        
        self.initNewLevel()
        self.startNewPuzzle()
        
    }
    
    func updateUserDetails(){
        
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if(delegate?.presentUser != nil){
            var dict = delegate?.presentUser
            // Setting the Current User Name
            let userName : AnyObject? = dict?.objectForKey("userName")
            var names = userName as! NSString
            userLabel.text = "Hi: \(names)"

            // setting user current Score
            let balance: AnyObject? = dict?.objectForKey("score")
            
            var mybalance = balance as! NSNumber
            controller.score = mybalance.integerValue
            scoreLabel.text = "Score: \(controller.currentScore())"
            
            let levell: AnyObject? = dict?.objectForKey("currentLevel")
            var myLevel = levell as! NSNumber
            
            controller.currentLevel = myLevel.integerValue
//            println(controller.currentLevel)
            
            let puzzle : AnyObject? = dict?.objectForKey("currentPuzzle")
            var myPuzzle = puzzle as! NSNumber
            
            controller.currentPuzzle = myPuzzle.integerValue
            
            controller.tempLevelData = dict?.objectForKey("levelData") as? NSMutableArray
            
        }
        else{
            userLabel.text = "Hi Guest"
        }
    }

    @IBAction func homeButton(sender: UIButton) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func pauseButton(sender: UIButton) {
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if delegate?.backgroundMusicPlayer.playing == false{
            delegate?.backgroundMusicPlayer.play()
           // sender.setImage(UIImage(named:"pauseButton.jpg"),forState:UIControlState.Normal)
        } else {
            
            delegate?.backgroundMusicPlayer.pause()
            //sender.setImage(UIImage(named:"playButton.jpg"),forState:UIControlState.Normal)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {

      //  println(controller.currentPuzzleIndex())
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

