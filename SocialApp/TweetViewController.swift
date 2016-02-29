//
//  TweetViewController.swift
//  SocialApp
//
//  Created by Denise Bradley on 2/13/16.
//  Copyright © 2016 Denise Bradley. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    
    @IBOutlet weak var tweetAuthorAvatar: UIImageView!
    @IBOutlet weak var tweetAuthorName: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var selectedTweet : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userData = selectedTweet?.objectForKey("user") as! NSDictionary
        
        tweetText.text? = selectedTweet?.objectForKey("text") as! NSString as String
        tweetAuthorName.text? = userData.objectForKey("name") as! String
        
        let imageURLString = userData.objectForKey("profile_image_url") as! String
        let imageURL = NSURL(string: imageURLString) as NSURL!
        let imageData = NSData(contentsOfURL: imageURL!) as NSData!
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tweetAuthorAvatar.image = UIImage(data: imageData!)
        }
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
