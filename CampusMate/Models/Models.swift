//
//  Models.swift.swift
//  CampusMate
//
//  Created by KIET43 on 23/10/26.
//

import Foundation
import SwiftData

@Model
final class Subject {
    var name: String
    var code: String
    var attended: Int
    var total: Int
    var requiredPercent: Double // for example 75

    init(name: String, code: String, attended: Int = 0, total: Int = 0, requiredPercent: Double = 75) {
        self.name = name
        self.code = code
        self.attended = attended
        self.total = total
        self.requiredPercent = requiredPercent
    }
}

@Model
final class ClassSlot {
    var subjectName: String
    var weekday: Int // 1 = Sunday ... 7 = Saturday
    var startMinutes: Int // minutes since midnight, 9:30 AM = 570
    var endMinutes: Int
    var room: String
    var buildingName: String

    init(subjectName: String, weekday: Int, startMinutes: Int, endMinutes: Int, room: String, buildingName: String) {
        self.subjectName = subjectName
        self.weekday = weekday
        self.startMinutes = startMinutes
        self.endMinutes = endMinutes
        self.room = room
        self.buildingName = buildingName
    }
}

@Model
final class Building {
    var name: String
    var latitude: Double
    var longitude: Double

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

@Model
final class Assignment {
    var title: String
    var subjectName: String
    var dueDate: Date
    var priority: Int // 0 = low, 1 = medium, 2 = high
    var isDone: Bool

    init(title: String, subjectName: String, dueDate: Date, priority: Int = 1, isDone: Bool = false) {
        self.title = title
        self.subjectName = subjectName
        self.dueDate = dueDate
        self.priority = priority
        self.isDone = isDone
    }
}
