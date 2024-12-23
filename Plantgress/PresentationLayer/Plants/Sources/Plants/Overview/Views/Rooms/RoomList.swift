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
    private let completeTaskAction: (UUID, TaskType) -> Void
    
    private let isLoading: Bool
    
    init(
        rooms: [Room],
        completeTaskAction: @escaping (UUID, TaskType) -> Void
    ) {
        self.rooms = rooms
        self.completeTaskAction = completeTaskAction
        self.isLoading = false
    }
    
    private init() {
        self.rooms = .mock
        self.completeTaskAction = { _, _ in}
        self.isLoading = true
    }
    
    static var skeleton: RoomList {
        self.init()
    }
    
    var body: some View {
        LazyVStack(spacing: Constants.Spacing.large) {
            if rooms.isEmpty {
                BaseEmptyContentView(
                    message: Strings.noRoomsMessage,
                    fixedTopPadding: 100
                )
            } else {
                ForEach(rooms, id: \.id) { room in
                    RoomRow(
                        room: room,
                        completeTaskAction: completeTaskAction
                    )
                }
            }
        }
        .skeleton(isLoading)
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        RoomList(
            rooms: .mock,
            completeTaskAction: { _, _ in }
        )
    }
}
