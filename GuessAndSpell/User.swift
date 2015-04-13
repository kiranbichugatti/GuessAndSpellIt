//
//  User.swift
//  GuessAndSpell
//
//  Created by uics1 on 4/11/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit

class User: NSObject {
   
    func userInput(name : NSString, pic : UIImage){
        var tempUserArray :NSMutableArray?
        tempUserArray = NSMutableArray();
        if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
            tempUserArray?.addObjectsFromArray(NSUserDefaults.standardUserDefaults().objectForKey("users") as NSMutableArray);
        }
        
        var tempDict : NSMutableDictionary?
        tempDict = NSMutableDictionary()
        
        tempDict?.setObject(NSNumber(int: 0), forKey: "score")
        tempDict?.setObject(name, forKey: "userName")
        
        var image : UIImage = pic
        var imageData = UIImagePNGRepresentation(image)
        let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        tempDict?.setObject(base64String, forKey: "pic")
        
        tempUserArray?.addObject(tempDict!)
        
        NSUserDefaults.standardUserDefaults().setObject(tempUserArray, forKey: "users")
    }
    
    func getAllUsers()->NSArray{
        
        var users : NSMutableArray?
        users = NSMutableArray()
        if((NSUserDefaults.standardUserDefaults().objectForKey("users")) != nil){
            let tempArr : NSArray  = NSUserDefaults.standardUserDefaults().objectForKey("users") as NSArray
            users?.addObjectsFromArray(tempArr)
        }
        
//        let firstNameSortDescriptor = NSSortDescriptor(key: "score", ascending: true, selector: "localizedStandardCompare:")
//        let sortedByAge = (users as NSArray).sortedArrayUsingDescriptors([firstNameSortDescriptor])
//        
////        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "score", ascending: true)
////        var sortedResults: NSMutableArray = users?.sortedArrayUsingDescriptors(descriptor)
////        
////        var sortedResults= users.sorted {
////            (dictOne) -> Bool in
////            // put your comparison logic here
////            return dictOne["name"]! > dictTwo["name"]!
////        }
        
        return users!
    }
    
}
