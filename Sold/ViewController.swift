//
//  ViewController.swift
//  Sold
//
//  Created by Luis Ramirez on 7/5/16.
//  Copyright © 2016 Luis Ramirez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

    let loginView = FBSDKLoginButton()
    var groupsArray = []
    var groupNames = [""]
    var groupDict = [String: UIButton]()

    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var groupsStack: UIStackView!
    @IBOutlet weak var groupsLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchLabel: UIButton!
    @IBAction func search(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
            groupsLabel.hidden = true
            groupsStack.hidden = true
            phraseLabel.hidden = true
            searchTF.hidden = true
            searchLabel.hidden = true
        
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "user_friends", "user_photos", "user_managed_groups"]
            self.view.addSubview(loginView)
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if error == nil {
                
                let userName = result["name"] as! String
                self.welcome.text = "Welcome \(userName)"
                
            }
            
        }
        
        FBSDKGraphRequest.init(graphPath: "me/groups", parameters: ["fields":"name"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if error == nil {
                
                self.groupNames.removeAll(keepCapacity: true)
                
                self.groupsArray = result["data"] as! NSArray
                
                for item in self.groupsArray { // loop through data items
                    
                    if let itemName = item["name"]! {
                        
                        let button = UIButton()
                        button.setTitle(itemName as! String, forState: UIControlState.Normal)
                        /*let view1 = UIView()
                        view1.addSubview(button) */
                        self.groupDict[item["id"] as! String] = button
                        
                    }
                    
                }
                
                
            }
            
            for (_ , buttons) in self.groupDict {
                
                self.groupsStack.addArrangedSubview(buttons)
            }
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                if error != nil {
                    print(error)
                } else if error == nil {
                    
                    let userName = result["first_name"] as! String
                    self.welcome.text = "Welcome \(userName)"
                    
                }
                
            }
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            groupsLabel.hidden = false
            groupsStack.hidden = false
            phraseLabel.hidden = false
            searchTF.hidden = false
            searchLabel.hidden = false
            loginView.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 50)
            
        }
    }


}

