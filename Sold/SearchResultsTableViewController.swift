//
//  SearchResultsTableViewController.swift
//  Sold
//
//  Created by Luis Ramirez on 7/9/16.
//  Copyright © 2016 Luis Ramirez. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

let yellow = UIColor(colorLiteralRed: 0.996, green: 0.831, blue: 0.149, alpha: 0.7)
let orange = UIColor(colorLiteralRed: 1.000, green: 0.533, blue: 0.416, alpha: 0.7)
let magenta = UIColor(colorLiteralRed: 1.000, green: 0.318, blue: 0.843, alpha: 0.7)
let purple = UIColor(colorLiteralRed: 0.824, green: 0.424, blue: 0.996, alpha: 0.7)
let blue = UIColor(colorLiteralRed: 0.573, green: 0.604, blue: 1.00, alpha: 0.7)
let lightBlue = UIColor(colorLiteralRed: 0.576, green: 0.827, blue: 1.000, alpha: 0.7)
let green = UIColor(colorLiteralRed: 0.439, green: 1.000, blue: 0.741, alpha: 0.7)

class SearchResultsTableViewController: UITableViewController {
    
    
    var searchTerm = String()
    var groupID = String()
    var firstMatchOnly = Bool()
    var albumResultArray = []
    var albumIDArray = [""]
    var photoIDResultArray = []
    var photoIDArray = [""]
    var commentsIDResultArray = []
    var commentIDArray = [""]
    var commentMessage = [""]
    var commentFrom = [""]
    var commentObject = [UIImage]()
    var finalCommentArray = []
    var commentTime = [""]
    var df = NSDateFormatter()
    var commentsThatMatch = [""]
    var matchedCommentsDates = [""]
    var firstMatch = [""]
    var matchedCommentIDs = [""]
    var albumCount = 0
    var photoCount = 0
    var onlyByUser = Bool()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    let colors = [yellow, orange, magenta, purple, blue, lightBlue, green]
    
    
    @available(iOS 8.0, *)
    func displayAlert(title messageTitle: String, message alertMessage: String) {
        let alert = UIAlertController(title: messageTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in
            
            self.performSegueWithIdentifier("backToSearchSegue", sender: self)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        indicator.color = UIColor.cyanColor()
        indicator.frame = CGRectMake(0, 0, 30.0, 30.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
        
        self.title = searchTerm
        
        getResults()
        
        
    }
    
    private func getResults() {
        self.albumIDArray.removeAll(keepCapacity: true)
        self.matchedCommentIDs.removeAll(keepCapacity: true)
        self.photoIDArray.removeAll(keepCapacity: true)
        self.commentIDArray.removeAll(keepCapacity: true)
        self.commentMessage.removeAll(keepCapacity: true)
        self.commentFrom.removeAll(keepCapacity: true)
        self.commentTime.removeAll(keepCapacity: true)
        self.matchedCommentsDates.removeAll(keepCapacity: true)
        self.commentsThatMatch.removeAll(keepCapacity: true)
        self.firstMatch.removeAll(keepCapacity: true)
        self.commentObject.removeAll(keepCapacity: true)
        
        
        FBSDKGraphRequest.init(graphPath: "\(groupID)/albums", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
              
            } else if error == nil {
                
                
                self.albumResultArray = result["data"] as! NSArray
                
                for arrayResult in self.albumResultArray { // loop through data items
                    
                    self.albumCount += 1
                    
                    if let AlbumID = arrayResult["id"] as? String {
                        
                        FBSDKGraphRequest.init(graphPath: "\(AlbumID)/photos", parameters: ["fields":"id, from"]).startWithCompletionHandler { (connection, result, error) -> Void in
                            if error != nil {
                               
                            } else if error == nil {
                                
                                
                                self.photoIDResultArray = result["data"] as! NSArray
                                
                                for photoResult in self.photoIDResultArray { // loop through data items
                                    
                                    if self.onlyByUser == true {
                                        let photoFrom = photoResult["from"] as! NSDictionary
                                      
                                        
                                        if photoFrom["id"] as! String == FBSDKAccessToken.currentAccessToken().userID {
                                            
                                            if let photos = photoResult["id"] as? String {
                                                
                                                FBSDKGraphRequest.init(graphPath: "\(photos)/comments", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                    if error != nil {
                                                  
                                                    } else if error == nil {
                                                        
                                                        self.commentsIDResultArray = result["data"] as! NSArray
                                                        
                                                        var foundMatch = false
                                                        
                                                        for commentResult in self.commentsIDResultArray { // loop through data items
                                                            
                                                            if foundMatch == false {
                                                                
                                                                if let comments = commentResult["message"] as? String {
                                                                    
                                                                    if comments.lowercaseString.containsString(self.searchTerm) {
                                                                        
                                                                        if self.firstMatchOnly == true {
                                                                            foundMatch = true
                                                                        }
                                                                        
                                                                        if let matchedCommentID = commentResult["id"] as? String {
                                                                            
                                                                            FBSDKGraphRequest.init(graphPath: "/\(matchedCommentID)", parameters: ["fields":"id, from, created_time, message, object"]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                                                if error != nil {
                                                                               
                                                                                } else if error == nil {
                                                                                    
                                                                                    
                                                                                    self.matchedCommentIDs.append(matchedCommentID)
                                                                                    
                                                                                    let message = result["message"]!
                                                                                    
                                                                                    let commentTime = result["created_time"]!
                                                                                    
                                                                                    self.df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                                                                    var date = self.df.dateFromString(commentTime as! String)
                                                                                    self.df.dateFormat = "eee MMM dd, yyyy hh:mm"
                                                                                    var dateStr = self.df.stringFromDate(date!)
                                                                                    
                                                                                    
                                                                                    
                                                                                    let thePerson = result["from"] as? NSDictionary
                                                                                    
                                                                                    if let theObject = result["object"] as? NSDictionary {
                                                                                        let theObjectID = theObject["id"] as! String
                                                                                        
                                                                                        FBSDKGraphRequest.init(graphPath: "/\(theObjectID)", parameters: ["fields":"picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                                                            if error != nil {
                                                                                              
                                                                                            } else if error == nil {
                                                                                                
                                                                                                
                                                                                                if let imageURLString = result["picture"] as? String {
                                                                                                    
                                                                                                    
                                                                                                    let imageURL = NSURL(string: imageURLString)
                                                                                                    let data = NSData(contentsOfURL: imageURL!)
                                                                                                    let commentImage = UIImage(data: data!)
                                                                                                    self.commentObject.append(commentImage!)
                                                                                                    self.commentMessage.append(message as! String)
                                                                                                    self.commentTime.append(dateStr)
                                                                                                    self.commentFrom.append(thePerson!["name"] as! String)
                                                                                                    
                                                                                                    self.tableView.reloadData()
                                                                                                    self.indicator.stopAnimating()
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                    
                                                                                    
                                                                                }
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                    else if self.onlyByUser == false {
                                        
                                        if let photos = photoResult["id"] as? String {
                                            
                                            FBSDKGraphRequest.init(graphPath: "\(photos)/comments", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                if error != nil {
                                                    
                                                } else if error == nil {
                                                    
                                                    self.commentsIDResultArray = result["data"] as! NSArray
                                                    
                                                    var foundMatch = false
                                                    
                                                    for commentResult in self.commentsIDResultArray { // loop through data items
                                                        
                                                        if foundMatch == false {
                                                            
                                                            if let comments = commentResult["message"] as? String {
                                                                
                                                                if comments.lowercaseString.containsString(self.searchTerm) {
                                                                    
                                                                    if self.firstMatchOnly == true {
                                                                        foundMatch = true
                                                                    }
                                                                    
                                                                    if let matchedCommentID = commentResult["id"] as? String {
                                                                        
                                                                        FBSDKGraphRequest.init(graphPath: "/\(matchedCommentID)", parameters: ["fields":"id, from, created_time, message, object"]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                                            if error != nil {
                                                                             
                                                                            } else if error == nil {
                                                                                
                                                                                
                                                                                self.matchedCommentIDs.append(matchedCommentID)
                                                                                
                                                                                let message = result["message"]!
                                                                                
                                                                                let commentTime = result["created_time"]!
                                                                                
                                                                                self.df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                                                                var date = self.df.dateFromString(commentTime as! String)
                                                                                self.df.dateFormat = "eee MMM dd, yyyy hh:mm"
                                                                                var dateStr = self.df.stringFromDate(date!)
                                                                                
                                                                                
                                                                                
                                                                                let thePerson = result["from"] as? NSDictionary
                                                                                
                                                                                if let theObject = result["object"] as? NSDictionary {
                                                                                    let theObjectID = theObject["id"] as! String
                                                                                    
                                                                                    FBSDKGraphRequest.init(graphPath: "/\(theObjectID)", parameters: ["fields":"picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                                                        if error != nil {
                                                                                            
                                                                                        } else if error == nil {
                                                                                            
                                                                                            
                                                                                            if let imageURLString = result["picture"] as? String {
                                                                                                
                                                                                                
                                                                                                let imageURL = NSURL(string: imageURLString)
                                                                                                let data = NSData(contentsOfURL: imageURL!)
                                                                                                let commentImage = UIImage(data: data!)
                                                                                                self.commentObject.append(commentImage!)
                                                                                                self.commentMessage.append(message as! String)
                                                                                                self.commentTime.append(dateStr)
                                                                                                self.commentFrom.append(thePerson!["name"] as! String)
                                                                                                
                                                                                                self.tableView.reloadData()
                                                                                                self.indicator.stopAnimating()
                                                                                                
                                                                                                
                                                                                                
                                                                                                
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    
                                                                                    
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                                
                                                                            }
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.commentMessage.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        myCell.backgroundColor = self.colors[indexPath.row % self.colors.count]
        myCell.messageThatMatched.text = self.commentMessage[indexPath.row]
        myCell.dateForComment.text = self.commentTime[indexPath.row]
        myCell.userThatCommented.text = self.commentFrom[indexPath.row]
        myCell.imageCommented.image = self.commentObject[indexPath.row]
        
        
        return myCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var safariAlert = UIAlertController(title: "Open Safari?", message: "Would you like to open Facebook in Safari?", preferredStyle: .Alert)
        safariAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction) -> Void in
            var urlString = "https://facebook.com/\(self.matchedCommentIDs[indexPath.row])"
            var url = NSURL(string: urlString)
            UIApplication.sharedApplication().openURL(url!)
        }))
        
        safariAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) -> Void in
            
            return
        }))
        
        presentViewController(safariAlert, animated: true, completion: nil)
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
