//
//  PeriodSettingsView.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct PeriodSettingsView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: PeriodSettingsViewModel
    @State private var selectedIntervalTypes: [UUID: IntervalType] = [:]
    
    // MARK: - Init

    init(viewModel: PeriodSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    enum IntervalType {
        case daily
        case weekly
        case monthly
        case yearly
    }

    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Spacing.large) {
                ForEach(viewModel.state.periods, id: \.id) { period in
                    BaseList(title: period.name) {
                        CustomListRow(
                            title: Strings.plantCreationFrequency,
                            isLast: false
                        ) {
                            Picker(
                                period.interval.name,
                                selection: Binding<IntervalType>(
                                    get: { selectedIntervalTypes[period.id] ?? IntervalType.daily },
                                    set: { newValue in
                                        selectedIntervalTypes[period.id] = newValue
                                    }
                                )
                            ) {
                                Text(Strings.plantCreationDaily).tag(IntervalType.daily)
                                Text(Strings.plantCreationWeekly).tag(IntervalType.weekly)
                                Text(Strings.plantCreationMonthly).tag(IntervalType.monthly)
                                Text(Strings.plantCreationYearly).tag(IntervalType.yearly)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .tint(Colors.primaryText)
                        }
                        
                        switch selectedIntervalTypes[period.id] ?? .daily {
                        case .daily:
                            DailyPeriodRow(
                                interval: Binding<Int>(
                                    get: {
                                        if case let .daily(interval) = viewModel.state.periods.first(where: { $0.id == period.id })?.interval {
                                            return interval
                                        }
                                        return 1
                                    },
                                    set: { newValue in
                                        viewModel.onIntent(.updatePeriod(period.id, .daily(interval: newValue)))
                                    }
                                )
                            )
                        case .weekly:
                            WeeklyPeriodRow(
                                taskInterval: Binding<TaskInterval>(
                                    get: {
                                        if case let .weekly(interval, weekday) = viewModel.state.periods.first(where: { $0.id == period.id })?.interval {
                                            return .weekly(interval: interval, weekday: weekday)
                                        }
                                        return .weekly(interval: 1, weekday: 1)
                                    },
                                    set: { newInterval in
                                        viewModel.onIntent(.updatePeriod(period.id, newInterval))
                                    }
                                )
                            )
                        case .monthly:
                            MonthlyPeriodRow(
                                taskInterval: Binding<TaskInterval>(
                                    get: {
                                        if case let .monthly(interval, months) = viewModel.state.periods.first(where: { $0.id == period.id })?.interval {
                                            return .monthly(interval: interval, months: months)
                                        }
                                        return .monthly(interval: 1, months: Array(1...12))
                                    },
                                    set: { newInterval in
                                        viewModel.onIntent(.updatePeriod(period.id, newInterval))
                                    }
                                )
                            )
                        case .yearly:
                            YearlyPeriodRow(
                                date: Binding<Date>(
                                    get: {
                                        if case let .yearly(date) = viewModel.state.periods.first(where: { $0.id == period.id })?.interval {
                                            let components = DateComponents(
                                                year: Calendar.current.component(.year, from: Date()),
                                                month: date.month,
                                                day: date.day
                                            )
                                            return Calendar.current.date(from: components) ?? Date()
                                        }
                                        return Date()
                                    },
                                    set: { newDate in
                                        let components = Calendar.current.dateComponents([.month, .day], from: newDate)
                                        if let month = components.month,
                                           let day = components.day {
                                            viewModel.onIntent(
                                                .updatePeriod(period.id, .yearly(date: TaskInterval.SpecificDate(day: day, month: month)))
                                            )
                                        }
                                    }
                                ),
                                rowLever: .primary,
                                isLast: true
                            )
                        }
                    }
                    .contextMenu {
                        if viewModel.state.periods.count > 1 {
                            MenuLabelButton(
                                text: Strings.deleteButton,
                                role: .destructive,
                                icon: Icons.trash,
                                action: {
                                    viewModel.onIntent(.removePeriod(period.id))
                                }
                            )
                        }
                    }
                }
                
                BaseList(title: Strings.plantCreationAddPeriodButton) {
                    ButtonListRow(
                        title: Strings.plantCreationAddAnotherPeriodButton,
                        isLast: true,
                        trailingIcon: Icons.plus,
                        action: {
                            viewModel.onIntent(.addPeriod)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            for period in viewModel.state.periods {
                switch period.interval {
                case .daily:
                    selectedIntervalTypes[period.id] = .daily
                case .weekly:
                    selectedIntervalTypes[period.id] = .weekly
                case .monthly:
                    selectedIntervalTypes[period.id] = .monthly
                case .yearly:
                    selectedIntervalTypes[period.id] = .yearly
                }
            }
        }
        .animation(.easeInOut, value: viewModel.state.periods)
        .onDisappear {
            viewModel.onIntent(.save)
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    let vm = PeriodSettingsViewModel(
        flowController: nil,
        periods: TaskConfiguration.default(for: .watering).periods,
        onSave: { _ in }
    )
    
    return PeriodSettingsView(
        viewModel: vm
    )
    .background(Colors.primaryBackground)
}
