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

    private var nextUp: NextClassInfo? {
        ScheduleHelper.nextClass(in: slots)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // MARK: - Up Next Banner
                if let upNext = nextUp {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label("UP NEXT", systemImage: "clock.badge.checkmark")
                                .font(.caption.bold())
                                .foregroundStyle(.blue)
                            Spacer()
                            Text(upNext.start, style: .relative)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(upNext.slot.subjectName)
                            .font(.headline)
                        HStack {
                            Label("\(upNext.slot.room), \(upNext.slot.buildingName)", systemImage: "mappin.and.ellipse")
                            Spacer()
                            Text("\(TimeHelper.format(upNext.slot.startMinutes)) - \(TimeHelper.format(upNext.slot.endMinutes))")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    .padding(.horizontal)
                }

                // MARK: - Day Selector
                Picker("Day", selection: $selectedDay) {
                    ForEach(days, id: \.number) { day in
                        Text(day.name).tag(day.number)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // MARK: - Class List
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
                        ContentUnavailableView("No classes scheduled", systemImage: "calendar")
                    }
                }
            }
            .navigationTitle("Timetable")
        }
    }
}
