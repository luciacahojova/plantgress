//
//  ImagesRepositoryTests.swift
//  ImagesToolkit
//
//  Created by Lucia Cahojova on 05.01.2025.
//

@testable import ImagesToolkit
import FirebaseStorageProviderMocks
import SharedDomain
import SwiftUI
import Utilities
import XCTest

final class ImagesRepositoryTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let firebaseStorageProvider = FirebaseStorageProviderMock()
    
    private func createRepository() -> ImagesRepository {
        ImagesRepositoryImpl(firebaseStorageProvider: firebaseStorageProvider)
    }
    
    // MARK: - Tests

    func testUploadImage() async throws {
        // given
        let repository = createRepository()
        let userId = "test_user"
        let imageId = UUID().uuidString
        let imageData = Data()
        let expectedURL = URL(string: "https://example.com/image.png")!
        firebaseStorageProvider.uploadReturnValue = expectedURL

        // when
        let uploadedURL = try await repository.uploadImage(userId: userId, imageId: imageId, imageData: imageData)

        // then
        XCTAssertEqual(uploadedURL, expectedURL)
        XCTAssertEqual(firebaseStorageProvider.uploadCallsCount, 1)
        XCTAssertEqual(firebaseStorageProvider.uploadPathReceived, DatabaseConstants.imagePath(userId: userId, imageId: imageId))
    }
    
    func testPrepareImagesForSharing() async throws {
        // given
        let repository = createRepository()
        let imageData = ImageData.mock(id: UUID())
        let uiImage = UIImage(systemName: "circle")!
        let imageDataAsPng = uiImage.pngData()!
        firebaseStorageProvider.downloadUrlReturnValue = imageDataAsPng

        // when
        let preparedImages = try await repository.prepareImagesForSharing(images: [imageData])

        // then
        XCTAssertEqual(preparedImages.count, 1)
        XCTAssertNotNil(preparedImages.first)
    }
    
    func testDeleteImage() async throws {
        // given
        let repository = createRepository()
        let userId = "test_user"
        let imageId = UUID().uuidString

        // when
        try await repository.delete(userId: userId, imageId: imageId)

        // then
        XCTAssertEqual(firebaseStorageProvider.deleteCallsCount, 1)
    }
}
