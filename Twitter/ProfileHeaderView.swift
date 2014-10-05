//
//  ProfileHeaderView.swift
//  Twitter
//
//  Created by Hector Monserrate on 03/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var nameTextView: UILabel!
    @IBOutlet var screenNameTextView: UILabel!
    @IBOutlet var tweetsCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var followeesCountLabel: UILabel!
    
    var user: TwitterUser! {
        didSet(oldValue) {
            showUI()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil)
        
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
    
    func showUI() {
        nameTextView.text = user.name
        screenNameTextView.text = "@\(user.screenName!)"
        
        if let profileBannerUrl = user.profileBannerUrl {
            coverImage.setImageWithURL(NSURL(string: profileBannerUrl))
            view.sendSubviewToBack(coverImage)
        }
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 5.0
        profileImage.layer.borderColor = ColorPalette.White.get().CGColor
        profileImage.layer.borderWidth = 2.0
        profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!))
        
        tweetsCountLabel.text = "\(user.tweetsCount!)"
        followeesCountLabel.text = "\(user.followingCount!)"
        followersCountLabel.text = "\(user.followersCount!)"
    }

}
