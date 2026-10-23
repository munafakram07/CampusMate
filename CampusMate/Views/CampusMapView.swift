//
//  CampusMapView.swift
//  CampusMate
//
//  Created by KIET43 on 23/10/26.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

struct CampusMapView: View {
    @Query(sort: \Building.name) private var buildings: [Building]
    @Query private var slots: [ClassSlot]
    @State private var search = ""
    @State private var position: MapCameraPosition = .automatic

    private var visibleBuildings: [Building] {
        guard !search.isEmpty else { return buildings }
        let buildingsWithMatchingRoom = Set(
            slots.filter { $0.room.localizedCaseInsensitiveContains(search) }
                .map(\.buildingName)
        )
        return buildings.filter {
            buildingsWithMatchingRoom.contains($0.name) ||
            $0.name.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                ForEach(visibleBuildings) { building in
                    Marker(
                        building.name,
                        systemImage: "building.2",
                        coordinate: CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)
                    )
                }
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            .searchable(text: $search, prompt: "Search a building or room")
            .navigationTitle("Campus Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
