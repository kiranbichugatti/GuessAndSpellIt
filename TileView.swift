//
//  TileView.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 3/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import UIKit

class TileView:UIImageView {
    
    var letter:Character
    var sideLength:CGFloat
    
    init(letter:Character) {
        self.letter = letter
        //we only need a fixed length for our tile
        self.sideLength = 40.0
        
        let image = UIImage(named:"tile")!
        super.init(image:image)
        
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
        
        //add a letter on top
        let letterLabel = UILabel(frame: self.bounds)
        letterLabel.textAlignment = NSTextAlignment.Center
        letterLabel.textColor = UIColor.blackColor()
        letterLabel.backgroundColor = UIColor.clearColor()
        letterLabel.text = String(letter).uppercaseString
        letterLabel.font = UIFont(name: "Verdana-Bold", size: 78.0*scale)
        self.addSubview(letterLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
