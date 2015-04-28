//
//  TileView.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import UIKit



protocol TileDragDelegateProtocol {
    func tileView(tileView:TileView,didDragToPoint:CGPoint, from:CGPoint)
    
}

class TileView:UIImageView {
    
    var letter:Character
    var sideLength:CGFloat
    var origin : CGPoint!
    
    var isMatched : Bool = false
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    
    var dragDelegate:TileDragDelegateProtocol?
    
    init(letter:Character) {
        self.letter = letter
        //we only need a fixed length for our tile
        self.sideLength = TileSideLength
       
        
        let image = UIImage(named:"tile")!
        super.init(image:image)
        
        //println(image.size.width)
        
        let scale = TileSideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
        
        //add a letter on top
        let letterLabel = UILabel(frame: self.bounds)
        letterLabel.textAlignment = NSTextAlignment.Center
        letterLabel.textColor = UIColor.blackColor()
        letterLabel.backgroundColor = UIColor.clearColor()
        letterLabel.text = String(letter).uppercaseString
        letterLabel.font = UIFont(name: "Verdana-Bold", size: 100.0*scale)
        self.addSubview(letterLabel)
        
        self.userInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Dragging option is provided for the tiles
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let point = touch.locationInView(self.superview)
        xOffset = point.x - self.center.x
        yOffset = point.y - self.center.y
        self.origin = self.center
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let point = touch.locationInView(self.superview)
        self.center = CGPointMake(point.x - xOffset, point.y - yOffset)
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.touchesMoved(touches, withEvent: event)
        dragDelegate?.tileView(self, didDragToPoint: self.center, from:self.origin)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.center = CGPointMake(xOffset, yOffset)
    }
    

}
