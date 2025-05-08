//
//  AppDelegate.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

// AppDelegate.swift

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("AppDelegate: Application did finish launching")
        
        // For iOS 12 and below
        if #available(iOS 13.0, *) {
            print("AppDelegate: Using Scene lifecycle (iOS 13+)")
        } else {
            print("AppDelegate: Using Window-based lifecycle (iOS 12)")
            window = UIWindow(frame: UIScreen.main.bounds)
            
            // Create your initial view controller
            let initialVC = SplashViewController()
            // Or use your EmergencyViewController for testing
            // let initialVC = EmergencyViewController()
            
            window?.rootViewController = initialVC
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("AppDelegate: Configuration for connecting scene session")
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("AppDelegate: Did discard scene sessions")
        
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
