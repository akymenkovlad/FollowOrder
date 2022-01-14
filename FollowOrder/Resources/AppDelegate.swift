//
//  AppDelegate.swift
//  FollowOrder
//
//  Created by Valados on 11.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard UserDefaults.standard.value(forKey: "track") == nil else { return true }
        let networkManager = NetworkManager()
        if var urlComponents = URLComponents(string: "http://apps.vortexads.io/guest") {
            urlComponents.query = "uuid=123&app=TestAppVlad"
            guard let url = urlComponents.url else { return true }
            networkManager.request(fromURL: url) { (result: Result<AppVersion, Error>) in
                switch result {
                case .success(let version):
                    debugPrint("We got a successful result: \(version).")
                    guard version.status == true else { return }
                    guard let track = version.track else { return }
                    UserDefaults.standard.register(defaults: ["track":track])
                    UserDefaults.standard.set(track, forKey: "track")
                    print(UserDefaults.standard.value(forKey: "track") as! String)
                    NotificationCenter.default.post(name: Notification.Name("Track"), object: nil)
                case .failure(let error):
                    debugPrint("We got a failure trying to get the data. The error we got was: \(error.localizedDescription)")
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
}

