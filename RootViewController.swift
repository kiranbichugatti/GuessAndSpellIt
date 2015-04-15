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
    var togglestate = 1
    
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
//        if(backgroundMusicPlayer.playing == true)
//        {
//            backgroundMusicPlayer.stop()
//            backgroundMusicPlayer.currentTime = 0
//        }
//        else
//        {
//        backgroundMusicPlayer.numberOfLoops = -1
//            backgroundMusicPlayer.prepareToPlay()
//            backgroundMusicPlayer.play()
//            
//        }
        
            }

    @IBOutlet weak var background: UIImageView!
    @IBAction func pauseButton(sender: UIButton) {
//
//        if sender.titleLabel!.text == "Pause"
//        {
//            sender.titleLabel!.text = "Play"
//            backgroundMusicPlayer.stop()
//           
//            
//        }
//        else
//        {
//            sender.titleLabel!.text = "Pause"
//            backgroundMusicPlayer.play()
//        }
//
        //pauseBackgroundMusic()
        if togglestate == 1 {
            backgroundMusicPlayer.play()
            togglestate = 2
            sender.setImage(UIImage(named:"pauseButton.jpg"),forState:UIControlState.Normal)
        } else {
            backgroundMusicPlayer.pause()
            togglestate = 1
            sender.setImage(UIImage(named:"playButton.png"),forState:UIControlState.Normal)
        }
    
        
    }

    override func viewDidLoad() {
        
        playBackgroundMusic("titlescreen.mp3")
        
//        let yourImage = UIImage(named: "frontscreen.jpg")
//        
//        let imageview = UIImageView(image: yourImage)
//        self.view.addSubview(imageview)
        
        
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
