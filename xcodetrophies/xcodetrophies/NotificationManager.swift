//
//  NotificationManager.swift
//  XcodeTrophies
//
//  Local notifications for newly earned achievements.
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    /// Keep track of which achievement IDs we've already notified about,
    /// to prevent duplicates across app launches.
    private let notifiedKey = "com.webdmg.xcodetrophies.notifiedAchievementIDs"

    func requestAuthorizationIfNeeded() async {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .notDetermined else { return }

        _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func notifyForNewAchievements(_ achievements: [Achievement]) {
        guard !achievements.isEmpty else { return }

        var notified = Set(UserDefaults.standard.stringArray(forKey: notifiedKey) ?? [])

        for a in achievements {
            guard !notified.contains(a.id) else { continue }
            scheduleNotification(for: a)
            notified.insert(a.id)
        }

        UserDefaults.standard.set(Array(notified), forKey: notifiedKey)
    }

    private func scheduleNotification(for achievement: Achievement) {
        let content = UNMutableNotificationContent()
        content.title = "🏆 Achievement Unlocked"
        content.body = "\(achievement.title) — \(achievement.detail)"
        content.sound = .default

        // Deliver almost immediately.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "achievement.\(achievement.id)", content: content, trigger: trigger)

        center.add(request)
    }
}
