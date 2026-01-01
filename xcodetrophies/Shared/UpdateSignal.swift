import Foundation

/// Distributed notification used to signal that the shared StatsState changed.
/// This allows the Xcode extension to "poke" the companion app to refresh.
enum UpdateSignal {
    static let name = Notification.Name("MilestonesStatsDidUpdate")

    static func post() {
        DistributedNotificationCenter.default().post(name: name, object: nil)
    }

    static func observe(_ handler: @escaping () -> Void) -> NSObjectProtocol {
        DistributedNotificationCenter.default().addObserver(forName: name, object: nil, queue: .main) { _ in
            handler()
        }
    }
}
