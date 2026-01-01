//
//  AppGroupPaths.swift
//  xcodetrophies
//
//  Created by Richard Robinson on 12/31/25.
//

import Foundation

enum AppGroupPaths {
    static let groupID = "group.com.webdmg.xcodetrophies"

    static var containerURL: URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) else {
            fatalError("Missing App Group container. Check entitlements for \(groupID).")
        }
        return url
    }

    static var statsFileURL: URL {
        containerURL.appendingPathComponent("stats.json")
    }
}
