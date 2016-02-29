//
//  AccountsViewController.swift
//  SocialApp
//
//  Created by Denise Bradley on 2/13/16.
//  Copyright © 2016 Denise Bradley. All rights reserved.
//

import UIKit
import Accounts

class AccountsViewController: UITableViewController {
    
    var twitterAccounts : NSArray?
    var accountStore : ACAccountStore?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountStore = ACAccountStore()
        
        var accountType : ACAccountType = accountStore!.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore?.requestAccessToAccountsWithType(accountType, options: nil,
            completion: { granted, error in
                if(granted)
                {
                    self.twitterAccounts = self.accountStore!.accountsWithAccountType(accountType)
                    
                    if (self.twitterAccounts?.count == 0)
                    {
                        var noAccountsAlert : UIAlertController = UIAlertController(title: "No Accounts Found",
                            message: "No Twitter accounts were found.",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        var dismissButton : UIAlertAction = UIAlertAction(title: "Okay",
                            style: UIAlertActionStyle.Cancel) {
                                alert in
                                noAccountsAlert.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                        noAccountsAlert.addAction(dismissButton)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.presentViewController(noAccountsAlert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                    }
                }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        if let cellCount = self.twitterAccounts?.count{
            return cellCount
        }
        else
        {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as UITableViewCell
        
        let account = self.twitterAccounts!.objectAtIndex(indexPath.row) as! ACAccount
        
        cell.textLabel!.text = account.accountDescription
        
        return cell
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

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "ShowTweets")
        {
            var path : NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            let account = self.twitterAccounts!.objectAtIndex(path.row) as! ACAccount
            
            let targetController = segue.destinationViewController as! FeedViewController
            targetController.selectedAccount = account
            
        }
    }


}
