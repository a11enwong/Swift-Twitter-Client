//
//  MenuProfileHeaderView.swift
//  Twitter
//
//  Created by Hector Monserrate on 04/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class MenuProfileHeaderView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        NSBundle.mainBundle().loadNibNamed("MenuProfileHeaderView", owner: self, options: nil)
        
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
    
    func show(user: TwitterUser) {
        userImage.setImageWithURL(NSURL(string: user.profileImageUrl!))
        nameLabel.text = user.name
        aboutLabel.text = user.about
    }
    

}
