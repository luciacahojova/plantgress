//
//  SectionPicker.swift
//  UIToolkit
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import SwiftUI

public struct SectionPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    
    @Namespace private var pickerTransition
    
    @Binding private var selectedOption: SelectionValue
    private let options: [SelectionValue]
    private var content: (SelectionValue) -> Content
    
    public init(
        selectedOption: Binding<SelectionValue>,
        options: [SelectionValue],
        @ViewBuilder content: @escaping (SelectionValue) -> Content
    ) {
        self._selectedOption = selectedOption
        self.options = options
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            Colors.secondaryBackground
            
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    let isSelected = selectedOption == option
                    
                    ZStack {
                        Colors.green
                            .cornerRadius(Constants.CornerRadius.large)
                            .opacity(isSelected ? 1 : 0)
                            .animationEffect(
                                isSelected: isSelected,
                                id: "picker",
                                in: pickerTransition
                            )
                        
                        content(option)
                            .id(option)
                            .pickerTextStyle(isSelected: isSelected)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedOption = option
                        }
                    }
                }
            }
        }
        .cornerRadius(Constants.CornerRadius.large)
        .frame(height: Constants.Frame.primarySectionPickerHeight)
    }
}

#Preview {
    @State var selectedValue: String = "Plants" // TODO: Section
    
    return SectionPicker(
        selectedOption: $selectedValue,
        options: ["Plants", "Rooms", "Tasks"]
    ) { selectionValue in
        Text(String(selectionValue))
    }
    .padding()
    .background(Colors.primaryBackground)
    .preferredColorScheme(.light)
}
