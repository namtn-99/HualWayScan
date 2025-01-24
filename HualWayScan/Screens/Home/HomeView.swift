//
//  HomeView.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShow: Bool
    @StateObject private var viewModel = HomeViewModel()
    
    let barCode: String
    
    var body: some View {
        ZStack {
            VStack {
                switch viewModel.screenType {
                case .category:
                    updateCategoryView
                case .status:
                    updateStatusView
                case .none:
                    EmptyView()
                }
                Spacer()
                updateButton
            }
            
            if viewModel.isShowSuccessPopup {
                GeometryReader { _ in
                    SuccessPopupView(message: "Your settings have been saved!", onTap: {
                        presentationMode.wrappedValue.dismiss()
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 16)
                }
                .background(
                    Color.black.opacity(0.65)
                        .edgesIgnoringSafeArea(.all)
                        
                )
            }
        }
        .navigationTitle("Update")
        .errorAlert(isPresented: $viewModel.isError, errorMessage: viewModel.errorStr ?? "")
        .navigationDestination(isPresented: $viewModel.isShowInfo, destination: {
            InfoView(isShow: $isShow, model: $viewModel.applianceModel)
        })
        .sheet(isPresented: $viewModel.isShowRepairInput, content: {
            InputRepairView() { params in
                viewModel.isShowRepairInput = false
                viewModel.updateRepair(params: params)
            }
        })
//        .defaultAlert(isPresented: $viewModel.isShowCleaning, title: "Require Cleaning?", message: "", primaryTitle: "Yes", secondaryTile: "No", primaryButtonTap: {
//            viewModel.updateRequireCleaning(isRequire: true)
//        }, secondaryButtonTap: {
//            viewModel.updateRequireCleaning(isRequire: false)
//        })
//        .defaultAlert(isPresented: $viewModel.isShowCleaningCompleted, title: "Cleaning completed?", message: "", primaryTitle: "Yes", secondaryTile: "No", primaryButtonTap: {
//            viewModel.updateCleaningCompleted(true)
//        }, secondaryButtonTap: {
//            viewModel.updateCleaningCompleted(false)
//        })
        .alert("Confirm", isPresented: $viewModel.isShowCleaningCompleted) {
            Button("YES", action: {
                viewModel.updateCleaningCompleted(true)
            })
            Button("NO", action: {
                viewModel.updateCleaningCompleted(false)
            })
            Button("BACK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        } message : {
            Text("Cleaning completed?")
        }
        .alert("Confirm", isPresented: $viewModel.isShowRepairCompleted) {
            Button("YES", action: {
                viewModel.confirmRepairCompleted(isCompleted: true)
            })
            Button("NO", action: {
                viewModel.confirmRepairCompleted(isCompleted: false)
            })
            Button("BACK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        } message: {
            Text("Repair completed?")
        }
        .alert("Confirm", isPresented: $viewModel.isShowCleaning) {
            Button("YES", action: {
                viewModel.updateCleaningCompleted(true)
            })
            Button("NO", action: {
                viewModel.updateCleaningCompleted(false)
            })
            Button("BACK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        } message : {
            Text("Require Cleaning?")
        }
        .alert("Confirm", isPresented: $viewModel.isShowTesting) {
            Button("YES", action: {
                viewModel.confirmTestingSuccess(isSuccess: true)
            })
            Button("NO", action: {
                viewModel.confirmTestingSuccess(isSuccess: false)
            })
            Button("BACK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        } message: {
            Text("Testing successful?")
        }
        .alert("Confirm", isPresented: $viewModel.isShowRepairRequired) {
            Button("YES", action: {
                viewModel.confirmRepairRequired(isRequired: true)
            })
            Button("NO", action: {
                viewModel.confirmRepairRequired(isRequired: false)
            })
            Button("BACK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        } message: {
            Text("Repair is required?")
        }
        .onAppear {
            viewModel.barCode = barCode
            viewModel.getAppliance(code: barCode)
        }
    }
}

extension HomeView {
    private var updateStatusView: some View {
        List {
            Section("Select Status") {
                ForEach(StatusType.allCases) { item in
                    createCell(title: item.rawValue, isSelected: item == viewModel.selectedStatus)
                        .onTapGesture {
                            viewModel.selectedSubStatus = nil
                            viewModel.selectedStatus = item
                        }
                }
            }
           
            Section("Select SubStatus") {
                ForEach(viewModel.selectedStatus == .accepted ? SubStatusType.accepted : SubStatusType.rejected) { item in
                    createCell(title: item.rawValue, isSelected: item == viewModel.selectedSubStatus)
                        .onTapGesture {
                            viewModel.selectedSubStatus = item
                        }
                }
            }
        }
        .pickerStyle(.inline)
    }
    
    private var updateCategoryView: some View {
        List {
            Section("Select Category") {
                ForEach(CategoryType.allCases) { item in
                    createCell(title: item.rawValue, isSelected: item == viewModel.selectedCategory)
                        .onTapGesture {
                            viewModel.selectedCategory = item
                        }
                }
            }
        }
        .pickerStyle(.inline)
    }
    
    func createCell(title: String, isSelected: Bool) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(.blue)
            }
        }
        .contentShape(.rect)
    }
    
    private var updateButton: some View {
        Button {
            switch viewModel.screenType {
            case .category:
                viewModel.updateCategoryAppliance(code: barCode)
            case .status:
                viewModel.updateStatus()
            case .none:
                break
            }
        } label: {
            Text("Update")
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .background(isEnable() ? .blue : .gray.opacity(0.3))
                .cornerRadius(8)
        }
        .disabled(!isEnable())
        .padding()
    }
    
    func isEnable() -> Bool {
        switch viewModel.screenType {
        case .category:
            return viewModel.selectedCategory != nil
        case .status:
            return viewModel.selectedStatus != nil && viewModel.selectedSubStatus != nil
        case .none:
            return false
        }
    }
}

#Preview {
    HomeView(isShow: .constant(true), barCode: "")
}
