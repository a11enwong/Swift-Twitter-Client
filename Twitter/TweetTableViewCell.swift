//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Hector Monserrate on 24/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLagel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadStatus(status: TwitterStatus) {
        nameLabel.text = status.user?.name
        screenNameLabel.text = status.user?.screenName
        tweetTextLabel.text = status.text
    }
    
}
