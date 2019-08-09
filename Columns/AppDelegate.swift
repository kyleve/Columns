//
//  AppDelegate.swift
//  Columns
//
//  Created by Kyle Van Essen on 8/8/19.
//  Copyright © 2019 Kyle Van Essen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        self.window = window
        
        window.makeKeyAndVisible()
        
        
        return true
    }

}

