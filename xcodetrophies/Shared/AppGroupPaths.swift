//
//  AppGroupPaths.swift
//  xcodetrophies
//
//  Created by Richard Robinson on 12/31/25.
//

import Foundation

enum AppGroupPaths {
    /// App Group used by BOTH the companion macOS app and the Xcode Source Editor Extension.
    ///
    /// This must match the value in BOTH targets' entitlements.
    static let groupID = "group.com.webdmg.xcodextension"

    static var containerURL: URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) else {
            fatalError("Missing App Group container. Check entitlements for \(groupID).")
        }
        return url
    }

    static var statsFileURL: URL {
        containerURL.appendingPathComponent("stats.json")
    }

    static var eventsFileURL: URL {
        containerURL.appendingPathComponent("events.json")
    }
}
