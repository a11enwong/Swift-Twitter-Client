//
//  Status.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

struct TwitterStatus {
    var id: Double?
    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int?
    var favoriteCount: Int?
    var retweetedTweet: Bool?
    var user: TwitterUser?

    
    init(jsonValue: JSONValue) {
        id = jsonValue["id"].double
        text = jsonValue["text"].string
        
        var dateFormater = NSDateFormatter()
        dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormater.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        createdAt = dateFormater.dateFromString(jsonValue["created_at"].string!)
        
        retweetCount = jsonValue["retweeted_count"].integer
        favoriteCount = jsonValue["favorite_count"].integer
        retweetedTweet = jsonValue["retweeted"].bool
        
        user = TwitterUser(jsonValue: jsonValue["user"].object! )
    }
}