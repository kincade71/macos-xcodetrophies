//
//  DateKey.swift
//  xcodetrophies
//
//  Created by Richard Robinson on 12/31/25.
//

import Foundation

enum DateKey {
    static func dayString(_ date: Date, calendar: Calendar = .current) -> String {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let y = comps.year ?? 0
        let m = comps.month ?? 0
        let d = comps.day ?? 0
        return String(format: "%04d-%02d-%02d", y, m, d)
    }
}
