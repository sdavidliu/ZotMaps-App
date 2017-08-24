//
//  AppDelegate.swift
//  ZotMaps
//
//  Created by DL on 8/21/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    struct Database {
        static var destinations = [Destination]()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        let ref = FIRDatabase.database().reference()

        ref.observe(.value, with: { snapshot in
            
            let data = (snapshot.value! as AnyObject).object(forKey: "Destinations")! as! Dictionary<String,Dictionary<String,AnyObject>>
            //print(data)
            for location in data {
                Database.destinations.append(Destination(name: location.key, category: location.value["Category"] as! String, lat: location.value["Lat"] as! Double, long: location.value["Long"] as! Double))
            }
            
            
        }, withCancel: {
            (error:Error) -> Void in
            print(error.localizedDescription)
        })
        
        UserDefaults.standard.set(0.0, forKey: "Lat")
        UserDefaults.standard.set(0.0, forKey: "Long")
        UserDefaults.standard.set("", forKey: "Name")
        UserDefaults.standard.synchronize()
        
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
    }


}

