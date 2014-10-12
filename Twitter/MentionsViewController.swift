//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 02/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation

import UIKit
import SwifteriOS

class MentionsViewController: BaseStatusViewController {
    
    //getStatusesHomeTimelineWithCount
    override func abstractGetStatuses(count: Int?, sinceID: Int?, maxID: Int?, trimUser: Bool?, contributorDetails: Bool?,
        includeEntities: Bool?, success: ((statuses: [JSONValue]?) -> Void)?, failure: Swifter.FailureHandler?) {
            swifter.getStatusesMentionTimelineWithCount(count, sinceID: sinceID, maxID: maxID, trimUser: trimUser,
                contributorDetails: contributorDetails, includeEntities: includeEntities, success: success, failure: failure)
    }
}