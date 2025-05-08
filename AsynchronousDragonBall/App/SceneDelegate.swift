//
//  SceneDelegate.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create window
        window = UIWindow(windowScene: windowScene)
        
        // Start with a SplashController that will then determine whether to show login or main flow
        let splashController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashController)
        
        // Set as root and make visible
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // Other required SceneDelegate methods...
}
