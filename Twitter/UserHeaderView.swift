//
//  UserHeaderView.swift
//  Twitter
//
//  Created by Hector Monserrate on 27/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {


    @IBOutlet var view: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: TwitterUser! {
        didSet(oldValue) {
            showUI()
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("UserHeaderView", owner: self, options: nil)
        
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
        thumbnailImageView.layer.cornerRadius = CGFloat(5)
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
        
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName!)"
    }


}
