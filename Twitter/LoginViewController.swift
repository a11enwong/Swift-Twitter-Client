//
//  LoginViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 25/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit
import SwifteriOS

class LoginViewController: UIViewController {

    private var swifter = SwifterApi.sharedInstance
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if let key = defaults.objectForKey("key") as? String {
            let secret = defaults.objectForKey("secret") as String
            let credentialToken = SwifterCredential.OAuthAccessToken(key: key, secret: secret)
            swifter.client.credential = SwifterCredential(accessToken: credentialToken)
            goToHomeController()
        }
    }
    
    
    @IBAction func didTouchUpInsideLoginButton(sender: AnyObject) {
        swifter.client.credential = nil
        
        let failureHandler: ((NSError) -> Void) = {
            error in
            
            println("error")
            println(error)
        }
        

        swifter.authorizeWithCallbackURL(NSURL(string: "codepathtwitter://success"), success: {
            accessToken, response in
                println("logged with tweeter")
                let account = self.swifter.client.credential?.account
                println(self.swifter.client.credential!.accessToken?.key)
                println(self.swifter.client.credential!.accessToken?.secret)
                let accessToken = self.swifter.client.credential!.accessToken!
                self.defaults.setObject(accessToken.key, forKey: "key")
                self.defaults.setObject(accessToken.secret, forKey: "secret")

                self.goToHomeController()
            },failure: failureHandler
        )
    }
    
    func goToHomeController() {
        let mainNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as UINavigationController
        
        presentViewController(mainNavigationController, animated: true, completion: nil)
    }
    
    func fetchTwitterHomeStream() {
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("error fetching tweets")
            println(error)
        }
        
        println(swifter.client.credential?.accessToken?.key)
        swifter.getStatusesHomeTimelineWithCount(20, sinceID: nil, maxID: nil, trimUser: true,
            contributorDetails: false, includeEntities: true, success: {
                (statuses: [JSONValue]?) in
                println("fetched successfully")
            }, failure: failureHandler)
    }

}
