//
//  ImagesRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation
import SwiftUI

public protocol ImagesRepository {
    func uploadImage(userId: UUID, imageName: String, imageData: Data) async throws -> URL
    func downloadImage(urlString: String) async throws -> Image
    func delete(userId: UUID, imageName: String) async throws
}
