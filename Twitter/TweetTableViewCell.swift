//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Hector Monserrate on 24/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell, TweetButtonsViewDelegate {

    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLagel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetedView: UIView!
    @IBOutlet weak var retweetViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var buttonsView: TweetButtonsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadStatus(status: TwitterStatus) {
        let rootStatus = status.rootStatus
        
        nameLabel.text = rootStatus.user?.name
        screenNameLabel.text = "@\(rootStatus.user!.screenName!)"
        tweetTextLabel.text = rootStatus.text
        
        var timeIntervalFormater = TTTTimeIntervalFormatter()
        timeLagel.text = timeIntervalFormater.stringForTimeIntervalFromDate(
            NSDate(), toDate: rootStatus.createdAt!)
        
        thumnailImageView.layer.cornerRadius = CGFloat(5)
        thumnailImageView.layer.masksToBounds = true
        thumnailImageView.setImageWithURL(NSURL(string: rootStatus.user!.profileImageUrl!))
        
        if status.retweetedTweet {
            let name = status.user!.name!
            retweetedLabel.text = "\(name) retweeted"
        } else {
            retweetViewHeightConstraint.constant = 0
            retweetedView.hidden = true
        }
        
        buttonsView.delegate = self
        buttonsView.showStatus(status)
    }
    
    func onReplyTab() {
        println("retweet")
    }
    
    func onRetweetTab() {
        println("retweet")
    }
    
}
