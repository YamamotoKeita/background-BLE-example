//
//  AppDelegate.swift
//  HandsfreeUnlocker
//
//  Created by 山本敬太 on 2020/10/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocalNotification.shared.requestPermission()
        HandsfreeUnlocker.shared.prepare()
        return true
    }
}

