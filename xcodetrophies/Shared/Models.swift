//
//  Models.swift
//  xcodetrophies
//
//  Created by Richard Robinson on 12/31/25.
//

import Foundation

struct TrackedEvent: Codable, Hashable {
    var name: String               // e.g. "command.build"
    var timestamp: Date
    var metadata: [String: String] = [:]
}

struct Achievement: Codable, Hashable, Identifiable {
    var id: String                 // e.g. "first_build"
    var title: String
    var detail: String
    var metricKey: String          // e.g. "build.count"
    var threshold: Int
    var earnedAt: Date? = nil
}

struct StatsState: Codable, Hashable {
    var counters: [String: Int] = [:]               // "build.count": 12
    var daily: [String: [String: Int]] = [:]        // "2025-12-31": ["build.count": 3]
    var achievements: [Achievement] = []
    var recentEarned: [String] = []                 // achievement IDs newest-first
    var lastUpdatedAt: Date = .now
}
