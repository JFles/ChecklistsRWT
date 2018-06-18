//
//  AppDelegate.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/9/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder,
                   UIApplicationDelegate,
                   UNUserNotificationCenterDelegate{

    var window: UIWindow?
    let dataModel = DataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // exposing dataModel to AllListsVC to prevent nil crash
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        
        //notification authorization
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        /*
        // local notification test code
 
        // request user permission to send local notifications
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            if granted {
                print("Permission granted")
                //setting delegate to handle local notifications while the app is in the foreground
                notificationCenter.delegate = self
            } else {
                print("Permission denied")
            }
        }
        
        // build notification content
        let content = UNMutableNotificationContent()
        content.title = "Hello!"
        content.body = "I am a local notification!"
        content.sound = UNNotificationSound.default()
        // build trigger
        let trigger = UNTimeIntervalNotificationTrigger(
                                           timeInterval: 10, repeats: false)
        // build request using content and trigger
        let request = UNNotificationRequest(
                                 identifier: "MyNotification",
                                    content: content,
                                    trigger: trigger)
        // add request to NotificationCenter
        notificationCenter.add(request)
        */
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    
    //MARK: - User Notification Delegate Methods
    // behavior for when the app is still in the foreground since the app delegate is still the UN delegate
    func userNotificationCenter(
                       _ center: UNUserNotificationCenter,
       willPresent notification: UNNotification,
       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("Received local notification \(notification)")
        
        // displays the alert with the app in the foreground?
        return completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    // MARK: - Custom Functions
    func saveData() {
        dataModel.saveChecklists()
    }
}

