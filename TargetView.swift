//
//  TargetView.swift
//  GuessAndSpell
//
//  Created by nivedita bhat on 3/30/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import Foundation
import UIKit


class TargetView: UIImageView {
    var letter: Character
    var isMatched:Bool = false
    
    //this should never be called
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    
    init(letter:Character) {
        
        self.letter = letter
        //println("target view letter \(self.letter)")
        
        let image = UIImage(named: "target")!
        super.init(image:image)
        
        let scale = TargetSideLength / image.size.width
        self.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)
    }
}
