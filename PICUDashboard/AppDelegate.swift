//
//  AppDelegate.swift
//  PICUDashboard
//
//  Created by LurieLocalAdmin on 7/23/19.
//  Copyright © 2019 Lurie Children's Hospital. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIScreen.main.brightness = CGFloat(1.0)
        
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 4.0)
        
        application.isIdleTimerDisabled = true //this will allow app to remain active with no sleep capability
        
        print("application event fired")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //UIScreen.main.brightness = CGFloat(1.0)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //UIScreen.main.brightness = CGFloat(1.0)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
        print("Screen Brightness from WillEnterForeground: \(UIScreen.main.brightness)")
        print("isIdleTimerDisabled: \(application.isIdleTimerDisabled)")
        //Thread.sleep(forTimeInterval: 1.5)
        //UIScreen.main.brightness = CGFloat(1.0)
        print("Screen Brightness from WillEnterForeground: \(UIScreen.main.brightness)")
        //print("applicationWillEnterForeground")
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Screen Brightness from DidBecomeActive: \(UIScreen.main.brightness)")
        //Thread.sleep(forTimeInterval: 1.5)
        UIScreen.main.brightness = CGFloat(1.0)
        //UIScreen.main.animateBrightness()
        print("Screen Brightness from DidBecomeActive: \(UIScreen.main.brightness)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //UIScreen.main.brightness = CGFloat(1.0)
        //UIScreen.main.brightness = CGFloat(1.0)
    }


}

