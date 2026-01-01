import SwiftUI

struct DashboardView: View {
    @StateObject private var stats = MetricsStore.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Xcode Trophies")
                    .font(.largeTitle)
                    .bold()

                Text("Lines Edited: \(stats.linesEdited)")
                    .font(.title2)

                NavigationLink("View Trophies") {
                    StatsView()
                }
            }
            .padding()
        }
    }
}
