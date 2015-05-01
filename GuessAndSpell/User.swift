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
            tempUserArray?.addObjectsFromArray(NSUserDefaults.standardUserDefaults().objectForKey("users") as! NSMutableArray as [AnyObject]);
        }
        
        var tempDict : NSMutableDictionary?
        tempDict = NSMutableDictionary()
        
        tempDict?.setObject(NSNumber(int: 0), forKey: "score")
        tempDict?.setObject(name, forKey: "userName")
        tempDict?.setObject(NSNumber(int: 0), forKey: "currentIndex")
        tempDict?.setObject(NSNumber(int: 0), forKey: "currentPuzzle")
        tempDict?.setObject(NSNumber(int: 0), forKey: "currentLevel")
        
        var tempArr : NSArray!
        tempArr = NSArray()
        
        tempDict?.setObject(tempArr, forKey: "levelData")
        
        tempUserArray?.addObject(tempDict!)
        
        NSUserDefaults.standardUserDefaults().setObject(tempUserArray, forKey: "users")
    }
    
    func getAllUsers()->NSArray{
        
        var users : NSArray?
        users = NSArray()
        if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
            users  = NSUserDefaults.standardUserDefaults().objectForKey("users") as? NSArray
        }
        
        var descriptor = NSSortDescriptor(key: "score", ascending: false)
        var sortedResults: NSArray = users!.sortedArrayUsingDescriptors([descriptor])
        
        return sortedResults
    }
    
    func updateUserWithScore(score : NSNumber, index: NSNumber, puzzle : NSNumber, level : NSNumber, levelData : NSArray){
        
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if((delegate?.presentUser) != nil){
            var tempUserArray :NSMutableArray?
            tempUserArray = NSMutableArray();
            if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
                tempUserArray?.addObjectsFromArray(NSUserDefaults.standardUserDefaults().objectForKey("users") as! NSMutableArray as [AnyObject]);
            }
            
            var presetDict = delegate?.presentUser
            
            var dict : NSMutableDictionary!
            dict = NSMutableDictionary ()
            
            dict.addEntriesFromDictionary(presetDict! as [NSObject : AnyObject])
            
            for var i = 0; i < tempUserArray?.count; i++
            {
                var temp = tempUserArray?.objectAtIndex(i) as! NSDictionary
                
                let x: NSString? = temp.objectForKey("userName") as? NSString
                let y: NSString? = presetDict?.objectForKey("userName") as? NSString
                if x == y{
                    tempUserArray?.removeObject(temp)
                }
            }
            
           // tempUserArray?.removeObject(presetDict!)
            
            dict.setObject(score, forKey: "score")
            dict.setObject(index, forKey: "currentIndex")
            dict.setObject(puzzle, forKey: "currentPuzzle")
            dict.setObject(level, forKey: "currentLevel")
            dict.setObject(levelData, forKey: "levelData")
            tempUserArray?.addObject(dict)
            
            delegate?.presentUser = dict as NSDictionary
            
            println("\n\nUpdated UserDetaults Data = \(tempUserArray)\n\n")
            
            NSUserDefaults.standardUserDefaults().setObject(tempUserArray, forKey: "users")
        }
        
    }
    
}
