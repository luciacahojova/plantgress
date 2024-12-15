//
//  ImagesRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation
import SwiftUI

public protocol ImagesRepository {
    func uploadImage(userId: String, imageId: String, imageData: Data) async throws -> URL
    func downloadImage(urlString: String) async -> Image?
    func delete(userId: String, imageId: String) async throws
}
