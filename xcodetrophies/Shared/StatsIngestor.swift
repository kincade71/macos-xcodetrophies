//
//  StatsIngestor.swift
//  XcodeTrophies
//
//  Reads queued events from the App Group container, applies them to StatsState,
//  persists the updated state, and returns any newly earned achievements.
//

import Foundation

enum StatsIngestor {
    /// Ingests all queued events.
    /// - Returns: Newly earned achievements (if any).
    @discardableResult
    static func ingestPendingEvents() -> [Achievement] {
        let events = EventQueue.drain()
        guard !events.isEmpty else { return [] }

        var newlyEarned: [Achievement] = []

        _ = StatsStore.shared.update { state in
            for event in events {
                let earned = AchievementsEngine.apply(event: event, to: &state)
                if !earned.isEmpty { newlyEarned.append(contentsOf: earned) }
            }
        }

        return newlyEarned
    }
}
