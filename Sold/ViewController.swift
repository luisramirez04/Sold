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

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    let loginView = FBSDKLoginButton()
    var groupsArray = []
    var groupNames = [""]
    var groupDict = [String: UIButton]()
    var currentGroupID = ""
    var fromDate = String()
    var toDate = String()
    var dateFormatter = NSDateFormatter()
    
    
    @available(iOS 8.0, *)
    func displayAlert(title messageTitle: String, message alertMessage: String) {
        let alert = UIAlertController(title: messageTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

    @IBAction func toDateChanged(sender: AnyObject) {
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        toDate = dateFormatter.stringFromDate(toDatePicker.date)
        print(toDate)
    }
    @IBAction func fromDateChanged(sender: AnyObject) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        fromDate = dateFormatter.stringFromDate(fromDatePicker.date)
        print(fromDate)
    }
    
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var fromLabel: UILabel!
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
        
            groupsLabel.hidden = true
            groupsStack.hidden = true
            phraseLabel.hidden = true
            searchTF.hidden = true
            searchLabel.hidden = true
            toLabel.hidden = true
            toDatePicker.hidden = true
            fromLabel.hidden = true
            fromDatePicker.hidden = true
        
            dateFormatter.dateFormat = "dd-MM-yyyy"
            toDate = dateFormatter.stringFromDate(toDatePicker.date)
            fromDate = dateFormatter.stringFromDate(fromDatePicker.date)
        
        
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
                        button.setTitle(itemName as! String, forState: UIControlState.Normal)
                        /*let view1 = UIView()
                        view1.addSubview(button) */
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
        senderButton.backgroundColor = UIColor.blueColor()
        
        for (id, btns) in self.groupDict {
            if senderButton.currentTitle == btns.currentTitle {
                currentGroupID = id
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
            groupsLabel.hidden = false
            groupsStack.hidden = false
            phraseLabel.hidden = false
            searchTF.hidden = false
            searchLabel.hidden = false
            toLabel.hidden = false
            toDatePicker.hidden = false
            fromLabel.hidden = false
            fromDatePicker.hidden = false
            loginView.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 50)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "searchSegue" {
            
            if let destination = segue.destinationViewController as? SearchResultsTableViewController {
                destination.fromDate = fromDate
                destination.toDate = toDate
                destination.searchTerm = searchTF.text!
                destination.groupID = currentGroupID
                
            }
        }
    }


}

