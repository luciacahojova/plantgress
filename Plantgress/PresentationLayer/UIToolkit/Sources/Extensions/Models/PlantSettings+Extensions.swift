//
//  PlantSettings+Extensions.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 14.12.2024.
//

import SharedDomain

public extension PlantSettings {
    static var mock: PlantSettings {
        PlantSettings(
            tasksConfiguartions: .mock
        )
    }
    
    static var `default`: PlantSettings {
        PlantSettings(
            tasksConfiguartions: .default
        )
    }
    
    func replacingTask(
        taskType: TaskType,
        with updatedTask: TaskConfiguration
    ) -> PlantSettings {
        let updatedTasks = tasksConfiguartions.map { task in
            task.taskType == taskType ? updatedTask : task
        }
        return PlantSettings(tasksConfiguartions: updatedTasks)
    }
}
