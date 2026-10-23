//
//  DeadlinesVeiw.swift
//  CampusMate
//
//  Created by KIET43 on 23/10/26.
//

import Foundation
import SwiftUI
import SwiftData

struct DeadlinesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Assignment.dueDate) private var items: [Assignment]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack(spacing: 12) {
                        Button {
                            item.isDone.toggle()
                        } label: {
                            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        }
                        .font(.title2)
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title).strikethrough(item.isDone)
                            Text(item.dueDate, format: .dateTime.day().month().hour().minute())
                                .font(.caption)
                                .foregroundStyle(item.dueDate < .now && !item.isDone ? Color.red : Color.secondary)
                        }
                    }
                }
                .onDelete { offsets in
                    for index in offsets { context.delete(items[index]) }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("No deadlines yet", systemImage: "checklist", description: Text("Tap + to add one."))
                }
            }
            .navigationTitle("Deadlines")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showingAdd) { AddAssignmentView() }
        }
    }
}

struct AddAssignmentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var subject = ""
    @State private var due = Date.now.addingTimeInterval(86_400)
    @State private var priority = 1

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Subject", text: $subject)
                DatePicker("Due", selection: $due)
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }
            }
            .navigationTitle("New Deadline")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        context.insert(Assignment(title: title, subjectName: subject, dueDate: due, priority: priority))
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
