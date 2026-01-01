//
//  DashboardView.swift
//  XcodeTrophies
//
//  Companion dashboard (Stats + Awards).
//

import SwiftUI
import Foundation
import Combine

@MainActor
final class DashboardVM: ObservableObject {
    
    @Published var state: StatsState = StatsStore.shared.load()

    private var updateObserver: NSObjectProtocol?

    func start() {
        // Initial load
        state = StatsStore.shared.load()

        // Refresh when the extension writes + posts UpdateSignal
        updateObserver = UpdateSignal.observe { [weak self] in
            guard let self else { return }
            self.state = StatsStore.shared.load()
        }
    }

    func stop() {
        if let updateObserver {
            DistributedNotificationCenter.default().removeObserver(updateObserver)
        }
        updateObserver = nil
    }
}

struct DashboardView: View {
    @StateObject private var vm = DashboardVM()

    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    StatsView(state: vm.state)
                } label: {
                    Label("Stats", systemImage: "chart.bar")
                }

                NavigationLink {
                    AwardsView(state: vm.state)
                } label: {
                    Label("Awards", systemImage: "trophy")
                }
            }
            .navigationTitle("Xcode Trophies")
        } detail: {
            StatsView(state: vm.state)
        }
        .task { vm.start() }
        .onDisappear { vm.stop() }
    }
}

// MARK: - Stats

struct StatsView: View {
    let state: StatsState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    StatCard(title: "Builds", value: state.counters["build.count", default: 0], systemImage: "hammer")
                    StatCard(title: "Tests", value: state.counters["test.count", default: 0], systemImage: "checkmark.seal")
                    StatCard(title: "Lines", value: state.counters["lines.edited", default: 0], systemImage: "text.line.first.and.arrowtriangle.forward")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent")
                        .font(.headline)

                    if let newestID = state.recentEarned.first,
                       let a = state.achievements.first(where: { $0.id == newestID }),
                       let earnedAt = a.earnedAt {
                        AchievementRow(title: a.title, detail: a.detail, subtitle: "Unlocked \(earnedAt.formatted(date: .abbreviated, time: .shortened))", isEarned: true)
                    } else {
                        Text("No achievements unlocked yet. Use the Xcode extension commands to start tracking.")
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Storage")
                        .font(.headline)

                    Text("App Group: \(AppGroupPaths.groupID)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("File: \(AppGroupPaths.statsFileURL.path)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
        }
        .navigationTitle("Stats")
    }
}

struct StatCard: View {
    let title: String
    let value: Int
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text("\(value)")
                .font(.system(size: 28, weight: .bold))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Awards

struct AwardsView: View {
    let state: StatsState

    private var earned: [Achievement] {
        state.achievements
            .filter { $0.earnedAt != nil }
            .sorted { ($0.earnedAt ?? .distantPast) > ($1.earnedAt ?? .distantPast) }
    }

    private var locked: [Achievement] {
        state.achievements
            .filter { $0.earnedAt == nil }
    }

    var body: some View {
        List {
            Section("Earned") {
                if earned.isEmpty {
                    Text("No awards yet — unlock your first one from Xcode: Editor → XcodeTrophies → Track Build/Test")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(earned) { a in
                        AchievementRow(
                            title: a.title,
                            detail: a.detail,
                            subtitle: a.earnedAt.map { "Unlocked \($0.formatted(date: .abbreviated, time: .shortened))" } ?? "Unlocked",
                            isEarned: true
                        )
                    }
                }
            }

            Section("Locked") {
                ForEach(locked) { a in
                    let current = state.counters[a.metricKey, default: 0]
                    AchievementRow(
                        title: a.title,
                        detail: a.detail,
                        subtitle: "Progress: \(current)/\(a.threshold)",
                        isEarned: false
                    )
                }
            }
        }
        .navigationTitle("Awards")
    }
}

struct AchievementRow: View {
    let title: String
    let detail: String
    let subtitle: String
    let isEarned: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isEarned ? "trophy.fill" : "trophy")
                .foregroundStyle(isEarned ? .yellow : .secondary)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(detail)
                    .foregroundStyle(.secondary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    DashboardView()
}

