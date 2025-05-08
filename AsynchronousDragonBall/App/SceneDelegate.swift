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
        print("SceneDelegate: Will connect scene to session")
        
        guard let windowScene = (scene as? UIWindowScene) else {
            print("SceneDelegate: Failed to cast scene to UIWindowScene")
            return
        }
        
        print("SceneDelegate: Creating window with scene")
        window = UIWindow(windowScene: windowScene)
        
        // Create your initial view controller
        let initialVC = SplashViewController()
        // Or use your EmergencyViewController for testing
        // let initialVC = EmergencyViewController()
        
        window?.rootViewController = initialVC
        
        print("SceneDelegate: Making window key and visible")
        window?.makeKeyAndVisible()
        
        // Verify window is properly set up
        DispatchQueue.main.async {
            print("SceneDelegate: Window key status = \(self.window?.isKeyWindow ?? false)")
            print("SceneDelegate: Window is hidden = \(self.window?.isHidden ?? true)")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("SceneDelegate: Scene did disconnect")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("SceneDelegate: Scene did become active")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("SceneDelegate: Scene will resign active")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("SceneDelegate: Scene will enter foreground")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("SceneDelegate: Scene did enter background")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

