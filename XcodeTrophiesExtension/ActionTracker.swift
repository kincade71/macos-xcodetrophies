import Foundation

final class ActionTracker {
    static let shared = ActionTracker()
    private init() {}

    func recordEdit(lineCount: Int) {
        MetricsStore.shared.increment(key: "linesEdited", by: lineCount)
        MetricsStore.shared.increment(key: "totalEdits", by: 1)
        let iso = ISO8601DateFormatter().string(from: Date())

    }
}
