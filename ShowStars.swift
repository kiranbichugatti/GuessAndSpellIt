//
//  ShowStars.swift
//  GuessAndSpell
//
//  Created by nivedita bhat on 4/16/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class StardustView:UIView {
    private var emitter:CAEmitterLayer!
    
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        //initialize the emitter
        emitter = self.layer as CAEmitterLayer
        emitter.emitterPosition = CGPointMake(self.bounds.size.width/4, self.bounds.size.height/4)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = kCAEmitterLayerAdditive
        emitter.emitterShape = kCAEmitterLayerRectangle
    }
    
    override class func layerClass() -> AnyClass {
        //configure the UIView to have emitter layer
        return CAEmitterLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        
        //load the texture image
        let texture:UIImage? = UIImage(named:"particle")
        assert(texture != nil, "particle image not found")
        
        //create new emitter cell
        let emitterCell = CAEmitterCell()
        emitterCell.contents = texture!.CGImage
        emitterCell.name = "cell"
        emitterCell.birthRate = 600
        emitterCell.lifetime = 2.5
        emitterCell.blueRange = 0.50
        emitterCell.blueSpeed = -0.33
        emitterCell.yAcceleration = 100
        emitterCell.xAcceleration = -200
        emitterCell.velocity = 100
        emitterCell.velocityRange = 40
        emitterCell.scaleRange = 0.5
        emitterCell.scaleSpeed = -0.2
        emitterCell.emissionRange = CGFloat(M_PI*2)
        
        let emitter = self.layer as CAEmitterLayer
        emitter.emitterCells = [emitterCell]
    }
    
    func disableEmitterCell() {
        emitter.setValue(0, forKeyPath: "emitterCells.cell.birthRate")
    }
}

