//
//  UseCases+Injection.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import Resolver
import SharedDomain

public extension Resolver {
    static func registerUseCases() {
        // Authentication
        register { IsUserLoggedInUseCaseImpl(userRepository: resolve()) as IsUserLoggedInUseCase }
        register { IsEmailVerifiedUseCaseImpl(authRepository: resolve()) as IsEmailVerifiedUseCase }
        register { RegisterUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as RegisterUserUseCase }
        register { LogInUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as LogInUserUseCase }
        register { SendEmailVerificationUseCaseImpl(authRepository: resolve()) as SendEmailVerificationUseCase }
        register { ValidateEmailUseCaseImpl() as ValidateEmailUseCase }
        register { ValidatePasswordUseCaseImpl() as ValidatePasswordUseCase }
        register { GetCurrentUsersEmailUseCaseImpl(userRepository: resolve()) as GetCurrentUsersEmailUseCase }
        register { GetCurrentUserRemotelyUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as GetCurrentUserRemotelyUseCase }
        register { GetCurrentUserLocallyUseCaseImpl(userRepository: resolve()) as GetCurrentUserLocallyUseCase }
        register { SendPasswordResetUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as SendPasswordResetUseCase }
        register { LogOutUserUseCaseImpl(userRepository: resolve()) as LogOutUserUseCase }
        register { DeleteUserUseCaseImpl(authRepository: resolve(), userRepository: resolve()) as DeleteUserUseCase }
        register { SaveCurrentUserEmailUseCaseImpl(userRepository: resolve()) as SaveCurrentUserEmailUseCase }
        register { DeleteCurrentUserEmailUseCaseImpl(userRepository: resolve()) as DeleteCurrentUserEmailUseCase }
        
        // Images
        register { UploadImageUseCaseImpl(imagesRepository: resolve()) as UploadImageUseCase }
        register { DownloadImageUseCaseImpl(imagesRepository: resolve()) as DownloadImageUseCase }
        register { HasCameraAccessUseCaseImpl() as HasCameraAccessUseCase }
        register { HasPhotoLibraryAccessUseCaseImpl() as HasPhotoLibraryAccessUseCase }
        register { DeleteImageUseCaseImpl(imagesRepository: resolve()) as DeleteImageUseCase }

        // Plants
        register {
            CreatePlantUseCaseImpl(
                plantRepository: resolve(),
                roomRepository: resolve(),
                taskRepository: resolve()
            ) as CreatePlantUseCase
        }
        register { UpdatePlantUseCaseImpl(plantRepository: resolve(), taskRepository: resolve()) as UpdatePlantUseCase }
        register { GetPlantUseCaseImpl(plantRepository: resolve()) as GetPlantUseCase }
        register { DeletePlantUseCaseImpl(plantRepository: resolve(), taskRepository: resolve()) as DeletePlantUseCase }
        register { GetAllPlantsUseCaseImpl(plantRepository: resolve()) as GetAllPlantsUseCase }
        register { UpdatePlantImagesUseCaseImpl(plantRepository: resolve()) as UpdatePlantImagesUseCase }

        // Rooms
        register { CreateRoomUseCaseImpl(roomRepository: resolve()) as CreateRoomUseCase }
        register { AddPlantsToRoomUseCaseImpl(roomRepository: resolve()) as AddPlantsToRoomUseCase }
        register { GetRoomUseCaseImpl(roomRepository: resolve()) as GetRoomUseCase }
        register { GetPlantsForRoomUseCaseImpl(roomRepository: resolve()) as GetPlantsForRoomUseCase }
        register { GetAllRoomsUseCaseImpl(roomRepository: resolve()) as GetAllRoomsUseCase }
        register { RemovePlantFromRoomUseCaseImpl(roomRepository: resolve()) as RemovePlantFromRoomUseCase }
        register { MovePlantToRoomUseCaseImpl(roomRepository: resolve()) as MovePlantToRoomUseCase }
        
        // Tasks
        register { SynchronizeNotificationsForAllPlantsUseCaseImpl(taskRepository: resolve(), plantRepository: resolve()) as SynchronizeNotificationsForAllPlantsUseCase }
        register { CompleteTaskUseCaseImpl(taskRepository: resolve()) as CompleteTaskUseCase }
        register { CompleteTaskForRoomUseCaseImpl(taskRepository: resolve(), plantRepository: resolve()) as CompleteTaskForRoomUseCase }
        register { DeleteTaskUseCaseImpl(taskRepository: resolve(), plantRepository: resolve()) as DeleteTaskUseCase }
        register { DeleteTaskForRoomUseCaseImpl(taskRepository: resolve(), plantRepository: resolve()) as DeleteTaskForRoomUseCase }
        register { DeleteTaskForPlantUseCaseImpl(taskRepository: resolve()) as DeleteTaskForPlantUseCase }
        register { GetUpcomingTasksForAllPlantsUseCaseImpl(taskRepository: resolve()) as GetUpcomingTasksForAllPlantsUseCase }
        register { GetUpcomingTasksForPlantUseCaseImpl(taskRepository: resolve()) as GetUpcomingTasksForPlantUseCase }
        register { GetCompletedTasksForPlantUseCaseImpl(taskRepository: resolve()) as GetCompletedTasksForPlantUseCase }
        register { GetCompletedTasksForAllPlantsUseCaseImpl(taskRepository: resolve()) as GetCompletedTasksForAllPlantsUseCase }
        
        // Notifications
        register { HasNotificationAccessUseCaseImpl() as HasNotificationAccessUseCase }
        register { ScheduleNextNotificationUseCaseImpl(taskRepository: resolve(), plantRepository: resolve()) as ScheduleNextNotificationUseCase }
    
    }
}
