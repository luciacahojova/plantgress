//
//  AddRoomView.swift
//  Plants
//
//  Created by Lucia Cahojova on 30.12.2024.
//

import Resolver
import SwiftUI
import UIToolkit

struct AddRoomView: View {
    
    // MARK: - Stored properties
    
    @ObservedObject private var viewModel: AddRoomViewModel
    
    // MARK: - Init
    
    init(viewModel: AddRoomViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let errorMessage = viewModel.state.errorMessage {
                BaseErrorContentView(
                    errorMessage: errorMessage,
                    refreshAction: {
                        viewModel.onIntent(.refresh)
                    }
                )
            } else {
                VStack(spacing: Constants.Spacing.mediumLarge) {
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        Text(Strings.roomNameTitle)
                            .textCase(.uppercase)
                            .padding(.leading, Constants.Spacing.medium)
                            .font(Fonts.calloutSemibold)
                            .foregroundStyle(Colors.secondaryText)
                        
                        OutlinedTextField(
                            text: Binding<String>(
                                get: { viewModel.state.name },
                                set: { newName in viewModel.onIntent(.nameChanged(newName))}
                            ),
                            placeholder: Strings.roomNamePlaceholder,
                            backgroundColor: Colors.secondaryBackground,
                            cornerRadius: Constants.List.cornerRadius,
                            deleteTextAction: {
                                viewModel.onIntent(.nameChanged(""))
                            }
                        )
                    }
                    
                    BaseList(title: Strings.plantsTitle) {
                        Button {
                            viewModel.onIntent(.addPlant)
                        } label: {
                            Icons.plus
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Constants.IconSize.small)
                                .foregroundStyle(Colors.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: Constants.Frame.primaryButtonHeight)
                        }
                    }
                    
                    VStack(spacing: Constants.Spacing.medium) {
                        ForEach(viewModel.state.plants, id: \.id) { plant in
                            SelectionRow(
                                title: plant.name,
                                isSelected: false,
                                actionType: .trash,
                                imageUrlString: plant.images.first?.urlString,
                                selectAction: {},
                                deleteAction: {
                                    viewModel.onIntent(.deletePlant(plantId: plant.id))
                                }
                            )
                        }
                    }
                    
                    if viewModel.state.isEditing {
                        Button(Strings.deleteRoom) {
                            viewModel.onIntent(.deleteRoom)
                        }
                        .buttonStyle(
                            PrimaryButtonStyle(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red
                            )
                        )
                        .padding(.vertical)
                    }
                }
                .padding([.top, .horizontal])
                .padding(.bottom, Constants.Spacing.xxxLarge)
            }
        }
        .skeleton(viewModel.state.isLoading)
        .animation(.easeInOut, value: viewModel.state.plants)
        .edgesIgnoringSafeArea(.bottom)
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.alertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .snackbar(
            Binding<SnackbarData?>(
                get: { viewModel.state.snackbarData },
                set: { snackbarData in viewModel.onIntent(.snackbarDataChanged(snackbarData)) }
            )
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(viewModel.state.isEditing ? Strings.updateRoom : Strings.createRoomButton) { 
                    viewModel.onIntent(.createRoom)
                }
                .disabled(!viewModel.state.isCreateButtonEnabled)
                .opacity(viewModel.state.isCreateButtonEnabled ? 1 : 0.3)
            }
        }
        .foregroundStyle(Colors.primaryText)
        .lifecycle(viewModel)
    }
}

#Preview {
    Resolver.registerUseCaseMocks()
    
    let vm = AddRoomViewModel(
        flowController: nil,
        editingId: nil,
        onShouldRefresh: {},
        onDelete: {}
    )
    
    return AddRoomView(
        viewModel: vm
    )
}
