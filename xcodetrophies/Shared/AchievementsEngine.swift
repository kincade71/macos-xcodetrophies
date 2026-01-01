//
//  AchievementsEngine.swift
//  xcodetrophies
//
//  Created by Richard Robinson on 12/31/25.
//

import Foundation

struct AchievementsEngine {
    static func apply(event: TrackedEvent, to state: inout StatsState) -> [Achievement] {
        // 1) increment counters
        let day = DateKey.dayString(event.timestamp)

        func inc(_ key: String, by amount: Int = 1) {
            state.counters[key, default: 0] += amount
            state.daily[day, default: [:]][key, default: 0] += amount
        }

        switch event.name {
        case "command.build":
            inc("build.count")
        case "command.test":
            inc("test.count")
        case "lines.edited":
            let n = Int(event.metadata["count"] ?? "0") ?? 0
            if n > 0 { inc("lines.edited", by: n) }
        default:
            break
        }

        // 2) check achievements
        var newlyEarned: [Achievement] = []

        for i in state.achievements.indices {
            guard state.achievements[i].earnedAt == nil else { continue }
            let a = state.achievements[i]
            let current = state.counters[a.metricKey, default: 0]
            if current >= a.threshold {
                state.achievements[i].earnedAt = .now
                newlyEarned.append(state.achievements[i])
                state.recentEarned.removeAll(where: { $0 == a.id })
                state.recentEarned.insert(a.id, at: 0)
            }
        }

        return newlyEarned
    }
}
