//
//  RoomList.swift
//  Plants
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct RoomList: View {
    
    private let rooms: [Room]
    private let trackTaskAction: (UUID, TaskType) -> Void
    
    init(
        rooms: [Room],
        trackTaskAction: @escaping (UUID, TaskType) -> Void
    ) {
        self.rooms = rooms
        self.trackTaskAction = trackTaskAction
    }
    
    var body: some View {
        VStack(spacing: Constants.Spacing.large) {
            ForEach(rooms, id: \.id) { room in
                RoomRow(
                    room: room,
                    trackTaskAction: trackTaskAction
                )
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        RoomList(
            rooms: .mock,
            trackTaskAction: { _, _ in }
        )
    }
}
