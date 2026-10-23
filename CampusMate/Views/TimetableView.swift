import SwiftUI
import SwiftData

struct TimetableView: View {
    @Query(sort: \ClassSlot.startMinutes) private var slots: [ClassSlot]
    @State private var selectedDay = max(2, TimeHelper.weekday()) // Sunday shows Monday

    private let days: [(number: Int, name: String)] = [
        (2, "Mon"), (3, "Tue"), (4, "Wed"), (5, "Thu"), (6, "Fri"), (7, "Sat")
    ]

    private var todaysSlots: [ClassSlot] {
        slots.filter { $0.weekday == selectedDay }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Day", selection: $selectedDay) {
                    ForEach(days, id: \.number) { day in
                        Text(day.name).tag(day.number)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List(todaysSlots) { slot in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(slot.subjectName).font(.headline)
                        Text("\(TimeHelper.format(slot.startMinutes)) - \(TimeHelper.format(slot.endMinutes))")
                            .font(.subheadline)
                        Label("\(slot.room), \(slot.buildingName)", systemImage: "mappin.and.ellipse")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
                .overlay {
                    if todaysSlots.isEmpty {
                        ContentUnavailableView("No classes", systemImage: "calendar")
                    }
                }
            }
            .navigationTitle("Timetable")
        }
    }
}
