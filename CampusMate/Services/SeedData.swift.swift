//
//  SeedData.swift.swift
//  CampusMate
//
//  Created by KIET43 on 23/10/26.
//

import Foundation
import SwiftData

enum SeedData {
    static func seedIfNeeded(context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<Building>())) ?? 0
        guard count == 0 else { return }

        // Buildings: replace names and coordinates with real ones
        context.insert(Building(name: "Block A", latitude: 28.7500, longitude: 77.4990))
        context.insert(Building(name: "Block B", latitude: 28.7508, longitude: 77.4998))
        context.insert(Building(name: "Block C", latitude: 28.7515, longitude: 77.4985))
        context.insert(Building(name: "Library", latitude: 28.7505, longitude: 77.5005))

        // Subjects with starting attendance
        context.insert(Subject(name: "Mathematics", code: "MA101", attended: 18, total: 22))
        context.insert(Subject(name: "Physics", code: "PH101", attended: 15, total: 22))
        context.insert(Subject(name: "Programming", code: "CS101", attended: 20, total: 24))

        // Timetable: Monday (2) to Friday (6)
        for day in 2...6 {
            context.insert(ClassSlot(subjectName: "Mathematics", weekday: day, startMinutes: 9 * 60, endMinutes: 10 * 60, room: "A-101", buildingName: "Block A"))
            context.insert(ClassSlot(subjectName: "Physics", weekday: day, startMinutes: 10 * 60, endMinutes: 11 * 60, room: "B-204", buildingName: "Block B"))
            context.insert(ClassSlot(subjectName: "Programming", weekday: day, startMinutes: 11 * 60 + 30, endMinutes: 13 * 60, room: "C-Lab1", buildingName: "Block C"))
            context.insert(ClassSlot(subjectName: "Mathematics", weekday: day, startMinutes: 14 * 60, endMinutes: 15 * 60, room: "A-102", buildingName: "Block A"))
            context.insert(ClassSlot(subjectName: "Physics", weekday: day, startMinutes: 15 * 60, endMinutes: 16 * 60, room: "B-205", buildingName: "Block B"))
        }

        try? context.save()
    }
}
