//
//  TweetCounter.swift
//  Twitter
//
//  Created by Hector Monserrate on 27/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

protocol TweetCounterViewDelegate {
    func onTweet(sender: AnyObject)
}

class TweetCounterView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var characterCountLabel: UILabel!
    var delegate: TweetCounterViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        NSBundle.mainBundle().loadNibNamed("TweetCounterView", owner: self, options: nil)
        
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
    
    func updateCounter(countdown: Int) {
        characterCountLabel.text = "\(countdown)"
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        delegate?.onTweet(sender)
    }

}
