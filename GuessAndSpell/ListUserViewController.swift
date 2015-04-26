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
    
   var ListCell : ListUserCell?
    
    @IBAction func playGuest(sender: UIButton) {
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        delegate?.presentUser = nil;
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("gamecontroller") as ViewController
        
        self.navigationController!.pushViewController(profileViewController, animated: true)
        

    }
    @IBOutlet weak var UserList: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
    var cell: ListUserCell = tableView.dequeueReusableCellWithIdentifier("TCell") as ListUserCell
        
      //  cell.backgroundColor = [UIColor clearColor];
        tableView.backgroundColor = UIColor.clearColor();
        cell.backgroundColor = UIColor.clearColor();
        
        var dict : NSDictionary?
        dict = NSDictionary()
        
        dict = users?.objectAtIndex(indexPath.row) as? NSDictionary
        
        //        var image : UIImage?
        //        let base64: String? = dict?.objectForKey("pic") as? String
        //
        //        var decodedData = NSData(base64EncodedString: base64!, options: NSDataBase64DecodingOptions(0))
        //
        //        var decodedimage = UIImage(data: decodedData!)
        
        var player : NSString?
        player = dict?.objectForKey("userName") as? NSString
      
       cell.name.text = player
       cell.score.text = String(format:"Score : %@",dict?.objectForKey("score") as NSNumber)
//        //cell_?.imageView?.image = decodedimage
     
   return cell;
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var delegate : AppDelegate?
        delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        delegate?.presentUser = NSDictionary()
        
        delegate?.presentUser = users?.objectAtIndex(indexPath.row) as? NSDictionary
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("gamecontroller") as ViewController
        
        self.navigationController!.pushViewController(profileViewController, animated: true)
        
        
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
