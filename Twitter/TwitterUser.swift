//
//  User.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

struct TwitterUser {
    var profileBannerUrl: String?
    var profileImageUrl: String?
    var name: String?
    var screenName: String?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    init( jsonValue: Dictionary<String, JSONValue>) {
        profileBannerUrl = jsonValue["profile_banner_url"]?.string
        profileImageUrl = jsonValue["profile_image_url"]?.string
        name = jsonValue["name"]?.string
        screenName = jsonValue["screen_name"]?.string
        tweetsCount = jsonValue["statuses_count"]?.integer
        followingCount = jsonValue["friends_count"]?.integer
        followersCount = jsonValue["followers_count"]?.integer
    }
}