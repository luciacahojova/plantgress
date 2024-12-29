//
//  DailyPeriodRow.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import SwiftUI
import UIToolkit

struct DailyPeriodRow: View {
    @Binding private var interval: Int
    
    init(
        interval: Binding<Int>
    ) {
        self._interval = interval
    }

    var body: some View {
        VStack(spacing: 0) {
            CustomListRow(
                title: "Every", // TODO: Strings
                isLast: false,
                content:  {
                    Text("\(interval) days") // TODO: Strings
                }
            )
            
            Picker("", selection: $interval) {
                ForEach(1...365, id: \.self) { number in
                    Text("\(number)")
                        .tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}

#Preview {
    DailyPeriodRow(
        interval: .constant(5)
    )
}
