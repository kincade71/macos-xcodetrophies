//
//  AchievementsCatalog.swift
//  xcodetrophies
//
//  Created by Richard Robinson on 12/31/25.
//

import Foundation

enum AchievementsCatalog {
    static let defaultList: [Achievement] = [
        .init(id: "first_build", title: "First Build", detail: "You ran your first build.", metricKey: "build.count", threshold: 1),
        .init(id: "build_10", title: "Builder x10", detail: "10 builds completed.", metricKey: "build.count", threshold: 10),
        .init(id: "test_1", title: "First Test Run", detail: "You ran tests once.", metricKey: "test.count", threshold: 1),
        .init(id: "test_25", title: "Test Pilot", detail: "25 test runs.", metricKey: "test.count", threshold: 25),
        .init(id: "lines_1000", title: "1K Lines", detail: "You edited 1,000 lines.", metricKey: "lines.edited", threshold: 1000),
    ]

    static func merge(_ existing: [Achievement]) -> [Achievement] {
        // keep earnedAt from existing, but ensure new ones appear
        let byID = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })
        return defaultList.map { a in
            if let old = byID[a.id] { return Achievement(id: a.id, title: a.title, detail: a.detail, metricKey: a.metricKey, threshold: a.threshold, earnedAt: old.earnedAt) }
            return a
        }
    }
}
