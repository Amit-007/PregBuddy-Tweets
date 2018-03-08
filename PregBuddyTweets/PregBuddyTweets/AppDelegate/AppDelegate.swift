//
//  AppDelegate.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func tabBarController() -> UITabBarController{
        
        let tabBarController = UITabBarController()
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        let bookmarksViewController = BookmarksViewController()
        bookmarksViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let controllers = [homeViewController, bookmarksViewController]
        tabBarController.viewControllers = controllers
        return tabBarController
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        setupWindow()
        TwitterWrapper.shared().instantiateTwitter()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataWrapper.shared().saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }

}

extension AppDelegate{
    
    fileprivate func setupWindow(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let signInController = SignInController()
        navigationController = UINavigationController(rootViewController: signInController)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        setupNavigationBarAppearance()
    }
    
    
    
    private func setupNavigationBarAppearance(){
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            let attributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
            navigationController?.navigationBar.isTranslucent = true
        } else {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            UINavigationBar.appearance().isTranslucent = true
        }
    }
    
}




