//
//  StatusDetailViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 27/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class StatusDetailViewController: UIViewController, TweetButtonsViewDelegate {

    @IBOutlet weak var userHeaderView: UserHeaderView!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetActionsView: TweetButtonsView!
    @IBOutlet weak var retweetsCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var tweetActionsObserver: TweetActionsObserver = TweetActionsObserver.sharedInstance
    
    var status: TwitterStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showUI()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdated:", name: "statusUpdated", object: nil)
        navigationItem.title = "Tweet"
        navigationController?.navigationBar.tintColor = ColorPalette.White.get()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reply",
            style: UIBarButtonItemStyle.Plain, target: self, action: "onReplyTab")
        self.navigationItem.rightBarButtonItem?.tintColor = ColorPalette.White.get()
        
        tweetActionsView.delegate = self
    }
    
    func showUI() {
        statusTextView.text = status?.rootStatus.text
        textHeightConstraint.constant = self.heightForTextView() + 25.0
        tweetActionsView.showStatus(status!)
        userHeaderView.loadUser(status!.rootStatus.user!)
        retweetsCount.text = "\(status!.rootStatus.retweetCount!)"
        favoritesCount.text = "\(status!.rootStatus.favoriteCount!)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        timeLabel.text = dateFormatter.stringFromDate(status!.rootStatus.createdAt!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func heightForTextView() -> CGFloat {
        let screenRect = UIScreen.mainScreen().bounds
        var width = isPortraitOrientation() ? screenRect.size.width : screenRect.size.height
        width -= 40
        statusTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        
        let text = statusTextView.text as NSString
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18)]
        let size = CGSizeMake(CGFloat(width), CGFloat(MAXFLOAT))

        let textRect = text.boundingRectWithSize(size,
            options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        
        return textRect.size.height
    }
    
    func isPortraitOrientation() -> Bool {
        return UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait
    }
    
    func onStatusUpdated(notification: NSNotification) {
        println(notification.userInfo)
        status = notification.userInfo!["status"] as? TwitterStatus
        showUI()
    }
    
    func onReplyTab() {
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("ComposeNavigationController") as UINavigationController
        let controller = navigationController.viewControllers.first as ComposeViewController
        controller.status = status
        
        presentViewController(navigationController, animated: true, completion: nil)
    }

}
