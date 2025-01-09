//
//  PlantSettings+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain

public extension PlantSettings {
    static var `default`: PlantSettings {
        PlantSettings(
            tasksConfigurations: .default
        )
    }
    
    func replacingTask(
        taskType: TaskType,
        with updatedTask: TaskConfiguration
    ) -> PlantSettings {
        let updatedTasks = tasksConfigurations.map { task in
            task.taskType == taskType ? updatedTask : task
        }
        return PlantSettings(tasksConfigurations: updatedTasks)
    }
}
