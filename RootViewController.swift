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
    
       func playBackgroundMusic(filename: String) {
                let url = NSBundle.mainBundle().URLForResource(
                    filename, withExtension: nil)
                if (url == nil) {
                        println("Could not find file: \(filename)")
                        return
                    }
        
                var error: NSError? = nil
                backgroundMusicPlayer =
                    AVAudioPlayer(contentsOfURL: url, error: &error)
             if backgroundMusicPlayer == nil {
                        println("Could not create audio player: \(error!)")
                        return
                    }
        
                backgroundMusicPlayer.numberOfLoops = -1
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
            }
        func pauseBackgroundMusic()
        {
            if(backgroundMusicPlayer.playing == true)
            {
                backgroundMusicPlayer.stop()
                backgroundMusicPlayer.currentTime = 0
            }
            else
            {
            backgroundMusicPlayer.numberOfLoops = -1
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
    
            }
        }
    
    
            
    
        
          override func viewDidLoad() {
            
                    playBackgroundMusic("titlescreen.mp3")
            
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
