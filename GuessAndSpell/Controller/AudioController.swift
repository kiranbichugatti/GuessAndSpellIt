//
//  AudioController.swift
//  GuessAndSpell
//
//  Created by nivedita bhat on 4/11/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {
    private var audio = [String:AVAudioPlayer]()
    
    func preloadAudioEffects(effectFileNames:[String]) {
        for effect in AudioEffectFiles {
            //1 get the file path URL
            let soundPath = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent(effect)
            let soundURL = NSURL.fileURLWithPath(soundPath)
            
            //2 load the file contents
            var loadError:NSError?
            let player = AVAudioPlayer(contentsOfURL: soundURL, error: &loadError)
            assert(loadError == nil, "Load sound failed")
            
            //3 prepare the play
            player.numberOfLoops = 0
            player.prepareToPlay()
            
            //4 add to the audio dictionary
            audio[effect] = player
        }
    }
    
    func playEffect(name:String) {
        if let player = audio[name] {
            if player.playing {
                player.currentTime = 0
            } else {
                player.play()
            }
        }
    }
    
}
