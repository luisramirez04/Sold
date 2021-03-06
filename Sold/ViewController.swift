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

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var secondMissingLabelCenterConst: NSLayoutConstraint!
    @IBOutlet weak var firstMissingLabelCenterConst: NSLayoutConstraint!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var groupsTableView: UITableView!
    var loginView = FBSDKLoginButton()
    var groupsArray = []
    var groupNames = [""]
    var groupIDs = [""]
    var currentGroupID = ""
    var firstMatchOnly = true
    var onlyByUser = true
    
    var animEngine: AnimationEngine!
    
    @IBAction func onlyByUserSwitchAction(sender: AnyObject) {
        if onlyByUser == true {
            onlyByUser = false
        } else if onlyByUser == false {
            onlyByUser = true
        }
    }
    @IBOutlet weak var onlyByUserSwitchOutlet: UISwitch!
    @IBOutlet weak var onlyByUserLabel: UILabel!
    @IBOutlet weak var searchButtonCenterXConst: NSLayoutConstraint!
    @IBOutlet weak var SearchTFCenterXConst: NSLayoutConstraint!
    @IBOutlet weak var PhraseLabelCenterXConst: NSLayoutConstraint!
    @IBOutlet weak var groupsLabelCenterXConst: NSLayoutConstraint!
    @IBOutlet weak var groupsTableCenterXConst: NSLayoutConstraint!
    @IBOutlet weak var welcomeCenterXConst: NSLayoutConstraint!
    @available(iOS 8.0, *)
    func displayAlert(title messageTitle: String, message alertMessage: String) {
        let alert = UIAlertController(title: messageTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

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
        
        searchTF.delegate = self
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        loginView.delegate = self
        self.navigationController?.navigationBar.hidden = true
            self.animEngine = AnimationEngine(constraints: [welcomeCenterXConst, SearchTFCenterXConst, groupsLabelCenterXConst, groupsTableCenterXConst, PhraseLabelCenterXConst, searchButtonCenterXConst, firstMissingLabelCenterConst, secondMissingLabelCenterConst])

            firstMatchSwitchOutlet.hidden = true
            firstMatchLabel.hidden = true
            groupsLabel.hidden = true
            groupsTableView.hidden = true
            phraseLabel.hidden = true
            searchTF.hidden = true
            searchLabel.hidden = true
            onlyByUserLabel.hidden = true
            onlyByUserSwitchOutlet.hidden = true
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "user_managed_groups"]
        
            self.view.addSubview(loginView)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = groupNames[row]
        cell.textLabel?.font = UIFont(name:"Avenir", size:16)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(colorLiteralRed: 0.996, green: 0.831, blue: 0.149, alpha: 0.7)
        cell.selectedBackgroundView = backgroundView

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let row = indexPath.row
        currentGroupID = groupIDs[row]
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        welcome.text = "Please login to continue"
        //firstView.hidden = true
        firstLabel.hidden = true
        firstMatchSwitchOutlet.hidden = true
        firstMatchLabel.hidden = true
        groupsLabel.hidden = true
        groupsTableView.hidden = true
        phraseLabel.hidden = true
        searchTF.hidden = true
        searchLabel.hidden = true
        onlyByUserLabel.hidden = true
        onlyByUserSwitchOutlet.hidden = true
        loginView.center = self.view.center
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            
        }
        else if result.isCancelled {
            displayAlert(title: "!", message: "Please log in through facebook and grant us your groups permission. Without this, the application cannot see your groups and cannot work. This application does not post anything, anywhere")
        }
        else if error == nil {
            if result.declinedPermissions != nil {
                displayAlert(title: "Whoops", message: "Without granting us permission to see your groups, this application cannot run. This application does not post anything, anywhere")
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            
            self.animEngine.animateOnScreen(1)
            firstLabel.hidden = true
            groupsLabel.hidden = false
            groupsTableView.hidden = false
            phraseLabel.hidden = false
            searchTF.hidden = false
            searchLabel.hidden = false
            firstMatchSwitchOutlet.hidden = false
            firstMatchLabel.hidden = false
            onlyByUserLabel.hidden = false
            onlyByUserSwitchOutlet.hidden = false
            loginView.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height - 20)
            
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                if error != nil {
                  
                } else if error == nil {
                    
                    let userName = result["name"] as! String
                    self.welcome.text = "Welcome \(userName)"
                    
                }
                
            }
            
            FBSDKGraphRequest.init(graphPath: "me/groups", parameters: ["fields":"name"]).startWithCompletionHandler { (connection, result, error) -> Void in
                if error != nil {
                  
                } else if error == nil {
                    
                    self.groupNames.removeAll(keepCapacity: true)
                    self.groupIDs.removeAll(keepCapacity: true)
                    
                    if self.groupsArray.count == 0 {
                    
                    self.groupsArray = result["data"] as! NSArray
                    
                    for item in self.groupsArray { // loop through data items
                        
                        if let itemName = item["name"]! {

                            self.groupNames.append(itemName as! String)
                            self.groupIDs.append(item["id"] as! String)
                            self.groupsTableView.reloadData()   
                            
                        }
                        
                    }
                    
                    }
                    
                }
                
                
            }
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "searchSegue" {
            
            if let NavCon = segue.destinationViewController as? UINavigationController {
                let destination = NavCon.topViewController as! SearchResultsTableViewController
                destination.searchTerm = (searchTF.text?.lowercaseString)!
                destination.groupID = currentGroupID
                destination.firstMatchOnly = firstMatchOnly
                destination.onlyByUser = onlyByUser
                
            }
        }
    }


}

