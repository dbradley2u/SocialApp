//
//  ComposeViewController.swift
//  SocialApp
//
//  Created by Denise Bradley on 2/13/16.
//  Copyright © 2016 Denise Bradley. All rights reserved.
//

import UIKit
import Accounts
import Social

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    var selectedAccount : ACAccount!
        
    @IBOutlet weak var tweetContent: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postActivity: UIActivityIndicatorView!
    
    @IBAction func dismissView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postToTwitter(sender: AnyObject) {
        postContent(self.tweetContent.text)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweetContent.delegate = self
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let targetLength : Int = 140
        
        // The function countElements() was replaced with count()
        // Now, access the characters property of the String, then call count on that.
        return textView.text.characters.count <= targetLength
        
    }
    
    func postContent(post : String) {
        postActivity.startAnimating()
        
        if let account = selectedAccount {
            let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
            let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                requestMethod: SLRequestMethod.POST,
                URL: requestURL,
                parameters: NSDictionary(object: post, forKey: "status") as [NSObject : AnyObject])
            
            request.account = account
            
            request.performRequestWithHandler() {
                responseData, urlResponse, error in
                
                if(urlResponse.statusCode == 200)
                {
                    print("Status Posted")
                    
                    dispatch_async(dispatch_get_main_queue())
                        {
                            self.postActivity.stopAnimating()
                            self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
