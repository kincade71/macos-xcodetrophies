//
//  StatsStore.swift
//  XcodeTrophies
//
//  JSON-backed persistence for StatsState stored in the shared App Group container.
//

import Foundation

final class StatsStore {
    static let shared = StatsStore()

    private let url = AppGroupPaths.statsFileURL
    private let queue = DispatchQueue(label: "com.webdmg.xcodetrophies.stats.store")

    func load() -> StatsState {
        queue.sync {
            guard let data = try? Data(contentsOf: url) else {
                return StatsState(achievements: AchievementsCatalog.defaultList)
            }
            do {
                var state = try JSONDecoder().decode(StatsState.self, from: data)
                // Ensure newly added achievements appear while preserving earnedAt.
                state.achievements = AchievementsCatalog.merge(state.achievements)
                return state
            } catch {
                return StatsState(achievements: AchievementsCatalog.defaultList)
            }
        }
    }

    func save(_ state: StatsState) {
        queue.sync {
            do {
                let data = try JSONEncoder().encode(state)
                try data.write(to: url, options: [.atomic])
            } catch {
                // v1: ignore; add OSLog if desired
            }
        }
    }

    @discardableResult
    func update(_ mutate: (inout StatsState) -> Void) -> StatsState {
        var state = load()
        mutate(&state)
        state.lastUpdatedAt = .now
        save(state)
        return state
    }
}
