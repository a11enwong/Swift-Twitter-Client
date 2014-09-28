//
//  TweetButtonsView.swift
//  Twitter
//
//  Created by Hector Monserrate on 28/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

protocol TweetButtonsViewDelegate {
    func onReplyTab()
    func onRetweetTab()
}

class TweetButtonsView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var delegate: TweetButtonsViewDelegate?
    var status: TwitterStatus?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("TweetButtonsView", owner: self, options: nil)
        
        replyImage.userInteractionEnabled = true
        var replyTab = UITapGestureRecognizer(target: self, action: "onReply")
        replyImage.addGestureRecognizer(replyTab)
        
        retweetImage.userInteractionEnabled = true
        var retweetTab = UITapGestureRecognizer(target: self, action: "onRetweet")
        retweetImage.addGestureRecognizer(retweetTab)
        
        favoriteImage.userInteractionEnabled = true
        var favoriteTab = UITapGestureRecognizer(target: self, action: "onFavorite")
        favoriteImage.addGestureRecognizer(favoriteTab)
        
        self.addSubview(view);
        
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsDictionary = ["view": view]
        
        let view1_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[view]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view1_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[view]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(view1_constraint_H)
        self.addConstraints(view1_constraint_V)
    }
    
    func onReply() {
        delegate?.onReplyTab()
    }
    
    func onRetweet() {
        delegate?.onRetweetTab()
    }
    
    func onFavorite() {
        println("favorite")
        if let status = self.status {
            let data = ["status": status]
            NSNotificationCenter.defaultCenter().postNotificationName("favoriteStatus", object: self, userInfo: data)
        }
    }
    
    func showStatus(status: TwitterStatus) {
        if status.retweeted ?? false {
            retweetImage.image = UIImage(named: "retweet_green")
        } else {
            retweetImage.image = UIImage(named: "retweet")
        }
        
        if status.favorited ?? false {
            favoriteImage.image = UIImage(named: "favorite_on")
        } else {
            favoriteImage.image = UIImage(named: "favorite")
        }
        
        self.status = status
    }
    

}
