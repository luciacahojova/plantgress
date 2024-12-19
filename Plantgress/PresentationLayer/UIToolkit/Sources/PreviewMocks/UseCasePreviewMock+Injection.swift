//
//  UseCasePreviewMock+Injection.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Resolver
import SharedDomain

public extension Resolver {
    static func registerUseCasesForPreviews() {
        // Authentication
        register { LogInUserUseCasePreviewMock() as LogInUserUseCase }
        register { RegisterUserUseCasePreviewMock() as RegisterUserUseCase }
        register { IsUserLoggedInUseCasePreviewMock() as IsUserLoggedInUseCase }
        register { IsEmailVerifiedUseCasePreviewMock() as IsEmailVerifiedUseCase }
        register { SendEmailVerificationUseCasePreviewMock() as SendEmailVerificationUseCase }
        register { ValidateEmailUseCasePreviewMock() as ValidateEmailUseCase }
        register { ValidatePasswordUseCasePreviewMock() as ValidatePasswordUseCase }
        register { GetCurrentUsersEmailUseCasePreviewMock() as GetCurrentUsersEmailUseCase }
        register { GetCurrentUserRemotelyUseCasePreviewMock() as GetCurrentUserRemotelyUseCase }
        register { GetCurrentUserLocallyUseCasePreviewMock() as GetCurrentUserLocallyUseCase }
        register { SendPasswordResetUseCasePreviewMock() as SendPasswordResetUseCase }
        register { LogOutUserUseCasePreviewMock() as LogOutUserUseCase }
        register { DeleteUserUseCasePreviewMock() as DeleteUserUseCase }
        register { SaveCurrentUserEmailUseCasePreviewMock() as SaveCurrentUserEmailUseCase }
        register { DeleteCurrentUserEmailUseCasePreviewMock() as DeleteCurrentUserEmailUseCase }
        
        // Images
        register { UploadImageUseCasePreviewMock() as UploadImageUseCase }
        register { DownloadImageUseCasePreviewMock() as DownloadImageUseCase }
        register { HasCameraAccessUseCasePreviewMock() as HasCameraAccessUseCase }
        register { HasPhotoLibraryAccessUseCasePreviewMock() as HasPhotoLibraryAccessUseCase }
        
        // Plants
        register { CreatePlantUseCasePreviewMock() as CreatePlantUseCase }
        register { UpdatePlantUseCasePreviewMock() as UpdatePlantUseCase }
        register { GetPlantUseCasePreviewMock() as GetPlantUseCase }
        register { DeletePlantUseCasePreviewMock() as DeletePlantUseCase }
        register { GetAllPlantsUseCasePreviewMock() as GetAllPlantsUseCase }

        // Rooms
        register { CreateRoomUseCasePreviewMock() as CreateRoomUseCase }
        register { AddPlantsToRoomUseCasePreviewMock() as AddPlantsToRoomUseCase }
        register { GetRoomUseCasePreviewMock() as GetRoomUseCase }
        register { GetPlantsForRoomUseCasePreviewMock() as GetPlantsForRoomUseCase }
        register { GetAllRoomsUseCasePreviewMock() as GetAllRoomsUseCase }
        register { RemovePlantFromRoomUseCasePreviewMock() as RemovePlantFromRoomUseCase }
        register { MovePlantToRoomUseCasePreviewMock() as MovePlantToRoomUseCase }

        // Tasks
        register { SynchronizeNotificationsForAllPlantsUseCasePreviewMock() as SynchronizeNotificationsForAllPlantsUseCase }
        register { CompleteTaskUseCasePreviewMock() as CompleteTaskUseCase }
        register { CompleteTaskForRoomUseCasePreviewMock() as CompleteTaskForRoomUseCase }
        register { DeleteTaskUseCasePreviewMock() as DeleteTaskUseCase }
        register { GetUpcomingTasksForAllPlantsUseCasePreviewMock() as GetUpcomingTasksForAllPlantsUseCase }
        register { GetUpcomingTasksForPlantUseCasePreviewMock() as GetUpcomingTasksForPlantUseCase }
        register { GetCompletedTasksForPlantUseCasePreviewMock() as GetCompletedTasksForPlantUseCase }
        register { GetCompletedTasksForAllPlantsUseCasePreviewMock() as GetCompletedTasksForAllPlantsUseCase }
        
        // Notifications
        register { HasNotificationAccessUseCasePreviewMock() as HasNotificationAccessUseCase }
        
    }
}
