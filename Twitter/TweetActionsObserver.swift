//
//  TweetButtonsObserver.swift
//  Twitter
//
//  Created by Hector Monserrate on 28/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

class TweetActionsObserver: NSObject {
    var swifter: Swifter
    
    override init() {
        swifter = SwifterApi.sharedInstance
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onFavoriteStatus:", name: "favoriteStatus", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRetweetStatus:", name: "retweetStatus", object: nil)
    }
    
    class var sharedInstance : TweetActionsObserver {
        struct Static {
            static let instance : TweetActionsObserver = TweetActionsObserver()
        }
        return Static.instance
    }
    
    
    func onFavoriteStatus(notification: NSNotification) {
        let status = notification.userInfo!["status"] as TwitterStatus
        
        println(status.favorited)
        if !(status.favorited ?? false) {
            status.favorited = true
            status.favoriteCount = (status.favoriteCount ?? 0 ) + 1
        } else {
            status.favorited = false
            status.favoriteCount = (status.favoriteCount ?? 1 ) - 1
        }
        
        sendUpdatedStatusNotification(status)
    }
    
    func onRetweetStatus(notification: NSNotification) {
        let status = notification.userInfo!["status"] as TwitterStatus
        
        if !(status.retweeted ?? false) {
            status.retweeted = true
            status.retweetCount = (status.retweetCount ?? 0 ) + 1
        } else {
            status.retweeted = false
            status.retweetCount = (status.retweetCount ?? 1 ) - 1
        }
        
        sendUpdatedStatusNotification(status)
    }
    
    private func sendUpdatedStatusNotification(status: TwitterStatus) {
        let data = ["status": status]
        NSNotificationCenter.defaultCenter().postNotificationName("statusUpdated", object: self, userInfo: data)
    }
    
}