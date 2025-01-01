//
//  TasksCalendarView.swift
//  Plants
//
//  Created by Lucia Cahojova on 01.01.2025.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct TasksCalendarView: View {
    
    private let upcomingTasks: [PlantTask]
    private let calendar = Calendar.current
    
    @State private var currentDate = Date()
    
    init(upcomingTasks: [PlantTask]) {
        self.upcomingTasks = upcomingTasks
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: previousMonth) {
                    Icons.chevronLeft
                }
                
                Spacer()
                
                Text(currentDate.toString(formatter: Formatter.Date.MMMMyyyy))
                    .font(.headline)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Icons.chevronRight
                }
            }
            .foregroundStyle(Colors.primaryText)
            
            HStack {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .textCase(.uppercase)
                        .font(Fonts.calloutSemibold)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Colors.secondaryText)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth(), id: \.self) { date in
                    VStack {
                        if isInCurrentMonth(date) {
                            taskCircles(for: date)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        } else {
                            Text("")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                }
            }
        }
        .padding()
        .background(Colors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.large))
    }
    
    // MARK: - Helper Functions
    
    private func daysInMonth() -> [Date] {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        let firstDayOfWeek = calendar.date(byAdding: .day, value: -calendar.component(.weekday, from: startOfMonth) + 1, to: startOfMonth)!
        
        let totalDays = range.count + calendar.component(.weekday, from: startOfMonth) - 1
        let totalWeeks = Int(ceil(Double(totalDays) / 7.0))
        
        return (0..<(totalWeeks * 7)).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstDayOfWeek)
        }
    }
    
    private func isInCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    private func taskCircles(for date: Date) -> some View {
        let tasksForDay = upcomingTasks.filter { calendar.isDate($0.dueDate, inSameDayAs: date) }
        let maxCircles = min(tasksForDay.count, 7)
        
        return ZStack {
            ForEach(Array(tasksForDay.prefix(maxCircles).enumerated()), id: \.offset) { index, task in
                createCircle(for: TaskType.color(for: task.taskType), index: index, maxCircles: maxCircles)
            }
            
            Text("\(calendar.component(.day, from: date))")
                .font(calendar.isDate(date, inSameDayAs: currentDate) ? Fonts.bodyBold : Fonts.bodyRegular)
                .foregroundColor(Colors.primaryText)
        }
    }

    private func createCircle(for color: Color, index: Int, maxCircles: Int) -> some View {
        Circle()
            .fill(color)
            .frame(
                width: circleSize(for: index, maxCircles: maxCircles),
                height: circleSize(for: index, maxCircles: maxCircles)
            )
    }

    private func circleSize(for index: Int, maxCircles: Int) -> CGFloat {
        let maxSize: CGFloat = 40
        let stepFactor: CGFloat = 5

        return maxSize - CGFloat(index) * stepFactor
    }

    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }
}

#Preview {
    ScrollView {
        TasksCalendarView(
            upcomingTasks: [
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .watering,
                    dueDate: Date(),
                    completionDate: nil,
                    isCompleted: false
                ),
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .propagation,
                    dueDate: Date(),
                    completionDate: nil,
                    isCompleted: false
                ),
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .pestInspection,
                    dueDate: Date(),
                    completionDate: nil,
                    isCompleted: false
                ),
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .cleaning,
                    dueDate: Date(),
                    completionDate: nil,
                    isCompleted: false
                ),
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .progressTracking,
                    dueDate: Date(),
                    completionDate: nil,
                    isCompleted: false
                ),
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .fertilizing,
                    dueDate: Date(),
                    completionDate: nil,
                    isCompleted: false
                ),
                PlantTask(
                    id: UUID(),
                    plantId: UUID(),
                    plantName: "",
                    imageUrl: "",
                    taskType: .pestInspection,
                    dueDate: Calendar.current.date(byAdding: .day, value: +1, to: Date())!,
                    completionDate: nil,
                    isCompleted: false
                ),
            ]
        )
    }
    .background(Colors.primaryBackground)
}
