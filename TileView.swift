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
    
    init(letter:Character) {
        self.letter = letter
        
        let image = UIImage(named:"tile")!
        super.init(image:image)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
