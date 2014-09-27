//
//  Status.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

class TwitterStatus: NSObject, NSCoding {
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
    
    init(text: String, user: TwitterUser) {
        self.text = text
        self.user = user
        self.createdAt = NSDate()
        self.favoriteCount = 0
        self.retweetedTweet = 0
        self.retweetCount = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        id  = aDecoder.decodeObjectForKey("id") as? Double
        text  = aDecoder.decodeObjectForKey("profileImageUrl") as? String
        createdAt  = aDecoder.decodeObjectForKey("name") as? NSDate
        retweetCount  = aDecoder.decodeObjectForKey("screenName") as? Int
        favoriteCount  = aDecoder.decodeObjectForKey("tweetsCount") as? Int
        retweetedTweet = aDecoder.decodeObjectForKey("retweetedTweet") as? Bool
        user  = aDecoder.decodeObjectForKey("followingCount") as? TwitterUser
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let id = self.id{
            aCoder.encodeObject(id, forKey: "id")
        }
        
        if let text = self.text{
            aCoder.encodeObject(text, forKey: "text")
        }
        
        if let createdAt = self.createdAt{
            aCoder.encodeObject(createdAt, forKey: "createdAt")
        }
        
        if let retweetCount = self.retweetCount{
            aCoder.encodeObject(retweetCount, forKey: "retweetCount")
        }
        
        if let retweetedTweet = self.retweetedTweet{
            aCoder.encodeObject(retweetedTweet, forKey: "retweetedTweet")
        }
        
        if let user = self.user{
            aCoder.encodeObject(user, forKey: "user")
        }
        
    }
}