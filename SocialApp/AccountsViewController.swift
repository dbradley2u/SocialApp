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
    var userDefaults : NSUserDefaults?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountStore = ACAccountStore()
        
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        if(userDefaults?.objectForKey("selectedAccount") != nil) {
            performSegueWithIdentifier("ShowTweets", sender: self)
        }
        
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let account = self.twitterAccounts!.objectAtIndex(indexPath.row) as! ACAccount
        let accountData = NSKeyedArchiver.archivedDataWithRootObject(account) as NSData
        
        userDefaults?.setObject(accountData, forKey: "selectedAccount")
        userDefaults?.synchronize()
        
        performSegueWithIdentifier("ShowTweets", sender: self)
        
    }
   

}
