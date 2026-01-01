//
//  XcodeTrophiesApp.swift
//  XcodeTrophies
//
//  Companion macOS app entry point.
//

import SwiftUI

@main
struct XcodeTrophiesApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .task {
                    await NotificationManager.shared.requestAuthorizationIfNeeded()
                }
        }
    }
}
