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
    var retweetedTweet: Bool {
        get {
            return retweetedStatus != nil
        }
    }
    var user: TwitterUser?
    var retweetedStatus: TwitterStatus?
    var rootStatus: TwitterStatus {
        get {
            return retweetedTweet ? retweetedStatus! : self
        }
    }

    
    init(jsonValue: Dictionary<String, JSONValue>) {
        id = jsonValue["id"]?.double
        text = jsonValue["text"]?.string
        
        var dateFormater = NSDateFormatter()
        dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormater.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        
        if let date = jsonValue["created_at"]?.string {
            createdAt = dateFormater.dateFromString(date)
        }
        
        retweetCount = jsonValue["retweeted_count"]?.integer
        favoriteCount = jsonValue["favorite_count"]?.integer
        
        user = TwitterUser(jsonValue: jsonValue["user"]!.object! )
        
        if let retweetedStatusJson = jsonValue["retweeted_status"]?.object {
            retweetedStatus = TwitterStatus(jsonValue: retweetedStatusJson)
        }
    }
    
    init(text: String, user: TwitterUser) {
        self.text = text
        self.user = user
        self.createdAt = NSDate()
        self.favoriteCount = 0
        self.retweetCount = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        id  = aDecoder.decodeObjectForKey("id") as? Double
        text  = aDecoder.decodeObjectForKey("profileImageUrl") as? String
        createdAt  = aDecoder.decodeObjectForKey("name") as? NSDate
        retweetCount  = aDecoder.decodeObjectForKey("screenName") as? Int
        favoriteCount  = aDecoder.decodeObjectForKey("tweetsCount") as? Int
        retweetedStatus = aDecoder.decodeObjectForKey("retweetedTweet") as? TwitterStatus
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
        
        if let retweetedStatus = self.retweetedStatus{
            aCoder.encodeObject(retweetedStatus, forKey: "retweetedStatus")
        }
        
        if let user = self.user{
            aCoder.encodeObject(user, forKey: "user")
        }
        
    }
}