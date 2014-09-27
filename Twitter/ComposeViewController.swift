//
//  NewStatusViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 27/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, TweetCounterViewDelegate, UITextViewDelegate {
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    private var swifter = SwifterApi.sharedInstance
    var user: TwitterUser?
    let TWEET_MAX_CHARACTERS = 140

    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var bottomStatusConstraint: NSLayoutConstraint!
    @IBOutlet weak var userHeaderView: UserHeaderView!
    var counterButton: TweetCounterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = defaults.objectForKey("account") as NSData?
        let account = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as TwitterAccount
        user = account.user
        
        userHeaderView.loadUser(user!)
        
        customLeftBarButton();
        
        statusTextView.becomeFirstResponder()
        statusTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        println("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func customLeftBarButton() {
        counterButton = TweetCounterView(frame: CGRectMake(0, 0, 90.0, 44.0))
        counterButton!.delegate = self
        
        let rightHackItem = UIBarButtonItem(customView: counterButton!)
        self.navigationItem.rightBarButtonItem = rightHackItem
    }
    
    func onTweet(sender: AnyObject) {
        println("create tweet")
        
        if statusTextView.text.isEmpty {
            var alert = UIAlertController(title: "Error", message: "Write a something",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var newStatus = TwitterStatus(text: statusTextView.text, user: user!)
        let data = ["status": newStatus]
        NSNotificationCenter.defaultCenter().postNotificationName("statusCreated", object: self, userInfo: data)
        
        swifter.postStatusUpdate(statusTextView.text, inReplyToStatusID: nil, lat: nil, long: nil, placeID: nil,
            displayCoordinates: false, trimUser: false, success: { (status) -> Void in
            println("successfully created a tweet")
        }) { (error) -> Void in
            println(error)
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        var text = statusTextView.text as String
        var count = countElements(text)
        
        if count > TWEET_MAX_CHARACTERS {
            statusTextView.text = (text as NSString).substringWithRange(NSRange(location: 0,length: TWEET_MAX_CHARACTERS)) as String
            count = TWEET_MAX_CHARACTERS
        }
        
        counterButton!.updateCounter(TWEET_MAX_CHARACTERS - count)
    }

}
