//
//  TwitterAccount.swift
//  Twitter
//
//  Created by Hector Monserrate on 27/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation

class TwitterAccount: NSObject, NSCoding {
    var user: TwitterUser
    var key: String
    var secret: String
    
    init(user: TwitterUser, key: String, secret: String) {
        self.user = user
        self.key = key
        self.secret = secret
    }
    
    required init(coder aDecoder: NSCoder) {
        self.user  = aDecoder.decodeObjectForKey("user") as TwitterUser
        self.key  = aDecoder.decodeObjectForKey("key") as String
        self.secret  = aDecoder.decodeObjectForKey("secret") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(user, forKey: "user")
        aCoder.encodeObject(key, forKey: "key")
        aCoder.encodeObject(secret, forKey: "secret")
    }
    
}