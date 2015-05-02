//
//  ModalViewController.swift
//  GuessAndSpell
//
//  Created by uicsi8 on 5/1/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBAction func donePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
