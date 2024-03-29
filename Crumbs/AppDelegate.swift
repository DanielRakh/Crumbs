//
//  AppDelegate.swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import UIKit
import Swinject
import CoreLocation
import RealmSwift

//TODO: MAKE SURE TO MODIFY APP TRANSPORT SECURITY OR YOUR SHIT WILL GET REJECTED!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    
    
    var container: Container! {
        let container = Container()
        
        // Models
        container.register(CBNetworking.self){ _ in CBNetworkingService() }
        container.register(CBCrumbFetching.self) { r in
            CBCrumbFetcher(networking: r.resolve(CBNetworking.self)!)
        }
        
        // View Models
        container.register(CBCrumbsTableViewModeling.self) { r in
            CBCrumbsTableViewModel(crumbFetcher: r.resolve(CBCrumbFetching.self)!, networking: r.resolve(CBNetworking.self)!)
        }
        container.register(CBCrumbsMapViewModeling.self) { r in
            CBCrumbsMapViewModel(networking: r.resolve(CBNetworking.self)!)
        }
        
        // Views
        container.registerForStoryboard(CBCrumbsTableViewController.self) { r, c in
            c.viewModel = r.resolve(CBCrumbsTableViewModeling.self)!
        }
        
        container.registerForStoryboard(CBCrumbsMapViewController.self) { r, c in
            c.viewModel = r.resolve(CBCrumbsMapViewModeling.self)!
            
        }
        
        return container
    }
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        self.window = window
        
        let bundle = NSBundle(forClass: CBCrumbsTableViewController.self)
        let storyboard = SwinjectStoryboard.create(
            name: "Main",
            bundle: bundle,
            container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        return true
    }
    
    
    func handleReigonEvent(region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.sharedApplication().applicationState == .Active {
            if let message = titleFromRegionIdentifier(Int(region.identifier)!) {
                if let viewController = window?.rootViewController {
                    showSimpleAlertWithTitle(nil, message: "You've just found a 🍆 at: \(message)! 👱🏿", viewController: viewController)
                }
            }
        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            notification.alertBody = "You've just found a 🍆 at: \(titleFromRegionIdentifier(Int(region.identifier)!)!) 👱🏿"
            notification.soundName = "Default";
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleReigonEvent(region)
        }
    }
    
    
    func titleFromRegionIdentifier(identifier:Int) -> String? {
        
        do {
            let realm = try Realm()
            let savedItems = realm.objects(CBCrumbResponseEntity)
            
            for item in savedItems {
                if (item.id == identifier) {
                    return item.title
                }
            }
            
        } catch let error as NSError {
            showSimpleAlertWithTitle("Error!", message: "Error getting the name of the place for the geofence\(error.localizedDescription)", viewController: (UIApplication.sharedApplication().keyWindow?.rootViewController)!)
        }
        
        return nil
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


}

