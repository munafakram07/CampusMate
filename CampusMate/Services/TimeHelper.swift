//
//  TimeHelper.swift
//  CampusMate
//
//  Created by KIET43 on 23/10/26.
//

import Foundation

enum TimeHelper {
    static func minutesSinceMidnight(_ date: Date = .now) -> Int {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
    }

    /// 1 = Sunday ... 7 = Saturday
    static func weekday(_ date: Date = .now) -> Int {
        Calendar.current.component(.weekday, from: date)
    }

    /// 570 becomes "9:30 AM"
    static func format(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        let hour12 = (h % 12 == 0) ? 12 : h % 12
        return String(format: "%d:%02d %@", hour12, m, h >= 12 ? "PM" : "AM")
    }
}
