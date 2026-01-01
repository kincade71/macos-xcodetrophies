//
//  EventQueue.swift
//  XcodeTrophies
//
//  A tiny JSON-backed queue stored in the App Group container.
//  The Xcode extension enqueues events; the macOS app ingests and clears them.
//

import Foundation

enum EventQueue {
    private static let url = AppGroupPaths.eventsFileURL
    private static let queue = DispatchQueue(label: "com.webdmg.xcodetrophies.eventqueue")

    static func enqueue(_ event: TrackedEvent) {
        queue.sync {
            var events = loadUnsafe()
            events.append(event)
            saveUnsafe(events)
        }
    }

    /// Atomically fetches all pending events and clears the queue.
    static func drain() -> [TrackedEvent] {
        queue.sync {
            let events = loadUnsafe()
            saveUnsafe([])
            return events
        }
    }

    // MARK: - Private

    private static func loadUnsafe() -> [TrackedEvent] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([TrackedEvent].self, from: data)) ?? []
    }

    private static func saveUnsafe(_ events: [TrackedEvent]) {
        do {
            let data = try JSONEncoder().encode(events)
            try data.write(to: url, options: [.atomic])
        } catch {
            // v1: ignore; add OSLog if desired
        }
    }
}
