//
//  ScheduleHelper.swift
//  CampusMate
//
//  Created by KIET43 on 23/10/26.
//

import Foundation


struct NextClassInfo {
    let slot: ClassSlot
    let start: Date
}

enum ScheduleHelper {
    /// Finds the next class that starts after 'now', looking up to a week ahead.
    static func nextClass(in slots: [ClassSlot], after now: Date = .now) -> NextClassInfo? {
        let calendar = Calendar.current
        for offset in 0..<8 {
            guard let day = calendar.date(byAdding: .day, value: offset, to: now) else { continue }
            let weekday = calendar.component(.weekday, from: day)
            let todays = slots.filter { $0.weekday == weekday }.sorted { $0.startMinutes < $1.startMinutes }
            for slot in todays {
                guard let start = calendar.date(bySettingHour: slot.startMinutes / 60,
                                               minute: slot.startMinutes % 60,
                                               second: 0, of: day) else { continue }
                if start > now {
                    return NextClassInfo(slot: slot, start: start)
                }
            }
        }
        return nil
    }
}
