import Foundation
import Combine

final class MetricsStore: ObservableObject {
    static let shared = MetricsStore()

    @Published private(set) var linesEdited: Int = 0

    private let defaults: UserDefaults

    private init() {
        defaults = UserDefaults(suiteName: AppGroup.identifier) ?? .standard
        linesEdited = defaults.integer(forKey: "linesEdited")
    }

    func increment(key: String, by value: Int) {
        guard key == "linesEdited" else { return }
        linesEdited += value
        defaults.set(linesEdited, forKey: key)
    }
}
