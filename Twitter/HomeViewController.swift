//
//  ViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 24/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit
import SwifteriOS

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    var swifter = SwifterApi.sharedInstance
    var statuses = [TwitterStatus]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var tweetActionsObserver: TweetActionsObserver = TweetActionsObserver.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ColorPalette.Blue.get()
        navigationController?.navigationBar.titleTextAttributes = NSDictionary(
            object: ColorPalette.White.get(), forKey: NSForegroundColorAttributeName)
        title = "Home"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
            style: UIBarButtonItemStyle.Plain, target: self, action: "onSignOut")
        self.navigationItem.leftBarButtonItem?.tintColor = ColorPalette.White.get()
    
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refersh")
        refreshControl.addTarget(self, action: "fetchTwitterHomeStream", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

        fetchTwitterHomeStream()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusCreated:", name: "statusCreated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdated:", name: "statusUpdated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = reusableTableCell("TweetTableViewCell") as TweetTableViewCell
        
        cell.loadStatus(statuses[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let status = statuses[indexPath.row]
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("StatusDetailViewController") as StatusDetailViewController
        controller.status = status
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func reusableTableCell(identifier: String) -> UITableViewCell {
        var possibleCell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell?
        if possibleCell == nil {
            let topLevelObjects = NSBundle.mainBundle().loadNibNamed(identifier, owner: self, options: nil)
            possibleCell = topLevelObjects.first as UITableViewCell?
        }
        
        
        return possibleCell!
    }
    
    func fetchTwitterHomeStream() {
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("error fetching tweets")
            println(error)
            self.refreshControl.endRefreshing()
        }
        
        swifter.getStatusesHomeTimelineWithCount(20, sinceID: nil, maxID: nil, trimUser: false,
            contributorDetails: true, includeEntities: true, success: {
            (statuses: [JSONValue]?) in
                println("fetched successfully")
                println(statuses!.first)
                self.refreshControl.endRefreshing()
                
                self.statuses = []
                for status in statuses! {
                   self.statuses.append(TwitterStatus(jsonValue: status.object!))
                }
                
                self.tableView.reloadData()
            }, failure: failureHandler)
    }
    
    func onSignOut() {
        defaults.setObject(nil, forKey: "account")
        swifter.client.credential = nil
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func onStatusCreated(notification: NSNotification) {
        println(notification.userInfo)
        let controller = notification.object as UIViewController
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        let newStatus = notification.userInfo!["status"] as TwitterStatus
        statuses.insert(newStatus, atIndex: 0)
        
        tableView.reloadData()
    }
    
    func onStatusUpdated(notification: NSNotification) {
        println(notification.userInfo)
        
        let updatedStatus = notification.userInfo!["status"] as TwitterStatus
        
        for (i, status) in enumerate(statuses) {
            if status.id! == updatedStatus.id! {
                println("updating status \(i) to \(updatedStatus.favorited!)")
                statuses[i...i] = [updatedStatus]
            }
        }
        
        tableView.reloadData()
    }
}

