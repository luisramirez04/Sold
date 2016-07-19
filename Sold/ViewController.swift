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
import pop

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    let loginView = FBSDKLoginButton()
    var groupsArray = []
    var groupNames = [""]
    var groupDict = [String: UIButton]()
    var currentGroupID = ""
    var firstMatchOnly = true
    
    var animEngine: AnimationEngine!
    
    @available(iOS 8.0, *)
    func displayAlert(title messageTitle: String, message alertMessage: String) {
        let alert = UIAlertController(title: messageTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    
    @IBOutlet weak var firstMatchLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var searchTFTopConst: NSLayoutConstraint!
    @IBOutlet weak var firstMatchSwitchConst: NSLayoutConstraint!
    @IBOutlet weak var groupsCenterConst: NSLayoutConstraint!
    @IBOutlet weak var welcomeCenterConst: NSLayoutConstraint!
    @IBAction func firstMatchSwitchAction(sender: AnyObject) {
        if firstMatchOnly == true {
            firstMatchOnly = false
        } else if firstMatchOnly == false {
            firstMatchOnly = true
        }
    }
    @IBOutlet weak var firstMatchSwitchOutlet: UISwitch!
    @IBOutlet weak var firstMatchLabel: UILabel!
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var groupsStack: UIStackView!
    @IBOutlet weak var groupsLabel: UILabel!
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchLabel: UIButton!
    
    
    @IBAction func search(sender: AnyObject) {
        if currentGroupID == "" || searchTF.text == "" {
            displayAlert(title: "Error", message: "Please click on a group and enter a comment to search for.")
        } else {
            self.performSegueWithIdentifier("searchSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.animEngine = AnimationEngine(constraints: [searchTFTopConst, groupsCenterConst, welcomeCenterConst, firstMatchSwitchConst, firstMatchLabelTopConst])
        
            firstMatchSwitchOutlet.hidden = true
            firstMatchLabel.hidden = true
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
                        
                        let button = UIButton(type: UIButtonType.RoundedRect)
                        button.backgroundColor = UIColor(red: 0.816, green: 0.431, blue: 0.988, alpha: 1)
                        button.layer.cornerRadius = 5.0
                        button.tintColor = UIColor.blackColor()
                        button.setTitle(itemName as! String, forState: UIControlState.Normal)
                        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 10.0)
                        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
                        self.groupDict[item["id"] as! String] = button
                        
                    }
                    
                }
                
                for (ids, buttons) in self.groupDict {
                    
                    self.groupsStack.userInteractionEnabled = true
                    self.groupsStack.exclusiveTouch = true
                    self.groupsStack.addArrangedSubview(buttons)
                    let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonAction))
                    recognizer.delegate = self
                    buttons.addGestureRecognizer(recognizer)
                }
                
                
            }
            
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    func buttonAction(recognizer: UITapGestureRecognizer) {
        
        let senderButton = recognizer.view as! UIButton
        
        
        for (id, btns) in self.groupDict {
            if senderButton.currentTitle == btns.currentTitle {
                currentGroupID = id
                btns.backgroundColor = UIColor(red: 0.443, green: 0.988, blue: 0.749, alpha: 1.0)
            } else if senderButton.currentTitle != btns.currentTitle {
                btns.backgroundColor = UIColor(red: 0.816, green: 0.431, blue: 0.988, alpha: 1)
            }
        }
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
            self.animEngine.animateOnScreen(1)
            groupsLabel.hidden = false
            groupsStack.hidden = false
            phraseLabel.hidden = false
            searchTF.hidden = false
            searchLabel.hidden = false
            firstMatchSwitchOutlet.hidden = false
            firstMatchLabel.hidden = false
            loginView.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 50)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "searchSegue" {
            
            if let NavCon = segue.destinationViewController as? UINavigationController {
                let destination = NavCon.topViewController as! SearchResultsTableViewController
                destination.searchTerm = searchTF.text!
                destination.groupID = currentGroupID
                destination.firstMatchOnly = firstMatchOnly
                
            }
        }
    }


}

