//
//  UseCasePreviewMocks.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation
import SharedDomain
import SwiftUI

class LogInUserUseCasePreviewMock: LogInUserUseCase {
    func execute(credentials: LoginCredentials) {}
}

class RegisterUserUseCasePreviewMock: RegisterUserUseCase {
    func execute(credentials: RegistrationCredentials) {}
}

class IsUserLoggedInUseCasePreviewMock: IsUserLoggedInUseCase {
    func execute() -> Bool { return false }
}

class IsEmailVerifiedUseCasePreviewMock: IsEmailVerifiedUseCase {
    func execute() -> Bool { return false }
}

class SendEmailVerificationUseCasePreviewMock: SendEmailVerificationUseCase {
    func execute() {}
}

class ValidateEmailUseCasePreviewMock: ValidateEmailUseCase {
    func execute(email: String) throws {}
}

class ValidatePasswordUseCasePreviewMock: ValidatePasswordUseCase {
    func execute(password: String) throws {}
}

class GetCurrentUsersEmailUseCasePreviewMock: GetCurrentUsersEmailUseCase {
    func execute() -> String? { return nil }
}

class GetCurrentUserRemotelyUseCasePreviewMock: GetCurrentUserRemotelyUseCase {
    func execute() -> User { return .mock }
}

class GetCurrentUserLocallyUseCasePreviewMock: GetCurrentUserLocallyUseCase {
    func execute() -> User { return .mock }
}

class SendPasswordResetUseCasePreviewMock: SendPasswordResetUseCase {
    func execute(email: String) {}
}

class LogOutUserUseCasePreviewMock: LogOutUserUseCase {
    func execute() throws {}
}

class DeleteUserUseCasePreviewMock: DeleteUserUseCase {
    func execute(userId: String) async throws {}
}

class SaveCurrentUserEmailUseCasePreviewMock: SaveCurrentUserEmailUseCase {
    func execute(email: String) {}
}

class DeleteCurrentUserEmailUseCasePreviewMock: DeleteCurrentUserEmailUseCase {
    func execute() {}
}

class UploadImageUseCasePreviewMock: UploadImageUseCase {
    func execute(userId: String, imageId: String, imageData: Data) async throws -> URL {
        guard let url = URL(string: "") else {
            throw ImagesError.invalidUrl
        }
        
        return url
    }
}

class DownloadImageUseCasePreviewMock: DownloadImageUseCase {
    func execute(urlString: String) async -> Image? {
        do {
            guard let url = URL(string: urlString) else { return nil }
            let cache = URLCache.shared
            let urlRequest = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if cache.cachedResponse(for: urlRequest) == nil {
                cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: urlRequest)
            }
            
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        } catch {
            return nil
        }
    }
}

class HasPhotoLibraryAccessUseCasePreviewMock: HasPhotoLibraryAccessUseCase {
    func execute() {}
}

class HasCameraAccessUseCasePreviewMock: HasCameraAccessUseCase {
    func execute() {}
}

class CreatePlantUseCasePreviewMock: CreatePlantUseCase {
    func execute(plant: Plant) async throws {}
}

class UpdatePlantUseCasePreviewMock: UpdatePlantUseCase {
    func execute(plant: Plant) async throws {}
}

class GetPlantUseCasePreviewMock: GetPlantUseCase {
    func execute(id: UUID) async throws -> Plant {
        .mock(id: id)
    }
}

class DeletePlantUseCasePreviewMock: DeletePlantUseCase {
    func execute(id: UUID) async throws {}
}

class GetAllPlantsUseCasePreviewMock: GetAllPlantsUseCase {
    func execute() async throws -> [Plant] {
        return .mock
    }
}

class UpdatePlantImagesUseCasePreviewMock: UpdatePlantImagesUseCase {
    func execute(plantId: UUID, newImages: [ImageData]) async throws {}
}

class CreateRoomUseCasePreviewMock: CreateRoomUseCase {
    func execute(room: Room, plants: [Plant]) async throws {}
}

class AddPlantsToRoomUseCasePreviewMock: AddPlantsToRoomUseCase {
    func execute(roomId: UUID, plantIds: [UUID]) async throws {}
}

class GetRoomUseCasePreviewMock: GetRoomUseCase {
    func execute(roomId: UUID) async throws -> Room {
        return .mock(id: roomId)
    }
}

class GetPlantsForRoomUseCasePreviewMock: GetPlantsForRoomUseCase {
    func execute(roomId: UUID) async throws -> [Plant] {
        return .mock
    }
}

class GetAllRoomsUseCasePreviewMock: GetAllRoomsUseCase {
    func execute() async throws -> [Room] {
        return .mock
    }
}

class RemovePlantFromRoomUseCasePreviewMock: RemovePlantFromRoomUseCase {
    func execute(plantId: UUID, roomId: UUID) async throws {}
}

class MovePlantToRoomUseCasePreviewMock: MovePlantToRoomUseCase {
    func execute(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws {}
}

class SynchronizeNotificationsForAllPlantsUseCasePreviewMock: SynchronizeNotificationsForAllPlantsUseCase {
    func execute(for plants: [Plant]) async throws {}
}

class CompleteTaskUseCasePreviewMock: CompleteTaskUseCase {
    func execute(for plant: Plant, taskType: TaskType, completionDate: Date) async throws {}
}

class GetUpcomingTasksForAllPlantsUseCasePreviewMock: GetUpcomingTasksForAllPlantsUseCase {
    func execute(for plants: [Plant], days: Int) -> [PlantTask] {
        return []
    }
}

class GetUpcomingTasksForPlantUseCasePreviewMock: GetUpcomingTasksForPlantUseCase {
    func execute(for plant: Plant, days: Int) -> [PlantTask] {
        return []
    }
}

class GetCompletedTasksForAllPlantsUseCasePreviewMock: GetCompletedTasksForAllPlantsUseCase {
    func execute(for plantIds: [UUID]) async throws -> [PlantTask] {
        []
    }
}

class GetCompletedTasksForPlantUseCasePreviewMock: GetCompletedTasksForPlantUseCase {
    func execute(for plantId: UUID) async throws -> [PlantTask] {
        .mock
    }
}

class HasNotificationAccessUseCasePreviewMock: HasNotificationAccessUseCase {
    func execute() async throws {}
}

class DeleteTaskUseCasePreviewMock: DeleteTaskUseCase {
    func execute(task: PlantTask) async throws {}
}

class CompleteTaskForRoomUseCasePreviewMock: CompleteTaskForRoomUseCase {
    func execute(roomId: UUID, taskType: SharedDomain.TaskType, completionDate: Date) async throws {}
}
