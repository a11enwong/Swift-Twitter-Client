//
//  MainViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 02/10/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var menuContainer: UIView!
    @IBOutlet var contentContainer: UIView!
    @IBOutlet var menuLeftConstraint: NSLayoutConstraint!
    var showingMenu = false
    
    var controllers = [String: UIViewController]()
    
    var activeViewController: UIViewController? {
        didSet(oldViewController) {
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
        
        title = "Home"
        navigationController?.navigationBar.barTintColor = ColorPalette.Blue.get()
        navigationController?.navigationBar.titleTextAttributes = NSDictionary(
            object: ColorPalette.White.get(), forKey: NSForegroundColorAttributeName)

    }
    
    func getController(name: String, generator: () -> UIViewController) -> UIViewController {
        if controllers[name] == nil {
            controllers[name] = generator()
        }
        
        return controllers[name]!
    }
    
    override func viewDidAppear(animated: Bool) {
        println("screen \(UIScreen.mainScreen().bounds.width), container \(contentContainer.frame.width)")
        
        activeViewController = getController("menu", generator: { () -> UIViewController in
            return self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
        })
        
        
        var menuController = MenuViewController(nibName: "MenuViewController", bundle: nil)
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
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.menuLeftConstraint.constant = constant
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    

    @IBAction func handleContainerTab(sender: AnyObject) {
        animateMenu(menuContainer.frame.width * -1 - 16)
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
}
