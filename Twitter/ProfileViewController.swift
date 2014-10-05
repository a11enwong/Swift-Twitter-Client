//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 03/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

class ProfileViewController: BaseStatusViewController, UIScrollViewDelegate {
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
        profileHeaderView?.show(user!)
        self.view.addSubview(profileHeaderView!)
        self.view.sendSubviewToBack(profileHeaderView!)

        
        let headerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: HEADER_HEIGHT)
        let transparentView = UIView(frame: headerFrame)
        transparentView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = transparentView
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    //getStatusesHomeTimelineWithCount
    override func abstractGetStatuses(count: Int?, sinceID: Int?, maxID: Int?, trimUser: Bool?, contributorDetails: Bool?,
        includeEntities: Bool?, success: ((statuses: [JSONValue]?) -> Void)?, failure: Swifter.FailureHandler?) {
            swifter.getStatusesUserTimelineWithUserID(String(user!.userId!), count: count, sinceID: sinceID, maxID: maxID, trimUser: trimUser,
                contributorDetails: contributorDetails, includeEntities: includeEntities, success: success, failure: failure)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("view scrolled \(tableView.contentOffset.y)")
        
        let offset = tableView.contentOffset.y
        
        if offset < 0 {
            profileHeaderView?.frame.size.height = HEADER_HEIGHT + (-1 * offset)
            profileHeaderView?.center.y = (profileHeaderView!.frame.size.height / 2)
        } else if offset > 0 {
            profileHeaderView?.center.y = (HEADER_HEIGHT / 2) - offset
        }
    }
}