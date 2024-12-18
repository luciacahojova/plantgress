//
//  RoomRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 18.12.2024.
//

import Foundation

public protocol RoomRepository {
    func createRoom(_ room: Room) async throws
    func updateRoom(_ plant: Plant) async throws
}
