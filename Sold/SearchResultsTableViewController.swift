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

class SearchResultsTableViewController: UITableViewController {
    
    var fromDate = String()
    var toDate = String()
    var searchTerm = String()
    var groupID = String()
    var albumResultArray = []
    var albumIDArray = [""]
    var photoIDResultArray = []
    var photoIDArray = [""]
    var commentsIDResultArray = []
    var commentIDArray = [""]
    var commentMessage = [""]
    var commentFrom = [""]
    var commentObject = [AnyObject]()
    var finalCommentArray = []
    var commentTime = [""]
    var dateFormatter = NSDateFormatter()
    var commentsThatMatch = [""]
    var matchedCommentsDates = [""]
    var firstMatch = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumIDArray.removeAll(keepCapacity: true)
        self.photoIDArray.removeAll(keepCapacity: true)
        self.commentIDArray.removeAll(keepCapacity: true)
        self.commentMessage.removeAll(keepCapacity: true)
        self.commentFrom.removeAll(keepCapacity: true)
        self.commentTime.removeAll(keepCapacity: true)
        self.matchedCommentsDates.removeAll(keepCapacity: true)
        self.commentsThatMatch.removeAll(keepCapacity: true)
        self.firstMatch.removeAll(keepCapacity: true)
        
        
        FBSDKGraphRequest.init(graphPath: "\(groupID)/albums/", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if error == nil {
                
                self.albumResultArray = result["data"] as! NSArray
                
                for item in self.albumResultArray { // loop through data items
                    
                    if let AlbumID = item["id"]! {
                        
                        self.albumIDArray.append(AlbumID as! String)
                        
                    }
                }
                
                
                for albums in self.albumIDArray {
                    FBSDKGraphRequest.init(graphPath: "\(albums)/photos", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                        if error != nil {
                            print(error)
                        } else if error == nil {
                            
                            self.photoIDResultArray = result["data"] as! NSArray
                            
                            
                            for item in self.photoIDResultArray { // loop through data items
                                
                                if let photos = item["id"]! {
                                    
                                    self.photoIDArray.append(photos as! String)
                                    
                                    
                                }
                            }
                            
                            for photosID in self.photoIDArray {
                                FBSDKGraphRequest.init(graphPath: "\(photosID)/comments", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                                    if error != nil {
                                        print(error)
                                    } else if error == nil {
                                        
                                        self.commentsIDResultArray = result["data"] as! NSArray
                                        //24 times
                                        
                                        for item in self.commentsIDResultArray { // loop through data items
                                            
                                            if let comments = item["message"]! {
                                                
                                                if comments.containsString(self.searchTerm) {
                                                    
                                                    self.commentsThatMatch.append(item["id"] as! String)
                                                    self.firstMatch.append(self.commentsThatMatch.first!)
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        for matchedComms in self.firstMatch {
                                            FBSDKGraphRequest.init(graphPath: "/\(matchedComms)/", parameters: ["fields":""]).startWithCompletionHandler { (connection, result, error) -> Void in
                                                if error != nil {
                                                    print(error)
                                                } else if error == nil {
                                                    
                                                    //2 with "flight"
                                                    /* if let commentMessage = result["message"]! {
                                                     
                                                     self.commentMessage.append(commentMessage as! String)
                                                     print(self.commentMessage)
                                                     }
                                                     
                                                     if let commentUser = result["name"]! {
                                                     
                                                     self.commentFrom.append(commentUser as! String)
                                                     print(self.commentFrom)
                                                     }
                                                     
                                                     if let commentTime = result["created_time"]! {
                                                     
                                                     self.commentTime.append(commentTime as! String)
                                                     print(self.commentTime)
                                                     } */
                                                    
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
        return commentMessage.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchCells
        
        
        myCell.comment.text = commentMessage[indexPath.row]
        myCell.date.text = commentTime[indexPath.row]
        myCell.user.text = commentFrom[indexPath.row]
        
        return myCell
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
