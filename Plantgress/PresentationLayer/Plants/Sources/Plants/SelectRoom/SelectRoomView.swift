//
//  SelectRoomView.swift
//  Plants
//
//  Created by Lucia Cahojova on 29.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct SelectRoomView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: SelectRoomViewModel
    
    // MARK: - Init
    
    init(viewModel: SelectRoomViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    viewModel.onIntent(.dismiss)
                } label: {
                    Text(Strings.discardButton)
                        .foregroundStyle(Colors.red)
                        .font(Fonts.bodyMedium)
                }
                
                Spacer()
                
                Button {
                    viewModel.onIntent(.save)
                } label: {
                    Text(Strings.pickButton)
                        .foregroundStyle(Colors.primaryText)
                        .font(Fonts.bodySemibold)
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, Constants.Spacing.small)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Constants.Spacing.mediumLarge) {
                    if viewModel.state.isLoading {
                        ForEach(0...3, id: \.self) { _ in
                            SelectionRow.skeleton
                        }
                    } else if let errorMessage = viewModel.state.errorMessage {
                        BaseErrorContentView(
                            errorMessage: errorMessage,
                            refreshAction: {
                                viewModel.onIntent(.refresh)
                            },
                            fixedTopPadding: 100
                        )
                    } else if viewModel.state.rooms.isEmpty {
                        BaseEmptyContentView(
                            message: Strings.noRoomsMessage,
                            fixedTopPadding: 100
                        )
                    } else {
                        ForEach(viewModel.state.rooms, id: \.id) { room in
                            SelectionRow(
                                title: room.name,
                                isSelected: room.id == viewModel.state.selectedRoom?.id,
                                actionType: .none,
                                imageUrlString: room.imageUrls.first,
                                selectAction: {
                                    viewModel.onIntent(.selectRoom(room))
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, Constants.Spacing.large)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .lifecycle(viewModel)
        .background(Colors.primaryBackground)
    }
}

#Preview {
    Resolver.registerUseCaseMocks()
    
    let vm = SelectRoomViewModel(
        flowController: nil,
        selectedRoom: nil,
        onSave: { _ in }
    )
    
    return SelectRoomView(viewModel: vm)
}
