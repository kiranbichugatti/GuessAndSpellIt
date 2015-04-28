//
//  HighscoreController.swift
//  GuessAndSpell
//
//  Created by nivedita bhat on 4/26/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit
import QuartzCore

class HighscoreController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var users : NSArray?
    
    var ListCell : ListUserCell?
    @IBOutlet weak var UserList: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count : Int = users!.count
        if(count<=5){
            return users!.count
        }
        else{
            return 5;
        }
    }
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell: ListUserCell = tableView.dequeueReusableCellWithIdentifier("cell") as! ListUserCell
        tableView.backgroundColor = UIColor.clearColor();
        cell.backgroundColor = UIColor.clearColor();
        
        var dict : NSDictionary?
        dict = NSDictionary()
        
        dict = users?.objectAtIndex(indexPath.row) as? NSDictionary
        
        var player : NSString?
        player = dict?.objectForKey("userName") as? NSString
        
        cell.name.text = player as? String
        cell.score.text = String(format:"Score : %@",dict?.objectForKey("score") as! NSNumber)
        
        return cell;
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        getUsers()
    }
    
    func getUsers(){
        var tempuser = User?()
        tempuser = User()
        
        users = NSArray()
        users = tempuser?.getAllUsers()
        
        UserList.delegate=self;
        UserList.dataSource = self;
        UserList.reloadData()
    }
}
