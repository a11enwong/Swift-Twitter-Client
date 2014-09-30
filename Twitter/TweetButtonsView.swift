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
        
        var image = UIImage(named: "reply")
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        replyImage.image = image
        
        retweetImage.userInteractionEnabled = true
        var retweetTab = UITapGestureRecognizer(target: self, action: "onRetweet")
        retweetImage.addGestureRecognizer(retweetTab)
        
        image = UIImage(named: "retweet")
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        retweetImage.image = image
        
        favoriteImage.userInteractionEnabled = true
        var favoriteTab = UITapGestureRecognizer(target: self, action: "onFavorite")
        favoriteImage.addGestureRecognizer(favoriteTab)
        
        image = UIImage(named: "favorite")
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        favoriteImage.image = image
        
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
        println("retweet")
        if let status = self.status {
            let data = ["status": status]
            NSNotificationCenter.defaultCenter().postNotificationName("retweetStatus", object: self, userInfo: data)
        }
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
            retweetImage.tintColor = ColorPalette.Green.get()
        } else {
            retweetImage.tintColor = ColorPalette.Gray.get()
        }
        
        if status.favorited ?? false {
            favoriteImage.tintColor = ColorPalette.Yellow.get()
        } else {
            favoriteImage.tintColor = ColorPalette.Gray.get()
        }
        
        replyImage.tintColor = ColorPalette.Gray.get()
        
        
        self.status = status
    }
    

}
