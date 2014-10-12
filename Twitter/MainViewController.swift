//
//  MainViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 02/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MenuViewControllerDelegate {
    @IBOutlet var menuContainer: UIView!
    @IBOutlet var contentContainer: UIView!
    @IBOutlet var menuLeftConstraint: NSLayoutConstraint!
    var showingMenu = false
    var swifter = SwifterApi.sharedInstance
    var controllers = [String: UIViewController]()
    var currentUser: TwitterUser?
    
    var activeViewController: UIViewController? {
        didSet(oldViewController) {
            if activeViewController == oldViewController {
                return
            }
            
            if let oldVC = oldViewController {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentContainer.bounds
                self.contentContainer.addSubview(newVC.view)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        title = "Home"
        navigationController?.navigationBar.barTintColor = ColorPalette.Blue.get()
        navigationController?.navigationBar.titleTextAttributes = NSDictionary(
            object: ColorPalette.White.get(), forKey: NSForegroundColorAttributeName)
        
        let menuImage = UIImage(named: "menu").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationItem.leftBarButtonItem?.image = menuImage
        navigationItem.leftBarButtonItem?.tintColor = ColorPalette.White.get()
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.action = "toggleMenu"
        
        let composeImage = UIImage(named: "compose").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationItem.rightBarButtonItem?.image = composeImage
        navigationItem.rightBarButtonItem?.tintColor = ColorPalette.White.get()
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = "composeTweet"
        
        let data = NSUserDefaults.standardUserDefaults().objectForKey("account") as NSData?
        let account = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as TwitterAccount
        currentUser = account.user
        
        showContainers()
    }
    
    func getController(name: String, generator: () -> UIViewController) -> UIViewController {
        if controllers[name] == nil {
            controllers[name] = generator()
        }
        
        return controllers[name]!
    }
    
    func showContainers() {
        println("screen \(UIScreen.mainScreen().bounds.width), container \(contentContainer.frame.width)")
        
        activeViewController = getController("home", generator: { () -> UIViewController in
            HomeViewController(nibName: "BaseStatusViewController", bundle: nil)
        })
        
        var menuController = getController("menu", generator: { () -> UIViewController in
            var controller = MenuViewController(nibName: "MenuViewController", bundle: nil)
            controller.delegate = self
            return controller
        })
        addChildViewController(menuController)
        menuController.didMoveToParentViewController(self)
        menuController.view.frame = menuContainer.bounds
        self.view.layoutIfNeeded()
        menuContainer.addSubview(menuController.view)
        menuLeftConstraint.constant = menuContainer.frame.width * -1 - 16
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateMenu(constant: CGFloat) {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.menuLeftConstraint.constant = constant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closeMenu() {
        animateMenu(menuContainer.frame.width * -1 - 16)
    }
    
    func toggleMenu() {
        if menuLeftConstraint.constant == -16.0 {
            closeMenu()
        } else {
            animateMenu(-16.0)
        }
    }
    

    @IBAction func handleContainerTab(sender: AnyObject) {
        closeMenu()
    }

    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        println("screen \(UIScreen.mainScreen().bounds.width), container \(contentContainer.frame.width)")
        if !showingMenu && sender.state != .Began {
            return
        }
        
        let maxValue : CGFloat = -16.0
        let currentValue = menuLeftConstraint.constant
        let minValue = menuContainer.frame.width * -1 - 16
        var translation = sender.translationInView(view)
        var newConstant = currentValue + translation.x
        
        switch sender.state {
        case .Began:
            println(sender.locationInView(view))
            let xTab = sender.locationInView(view).x
            if xTab < 64 {
                showingMenu = true
            } else if menuLeftConstraint.constant == maxValue {
                showingMenu = true
            } else {
                false
            }
            
            println("start dragging \(showingMenu)")
        case .Changed:

            if (currentValue > newConstant && newConstant > minValue)
            || (currentValue < newConstant && newConstant < maxValue)  {
                menuLeftConstraint.constant = newConstant
            }
            sender.setTranslation(CGPointZero, inView: view)
            println(newConstant)
        case .Ended, .Cancelled, .Failed:
            println("3 menu width \(menuContainer.frame.width)")
                    println("constraint \(menuContainer.frame.width * -1 - 16)")
                    
            let vel = sender.velocityInView(view)
            
            println("vel \(vel.x)")
            
            if vel.x < -1000 {
                newConstant = minValue
            } else if vel.x > 1000 {
                newConstant = maxValue
            }else if newConstant < maxValue - menuContainer.frame.width / 2 {
                newConstant = minValue
            } else {
                newConstant = maxValue
            }
            
            println("final constant \(newConstant)")
            
            animateMenu(newConstant)
            
            showingMenu = false
        default:
            println("some state")
        }
    }
    
    func onSignOut() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "account")
        swifter.client.credential = nil
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func menuViewOnClick(item: MenuViewControllerItems) {
        println("menu clicked")
        switch item {
        case .Profile:
            activeViewController = getController("profile", generator: { () -> UIViewController in
                var controller = ProfileViewController(nibName: "BaseStatusViewController", bundle: nil)
                controller.user = self.currentUser
                return controller
            })
        case .Timeline:
            activeViewController = getController("home", generator: { () -> UIViewController in
                HomeViewController(nibName: "BaseStatusViewController", bundle: nil)
            })
        case .Mentions:
            activeViewController = getController("mentions", generator: { () -> UIViewController in
                MentionsViewController(nibName: "BaseStatusViewController", bundle: nil)
            })
        case .Logout:
            onSignOut()
        default:
            println("another view controller")
            
        }
        closeMenu()
    }
    
    func composeTweet() {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("ComposeNavigationController") as UINavigationController
        let controller = navigationController.viewControllers.first as ComposeViewController
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
}
