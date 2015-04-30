//
//  RootViewController.swift
//  GuessAndSpell
//
//  Created by uics1 on 3/29/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit
import AVFoundation

class RootViewController: UIViewController {
    
    var backgroundMusicPlayer: AVAudioPlayer!
    var togglestate = 2
    var delegate : AppDelegate?

    
//    func playBackgroundMusic(filename: String) {
//        let url = NSBundle.mainBundle().URLForResource(
//            filename, withExtension: nil)
//        if (url == nil) {
//            println("Could not find file: \(filename)")
//            return
//        }
//        
//        var error: NSError? = nil
//        backgroundMusicPlayer =
//            AVAudioPlayer(contentsOfURL: url, error: &error)
//        if backgroundMusicPlayer == nil {
//            println("Could not create audio player: \(error!)")
//            return
//        }
//        
//        backgroundMusicPlayer.numberOfLoops = -1
//        backgroundMusicPlayer.prepareToPlay()
//        backgroundMusicPlayer.play()
//    }
    
    
    @IBAction func pauseButton(sender: UIButton) {
        
        
        
                if delegate?.backgroundMusicPlayer.playing == false{
            delegate?.backgroundMusicPlayer.play()
            sender.setImage(UIImage(named:"playButton.jpg"),forState:UIControlState.Normal)
        } else {
            
            delegate?.backgroundMusicPlayer.pause()
            sender.setImage(UIImage(named:"pauseButton.jpg"),forState:UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        delegate?.playBackgroundMusic("titlescreen.mp3");
        
       // playBackgroundMusic("titlescreen.mp3")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
