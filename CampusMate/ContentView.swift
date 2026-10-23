import SwiftUI
import MapKit

// MARK: - Models

struct DeadlineItem: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool = false
}

struct CampusBuilding: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Main Tab View

struct ContentView: View {
    var body: some View {
        TabView {
            TimetableTabView()
                .tabItem {
                    Label("Timetable", systemImage: "calendar")
                }

            DeadlinesTabView()
                .tabItem {
                    Label("Deadlines", systemImage: "checklist")
                }

            CampusMapTabView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
    }
}

// MARK: - Tab 1: Timetable View

struct TimetableTabView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Upcoming Classes")) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mathematics").font(.headline)
                        Text("9:00 AM - 10:00 AM • A-101, Block A").font(.subheadline).foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Physics").font(.headline)
                        Text("10:00 AM - 11:00 AM • B-204, Block B").font(.subheadline).foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Programming").font(.headline)
                        Text("11:30 AM - 1:00 PM • C-Lab1, Block C").font(.subheadline).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Timetable")
        }
    }
}

// MARK: - Tab 2: Deadlines View

struct DeadlinesTabView: View {
    @State private var deadlines: [DeadlineItem] = []
    @State private var showingAddSheet = false
    @State private var newTitle = ""
    @State private var newDueDate = Date()

    var body: some View {
        NavigationStack {
            List {
                ForEach($deadlines) { $deadline in
                    HStack {
                        Button {
                            deadline.isCompleted.toggle()
                        } label: {
                            Image(systemName: deadline.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(deadline.isCompleted ? .green : .gray)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(deadline.title)
                                .strikethrough(deadline.isCompleted, color: .primary)
                                .foregroundColor(deadline.isCompleted ? .secondary : .primary)
                            Text(deadline.dueDate.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    deadlines.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Deadlines")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    Form {
                        TextField("Title (e.g. Math Assignment)", text: $newTitle)
                        DatePicker("Due Date", selection: $newDueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                    .navigationTitle("New Deadline")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddSheet = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if !newTitle.isEmpty {
                                    deadlines.append(DeadlineItem(title: newTitle, dueDate: newDueDate))
                                    newTitle = ""
                                    newDueDate = Date()
                                }
                                showingAddSheet = false
                            }
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - Tab 3: Campus Map View

struct CampusMapTabView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 28.7533, longitude: 77.4975),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )

    let buildings: [CampusBuilding] = [
        CampusBuilding(name: "Block A", coordinate: CLLocationCoordinate2D(latitude: 28.7535, longitude: 77.4970)),
        CampusBuilding(name: "Block B", coordinate: CLLocationCoordinate2D(latitude: 28.7530, longitude: 77.4980)),
        CampusBuilding(name: "Block C", coordinate: CLLocationCoordinate2D(latitude: 28.7525, longitude: 77.4972)),
        CampusBuilding(name: "Library", coordinate: CLLocationCoordinate2D(latitude: 28.7540, longitude: 77.4982))
    ]

    @State private var selectedBuilding: CampusBuilding?

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                ForEach(buildings) { building in
                    Annotation(building.name, coordinate: building.coordinate) {
                        Button {
                            selectedBuilding = building
                        } label: {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Campus Map")
            .sheet(item: $selectedBuilding) { building in
                VStack(spacing: 16) {
                    Text(building.name)
                        .font(.title2)
                        .bold()

                    Text("Latitude: \(building.coordinate.latitude, specifier: "%.4f")\nLongitude: \(building.coordinate.longitude, specifier: "%.4f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Open in Apple Maps") {
                        let placemark = MKPlacemark(coordinate: building.coordinate)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = building.name
                        mapItem.openInMaps()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Close") {
                        selectedBuilding = nil
                    }
                    .buttonStyle(.borderless)
                }
                .padding()
                .presentationDetents([.fraction(0.35)])
            }
        }
    }
}
