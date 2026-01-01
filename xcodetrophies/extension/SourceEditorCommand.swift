//
//  SourceEditorCommand.swift
//  XcodeTrophiesExtension
//
//  Commands for the Xcode Source Editor Extension.
//

import Foundation
import AppKit
import XcodeKit

// MARK: - Tracking Commands

/// Tracks a "build" milestone event.
final class TrackBuildCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {

        let event = TrackedEvent(
            name: "command.build",
            timestamp: .now,
            metadata: [
                // Best-effort context (XcodeKit does not expose full project metadata)
                "fileUTI": invocation.buffer.contentUTI
            ]
        )

        _ = StatsStore.shared.update { state in
            _ = AchievementsEngine.apply(event: event, to: &state)
        }

        // Nudge companion app to refresh.
        UpdateSignal.post()

        completionHandler(nil)
    }
}

/// Tracks a "test" milestone event.
final class TrackTestCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {

        let event = TrackedEvent(
            name: "command.test",
            timestamp: .now,
            metadata: [
                "fileUTI": invocation.buffer.contentUTI
            ]
        )

        _ = StatsStore.shared.update { state in
            _ = AchievementsEngine.apply(event: event, to: &state)
        }

        UpdateSignal.post()

        completionHandler(nil)
    }
}

// MARK: - Companion App Commands

/// Brings the companion app to the foreground (or launches it) so the user can view Stats.
final class ShowStatsCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {

        CompanionAppLauncher.activateCompanionApp()
        completionHandler(nil)
    }
}

/// Brings the companion app to the foreground (or launches it) so the user can view Awards.
final class ShowAwardsCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {

        CompanionAppLauncher.activateCompanionApp()
        completionHandler(nil)
    }
}

// MARK: - Helper

enum CompanionAppLauncher {
    /// Must match the macOS companion app bundle identifier.
    private static let companionBundleID = "com.webdmg.xcodetrophies"

    static func activateCompanionApp() {
        // Prefer bundle identifier launch (works for installed apps and for dev runs).
        let workspace = NSWorkspace.shared
        let didLaunch = workspace.launchApplication(withBundleIdentifier: companionBundleID,
                                                   options: [.default],
                                                   additionalEventParamDescriptor: nil,
                                                   launchIdentifier: nil)

        if !didLaunch {
            // Fallback: try to open via URL scheme if you've configured it later.
            if let url = URL(string: "xcodetrophies://") {
                workspace.open(url)
            }
        }
    }
}
