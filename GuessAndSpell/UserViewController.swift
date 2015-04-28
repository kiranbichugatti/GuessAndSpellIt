//
//  UserViewController.swift
//  GuessAndSpell
//
//  Created by uics1 on 3/30/15.
//  Copyright (c) 2015 uics1. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var UserName: UITextField!
    
    
    
  //  @IBOutlet weak var ProPic: UIImageView!
    
    
    
    
//    @IBAction func ChoosePic(sender: AnyObject) {
//        
//    var picker = UIImagePickerController()
//        
//    picker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//    picker.delegate = self
//    self.presentViewController(picker,animated: true,completion: nil)
//        
//        
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!)
//    
//    {
//        var imagePicked : UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
//        ProPic.image = imagePicked
//        self.dismissViewControllerAnimated(true,completion: nil)
//    }
//    
    

    
    
    
    @IBAction func SaveUser(sender: UIButton) {
        
        var usr : User?
        usr = User()
        var length = count(UserName.text)
        if(length<1)
        {
            let alert = UIAlertView()
            alert.title = "Invalid"
            alert.message = "Please enter your name"
            alert.addButtonWithTitle("OK")
            alert.show()
            
        }
        else
        {
        usr?.userInput(UserName.text)
        
        self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        

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
