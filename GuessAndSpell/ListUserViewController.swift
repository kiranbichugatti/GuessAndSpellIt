//
//  ListUserViewController.swift
//  GuessAndSpell
//
//  Created by uics1 on 3/31/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit

class ListUserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var users : NSArray?
    
    @IBOutlet weak var UserList: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (users as NSMutableArray).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell_ : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if(cell_ == nil)
        {
            cell_ = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        var dict : NSDictionary?
        dict = NSDictionary()
        
        dict = users?.objectAtIndex(indexPath.row) as? NSDictionary
        
        var image : UIImage?
        let base64: AnyObject? = dict?.objectForKey("pic")
        
        let decodedData = NSData(base64EncodedString: base64, options: NSDataBase64DecodingOptions.fromRaw(0)!)
        var decodedimage = UIImage(data: decodedData)
        
        var name : NSString?
        name = dict?.objectForKey("username") as? NSString
        
        cell_?.textLabel?.text = name;
        cell_?.imageView?.image = image;
        
        return cell_!
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tempuser = User?()
        tempuser = User()
        
        users = NSArray()
        users = tempuser?.getAllUsers()
        
        UserList.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
