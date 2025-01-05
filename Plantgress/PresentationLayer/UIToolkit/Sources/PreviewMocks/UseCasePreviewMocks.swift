//
//  UseCaseMocks.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Foundation
import SharedDomain
import SwiftUI

class LogInUserUseCaseMock: LogInUserUseCase {
    func execute(credentials: LoginCredentials) {}
}

class RegisterUserUseCaseMock: RegisterUserUseCase {
    func execute(credentials: RegistrationCredentials) {}
}

class IsUserLoggedInUseCaseMock: IsUserLoggedInUseCase {
    func execute() -> Bool { return false }
}

class IsEmailVerifiedUseCaseMock: IsEmailVerifiedUseCase {
    func execute() -> Bool { return true }
}

class SendEmailVerificationUseCaseMock: SendEmailVerificationUseCase {
    func execute() {}
}

class ValidateEmailUseCaseMock: ValidateEmailUseCase {
    func execute(email: String) throws {}
}

class ValidatePasswordUseCaseMock: ValidatePasswordUseCase {
    func execute(password: String) throws {}
}

class GetCurrentUsersEmailUseCaseMock: GetCurrentUsersEmailUseCase {
    func execute() -> String? { return nil }
}

class GetCurrentUserRemotelyUseCaseMock: GetCurrentUserRemotelyUseCase {
    func execute() -> User { return .mock }
}

class GetCurrentUserLocallyUseCaseMock: GetCurrentUserLocallyUseCase {
    func execute() -> User { return .mock }
}

class SendPasswordResetUseCaseMock: SendPasswordResetUseCase {
    func execute(email: String) {}
}

class LogOutUserUseCaseMock: LogOutUserUseCase {
    func execute() throws {}
}

class DeleteUserUseCaseMock: DeleteUserUseCase {
    func execute(userId: String) async throws {}
}

class SaveCurrentUserEmailUseCaseMock: SaveCurrentUserEmailUseCase {
    func execute(email: String) {}
}

class DeleteCurrentUserEmailUseCaseMock: DeleteCurrentUserEmailUseCase {
    func execute() {}
}

class UploadImageUseCaseMock: UploadImageUseCase {
    func execute(userId: String, imageId: String, imageData: Data) async throws -> URL {
        guard let url = URL(string: "") else {
            throw ImagesError.invalidUrl
        }
        
        return url
    }
}

class DeleteImageUseCaseMock: DeleteImageUseCase {
    func execute(userId: String, imageId: UUID) async throws {}
}

class DownloadImageUseCaseMock: DownloadImageUseCase {
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

class HasPhotoLibraryAccessUseCaseMock: HasPhotoLibraryAccessUseCase {
    func execute() {}
}

class HasCameraAccessUseCaseMock: HasCameraAccessUseCase {
    func execute() {}
}

class CreatePlantUseCaseMock: CreatePlantUseCase {
    func execute(plant: Plant) async throws {}
}

class UpdatePlantUseCaseMock: UpdatePlantUseCase {
    func execute(plant: Plant) async throws {}
}

class GetPlantUseCaseMock: GetPlantUseCase {
    func execute(id: UUID) async throws -> Plant {
        .mock(id: id)
    }
}

class DeletePlantUseCaseMock: DeletePlantUseCase {
    func execute(id: UUID) async throws {}
}

class GetAllPlantsUseCaseMock: GetAllPlantsUseCase {
    func execute() async throws -> [Plant] {
        return .mock
    }
}

class UpdatePlantImagesUseCaseMock: UpdatePlantImagesUseCase {
    func execute(plantId: UUID, newImages: [ImageData]) async throws {}
}

class PrepareImagesForSharingUseCaseMock: PrepareImagesForSharingUseCase {
    func execute(images: [SharedDomain.ImageData]) async throws -> [UIImage] {
        []
    }
}

class CreateRoomUseCaseMock: CreateRoomUseCase {
    func execute(room: Room, plants: [Plant]) async throws {}
}

class AddPlantsToRoomUseCaseMock: AddPlantsToRoomUseCase {
    func execute(roomId: UUID, plantIds: [UUID]) async throws {}
}

class GetRoomUseCaseMock: GetRoomUseCase {
    func execute(roomId: UUID) async throws -> Room {
        return .mock(id: roomId)
    }
}

class UpdateRoomUseCaseMock: UpdateRoomUseCase {
    func execute(room: Room, plants: [Plant]) async throws {}
}

class DeleteRoomUseCaseMock: DeleteRoomUseCase {
    func execute(roomId: UUID, plants: [Plant]) async throws {}
}

class GetPlantsForRoomUseCaseMock: GetPlantsForRoomUseCase {
    func execute(roomId: UUID) async throws -> [Plant] {
        return .mock
    }
}

class GetAllRoomsUseCaseMock: GetAllRoomsUseCase {
    func execute() async throws -> [Room] {
        return .mock
    }
}

class RemovePlantFromRoomUseCaseMock: RemovePlantFromRoomUseCase {
    func execute(plantId: UUID, roomId: UUID) async throws {}
}

class MovePlantToRoomUseCaseMock: MovePlantToRoomUseCase {
    func execute(plantId: UUID, fromRoomId: UUID, toRoomId: UUID) async throws {}
}

class SynchronizeNotificationsForAllPlantsUseCaseMock: SynchronizeNotificationsForAllPlantsUseCase {
    func execute() async throws {}
}

class CompleteTaskUseCaseMock: CompleteTaskUseCase {
    func execute(for plant: Plant, taskType: TaskType, completionDate: Date) async throws {}
}

class GetUpcomingTasksForAllPlantsUseCaseMock: GetUpcomingTasksForAllPlantsUseCase {
    func execute(for plants: [Plant], days: Int) -> [PlantTask] {
        return []
    }
}

class GetUpcomingTasksForPlantUseCaseMock: GetUpcomingTasksForPlantUseCase {
    func execute(for plant: Plant, days: Int) -> [PlantTask] {
        return []
    }
}

class GetCompletedTasksForAllPlantsUseCaseMock: GetCompletedTasksForAllPlantsUseCase {
    func execute(for plantIds: [UUID]) async throws -> [PlantTask] {
        []
    }
}

class GetCompletedTasksForPlantUseCaseMock: GetCompletedTasksForPlantUseCase {
    func execute(for plantId: UUID) async throws -> [PlantTask] {
        .mock
    }
}

class HasNotificationAccessUseCaseMock: HasNotificationAccessUseCase {
    func execute() async throws {}
}

class DeleteTaskUseCaseMock: DeleteTaskUseCase {
    func execute(task: PlantTask) async throws {}
}

class DeleteTaskForRoomUseCaseMock: DeleteTaskForRoomUseCase {
    func execute(roomId: UUID, taskType: TaskType) async throws {}
}

class DeleteTaskForPlantUseCaseMock: DeleteTaskForPlantUseCase {
    func execute(plant: Plant, taskType: TaskType) async throws {}
}

class CompleteTaskForRoomUseCaseMock: CompleteTaskForRoomUseCase {
    func execute(roomId: UUID, taskType: TaskType, completionDate: Date) async throws {}
}

class ScheduleNextNotificationUseCaseMock: ScheduleNextNotificationUseCase {
    func execute(plantId: UUID, taskType: TaskType, dueDate: Date) async throws {}
}
