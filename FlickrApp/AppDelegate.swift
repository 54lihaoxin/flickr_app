//
//  AppDelegate.swift
//  FlickrApp
//
//  Created by Haoxin Li on 2/26/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window.rootViewController = UINavigationController(rootViewController: SearchPhotoViewController())
        window.makeKeyAndVisible()
        return true
    }
}
