//
//  SceneDelegate.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
    
        if UserDefaults.standard.value(forKey: "needToShowOnboarding") == nil {
            window.rootViewController = OnboardingViewController()
        } else {
            window.rootViewController = TabBarController()
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.saveContext(CoreDataStack.shared.context)
    }
}

