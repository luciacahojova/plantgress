//
//  UseCaseMock+Injection.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 09.12.2024.
//

import Resolver
import SharedDomain

public extension Resolver {
    static func registerUseCaseMocks() {
        // Authentication
        register { LogInUserUseCaseMock() as LogInUserUseCase }
        register { RegisterUserUseCaseMock() as RegisterUserUseCase }
        register { IsUserLoggedInUseCaseMock() as IsUserLoggedInUseCase }
        register { IsEmailVerifiedUseCaseMock() as IsEmailVerifiedUseCase }
        register { SendEmailVerificationUseCaseMock() as SendEmailVerificationUseCase }
        register { ValidateEmailUseCaseMock() as ValidateEmailUseCase }
        register { ValidatePasswordUseCaseMock() as ValidatePasswordUseCase }
        register { GetCurrentUsersEmailUseCaseMock() as GetCurrentUsersEmailUseCase }
        register { GetCurrentUserRemotelyUseCaseMock() as GetCurrentUserRemotelyUseCase }
        register { GetCurrentUserLocallyUseCaseMock() as GetCurrentUserLocallyUseCase }
        register { SendPasswordResetUseCaseMock() as SendPasswordResetUseCase }
        register { LogOutUserUseCaseMock() as LogOutUserUseCase }
        register { DeleteUserUseCaseMock() as DeleteUserUseCase }
        register { SaveCurrentUserEmailUseCaseMock() as SaveCurrentUserEmailUseCase }
        register { DeleteCurrentUserEmailUseCaseMock() as DeleteCurrentUserEmailUseCase }
        
        // Images
        register { UploadImageUseCaseMock() as UploadImageUseCase }
        register { DownloadImageUseCaseMock() as DownloadImageUseCase }
        register { HasCameraAccessUseCaseMock() as HasCameraAccessUseCase }
        register { HasPhotoLibraryAccessUseCaseMock() as HasPhotoLibraryAccessUseCase }
        register { DeleteImageUseCaseMock() as DeleteImageUseCase }
        register { UpdatePlantImagesUseCaseMock() as UpdatePlantImagesUseCase }
        register { PrepareImagesForSharingUseCaseMock() as PrepareImagesForSharingUseCase }
        
        // Plants
        register { CreatePlantUseCaseMock() as CreatePlantUseCase }
        register { UpdatePlantUseCaseMock() as UpdatePlantUseCase }
        register { GetPlantUseCaseMock() as GetPlantUseCase }
        register { DeletePlantUseCaseMock() as DeletePlantUseCase }
        register { GetAllPlantsUseCaseMock() as GetAllPlantsUseCase }

        // Rooms
        register { CreateRoomUseCaseMock() as CreateRoomUseCase }
        register { AddPlantsToRoomUseCaseMock() as AddPlantsToRoomUseCase }
        register { GetRoomUseCaseMock() as GetRoomUseCase }
        register { DeleteRoomUseCaseMock() as DeleteRoomUseCase }
        register { UpdateRoomUseCaseMock() as UpdateRoomUseCase }
        register { GetPlantsForRoomUseCaseMock() as GetPlantsForRoomUseCase }
        register { GetAllRoomsUseCaseMock() as GetAllRoomsUseCase }
        register { RemovePlantFromRoomUseCaseMock() as RemovePlantFromRoomUseCase }
        register { MovePlantToRoomUseCaseMock() as MovePlantToRoomUseCase }

        // Tasks
        register { SynchronizeNotificationsForAllPlantsUseCaseMock() as SynchronizeNotificationsForAllPlantsUseCase }
        register { CompleteTaskUseCaseMock() as CompleteTaskUseCase }
        register { CompleteTaskForRoomUseCaseMock() as CompleteTaskForRoomUseCase }
        register { DeleteTaskUseCaseMock() as DeleteTaskUseCase }
        register { DeleteTaskForRoomUseCaseMock() as DeleteTaskForRoomUseCase }
        register { DeleteTaskForPlantUseCaseMock() as DeleteTaskForPlantUseCase }
        register { GetUpcomingTasksForAllPlantsUseCaseMock() as GetUpcomingTasksForAllPlantsUseCase }
        register { GetUpcomingTasksForPlantUseCaseMock() as GetUpcomingTasksForPlantUseCase }
        register { GetCompletedTasksForPlantUseCaseMock() as GetCompletedTasksForPlantUseCase }
        register { GetCompletedTasksForAllPlantsUseCaseMock() as GetCompletedTasksForAllPlantsUseCase }
        
        // Notifications
        register { HasNotificationAccessUseCaseMock() as HasNotificationAccessUseCase }
        register { ScheduleNextNotificationUseCaseMock() as ScheduleNextNotificationUseCase }
        
    }
}
