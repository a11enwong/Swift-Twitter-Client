//
//  BaseStatusViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 02/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit
import SwifteriOS

class BaseStatusViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, TweetTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableTopConstraint: NSLayoutConstraint!
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    let TWEETS_PER_LOAD = 20
    var swifter = SwifterApi.sharedInstance
    var statuses = [TwitterStatus]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var tweetActionsObserver: TweetActionsObserver = TweetActionsObserver.sharedInstance
    var fetchingData = false
    var endResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refersh")
        refreshControl.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        fetchTwitterHomeStream()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusCreated:", name: "statusCreated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStatusUpdated:", name: "statusUpdated", object: nil)
        
        
        tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
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
        cell.delegate = self
        
        println("Row \(indexPath.row) from \(statuses.count)")
        if statuses.count == (indexPath.row + 1) && !endResults && !fetchingData {
            fetchTwitterHomeStream(replace: false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let status = statuses[indexPath.row]
        
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("StatusDetailViewController") as StatusDetailViewController
        controller.status = status
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func reusableTableCell(identifier: String) -> UITableViewCell {
        var possibleCell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell?
        
        return possibleCell!
    }
    
    func onPullToRefresh() {
        fetchTwitterHomeStream(replace: true)
    }
    
    func fetchTwitterHomeStream(replace: Bool = true) {
        fetchingData = true
        
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("error fetching tweets")
            println(error)
            self.refreshControl.endRefreshing()
            self.fetchingData = false
            self.tableView.tableFooterView = nil
        }
        
        var maxID = replace ? nil : statuses.last?.id
        if maxID != nil {
            maxID = maxID! - 1
         }
        
        println("maxid \(maxID)")
        
        if !replace {
            self.showFooterSpinner()
        }
        
        abstractGetStatuses(TWEETS_PER_LOAD, sinceID: nil, maxID: maxID, trimUser: false,
            contributorDetails: true, includeEntities: true, success: { (statuses) -> Void in
                println("\(statuses!.count) results fetched successfully")
                self.refreshControl.endRefreshing()
                
                if replace {
                    self.statuses = []
                }
                
                for status in statuses! {
                    self.statuses.append(TwitterStatus(jsonValue: status.object!))
                }
                
                self.endResults = statuses!.count == 0
                
                self.fetchingData = false
                self.tableView.tableFooterView = nil
                
                self.tableView.reloadData()
            }, failure: failureHandler)
        
    }
    
    func abstractGetStatuses(count: Int?, sinceID: Int?, maxID: Int?, trimUser: Bool?, contributorDetails: Bool?,
        includeEntities: Bool?, success: ((statuses: [JSONValue]?) -> Void)?, failure: Swifter.FailureHandler?) {
        fatalError("This method must be overridden")
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
        
        println(updatedStatus)
        for (i, status) in enumerate(statuses) {
            if status.id! == updatedStatus.id! {
                statuses[i...i] = [updatedStatus]
            }
        }
        
        tableView.reloadData()
    }
    
    func onReplyStatus(status: TwitterStatus) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("ComposeNavigationController") as UINavigationController
        let controller = navigationController.viewControllers.first as ComposeViewController
        controller.status = status
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showFooterSpinner() {
        let spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 320, 44))
        spinner.startAnimating()
        spinner.color = ColorPalette.Blue.get()
        tableView.tableFooterView = spinner
    }
    
}
