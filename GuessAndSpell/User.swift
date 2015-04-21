//
//  User.swift
//  GuessAndSpell
//
//  Created by uics1 on 4/11/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit

class User: NSObject {
    
    func userInput(name : NSString){
        var tempUserArray :NSMutableArray?
        tempUserArray = NSMutableArray();
        if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
            tempUserArray?.addObjectsFromArray(NSUserDefaults.standardUserDefaults().objectForKey("users") as NSMutableArray);
        }
        
        var tempDict : NSMutableDictionary?
        tempDict = NSMutableDictionary()
        
        tempDict?.setObject(NSNumber(int: 0), forKey: "score")
        tempDict?.setObject(name, forKey: "userName")
        
//        var image : UIImage = pic
//        var imageData = UIImagePNGRepresentation(image)
//        let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
//        // tempDict?.setObject(base64String, forKey: "pic")
        
        tempUserArray?.addObject(tempDict!)
        
        NSUserDefaults.standardUserDefaults().setObject(tempUserArray, forKey: "users")
    }
    
    func getAllUsers()->NSArray{
        
        var users : NSArray?
        users = NSArray()
        if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
            users  = NSUserDefaults.standardUserDefaults().objectForKey("users") as? NSArray
        }
        
        var descriptor = NSSortDescriptor(key: "score", ascending: true)
        var sortedResults: NSArray = users!.sortedArrayUsingDescriptors([descriptor])
        
        return sortedResults
    }
    
    func updateUserWithScore(score : NSNumber){
        
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if((delegate?.presentUser) != nil){
            var tempUserArray :NSMutableArray?
            tempUserArray = NSMutableArray();
            if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
                tempUserArray?.addObjectsFromArray(NSUserDefaults.standardUserDefaults().objectForKey("users") as NSMutableArray);
            }
            
            var presetDict = delegate?.presentUser
            
            var dict : NSMutableDictionary!
            dict = NSMutableDictionary ()
            
            dict.addEntriesFromDictionary(presetDict!)
            
            tempUserArray?.removeObject(presetDict!)
            
            dict.setObject(score, forKey: "score")
            
            tempUserArray?.addObject(dict)
            
            delegate?.presentUser = dict as NSDictionary
            
            NSUserDefaults.standardUserDefaults().setObject(tempUserArray, forKey: "users")
        }
        
    }
    
}
