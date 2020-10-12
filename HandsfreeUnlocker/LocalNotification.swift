//
//  LocalNotification.swift
//  HandsfreeUnlocker
//
//  Created by 山本敬太 on 2020/10/12.
//

import UIKit

class LocalNotification {
    static let shared = LocalNotification()

    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in })
    }


    func notify(title: String, text: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
