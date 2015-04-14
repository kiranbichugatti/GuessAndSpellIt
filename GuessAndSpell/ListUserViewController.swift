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
        let base64: String? = dict?.objectForKey("pic") as? String
        
        var decodedData = NSData(base64EncodedString: base64!, options: NSDataBase64DecodingOptions(0))
        
        var decodedimage = UIImage(data: decodedData!)
        
        var name : NSString?
        name = dict?.objectForKey("userName") as? NSString
        
        var score : NSNumber?
        score = dict?.objectForKey("score") as? NSNumber
        let s:String = String(format:"%@ ----------------------------->   %@",name!, score!)
        cell_?.textLabel?.text = s;
        cell_?.imageView?.image = decodedimage;
        
        return cell_!
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        delegate?.presentUser = users?.objectAtIndex(indexPath.row) as? NSDictionary
        
        
        
        let dict = delegate?.presentUser
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    
    var tempuser = User?()
    tempuser = User()
    
    users = NSArray()
    users = tempuser?.getAllUsers()
    
    UserList.delegate=self;
    UserList.dataSource = self;
    UserList.reloadData()

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
