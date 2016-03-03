//
//  FollowingViewController.swift
//  SocialApp
//
//  Created by Denise Bradley on 3/2/16.
//  Copyright © 2016 Denise Bradley. All rights reserved.
//

import UIKit
import Accounts
import Social

let reuseIdentifier = "Cell"

class FollowingViewController: UICollectionViewController {
    
    var following : NSMutableArray?
    var imageCache : NSCache?
    var queue : NSOperationQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        queue = NSOperationQueue()
        queue?.maxConcurrentOperationCount = 4
        
        self.tabBarController?.navigationItem.title = "Following"
        
        retrieveUsers()
    }
    
    func retrieveUsers() {
        following?.removeAllObjects()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let accountData = userDefaults.objectForKey("selectedAccount") as! NSData
        let selectedAccount = NSKeyedUnarchiver.unarchiveObjectWithData(accountData) as! ACAccount
        
        let requestURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json?count=200")
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: SLRequestMethod.GET,
            URL: requestURL,
            parameters: nil)
        
        request.account = selectedAccount
        
        request.performRequestWithHandler()
            {
                responseData, urlResponse, error in
                
                if(urlResponse.statusCode == 200)
                {
                    
                    
                    do {
                        let followingData = try NSJSONSerialization.JSONObjectWithData(responseData,
                            options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        self.following = followingData.objectForKey("users") as? NSMutableArray
                    }
                    catch let jsonParseError {
                        print("Parse error = \(jsonParseError)")
                    }
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView!.reloadData()
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let followCount = following?.count {
            return followCount
        }
        else
        {
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        let userData = following?.objectAtIndex(indexPath.row) as! NSDictionary
        let imageURLString = userData.objectForKey("profile_image_url") as! String
        
        if let image = imageCache?.objectForKey(imageURLString) as? UIImage {
            let imageView = UIImageView(image: image) as UIImageView
            imageView.bounds = cell.frame
            cell.addSubview(imageView)
        }
        else
        {
            queue?.addOperationWithBlock() {
                let imageURL = NSURL(string: imageURLString) as NSURL?
                let imageData = NSData(contentsOfURL: imageURL!) as NSData?
                let image = UIImage(data: imageData!) as UIImage?
                
                if let downloadedImage = image {
                    NSOperationQueue.mainQueue().addOperationWithBlock(){
                        let imageView = UIImageView(image: image)
                        imageView.bounds = cell.frame
                        
                        if let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as UICollectionViewCell! {
                            cell.addSubview(imageView)
                        }
                    }
                    
                    self.imageCache?.setObject(image!, forKey: imageURLString)
                }
            }
        }
        
        
        return cell
    }
    
    
}
