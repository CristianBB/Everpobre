//
//  AppDelegate.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 8/3/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
//        loadFakeCoreData()
        
        let masterVC = UINavigationController(rootViewController: NotebooksTableViewController())
        let detailVC = InstructionsViewController()
        
        let splitVC = UISplitViewController()
        splitVC.delegate = self
        splitVC.preferredDisplayMode = .allVisible
        splitVC.viewControllers = [masterVC, detailVC]
        
        window?.rootViewController = splitVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
