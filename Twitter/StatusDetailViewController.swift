//
//  StatusDetailViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 27/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class StatusDetailViewController: UIViewController {

    @IBOutlet weak var userHeaderView: UserHeaderView!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    
    var status: TwitterStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusTextView.text = status?.rootStatus.text
        textHeightConstraint.constant = self.heightForTextView() + 18.0
        
        userHeaderView.loadUser(status!.rootStatus.user!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func heightForTextView() -> CGFloat {
        let screenRect = UIScreen.mainScreen().bounds
        var width = isPortraitOrientation() ? screenRect.size.width : screenRect.size.height
        width -= 40
        statusTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        
        let text = statusTextView.text as NSString
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18)]
        let size = CGSizeMake(CGFloat(width), CGFloat(MAXFLOAT))

        let textRect = text.boundingRectWithSize(size,
            options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        
        return textRect.size.height
    }
    
    func isPortraitOrientation() -> Bool {
        return UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.Portrait
    }
    

}
