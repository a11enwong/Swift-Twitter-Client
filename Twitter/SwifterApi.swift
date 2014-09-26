//
//  SwifterApi.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

class SwifterApi {
    
    class var sharedInstance : Swifter {
        struct Static {
            static let instance : Swifter = Swifter(consumerKey: "Fu4VLwZovZzgfnTgoGlqw",
                consumerSecret: "1N4W4HG0LhDKmN6WCKRr35AnDAgNx9b6VpMCKTwyjm0")
        }
        return Static.instance
    }
    
}