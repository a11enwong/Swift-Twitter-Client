//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 03/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

class ProfileViewController: BaseStatusViewController {
    var user: TwitterUser?
    var profileHeaderView: ProfileHeaderView?
    let HEADER_HEIGHT: CGFloat = 160
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.removeFromSuperview()
        
        setupHeaderView()
    }
    
    func setupHeaderView() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: HEADER_HEIGHT)
        profileHeaderView = ProfileHeaderView(frame: frame)
        tableView.tableHeaderView = profileHeaderView!
        profileHeaderView?.show(user!)
    }
    
    //getStatusesHomeTimelineWithCount
    override func abstractGetStatuses(count: Int?, sinceID: Int?, maxID: Int?, trimUser: Bool?, contributorDetails: Bool?,
        includeEntities: Bool?, success: ((statuses: [JSONValue]?) -> Void)?, failure: Swifter.FailureHandler?) {
            swifter.getStatusesUserTimelineWithUserID(String(user!.userId!), count: count, sinceID: sinceID, maxID: maxID, trimUser: trimUser,
                contributorDetails: contributorDetails, includeEntities: includeEntities, success: success, failure: failure)
    }
}