//
//  MenuViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 02/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate {
    func menuViewOnClick(item: MenuViewControllerItems)
}

enum MenuViewControllerItems: Int {
    case Profile = 0, Timeline, Mentions, Logout
    
    static let allValues = [Profile, Timeline, Mentions, Logout]
    
    func menuName() -> String {
        switch self {
        case .Profile:
            return "Profile"
        case .Timeline:
            return "Timeline"
        case .Mentions:
            return "Mentions"
        case .Logout:
            return "Logout"
        }
    }
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: MenuViewControllerDelegate?
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let data = NSUserDefaults.standardUserDefaults().objectForKey("account") as NSData?
        let account = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as TwitterAccount
        var headerView = MenuProfileHeaderView(frame: CGRectMake(0, 0, tableView.frame.width, 62))
        headerView.user = account.user
        tableView.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(20.0)
        cell.textLabel?.text = MenuViewControllerItems.fromRaw(indexPath.row)?.menuName()
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.selectionStyle = .None;
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuViewControllerItems.allValues.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected row \(MenuViewControllerItems.fromRaw(indexPath.row)?.menuName())")
        delegate?.menuViewOnClick(MenuViewControllerItems.fromRaw(indexPath.row)!)
    }

}
