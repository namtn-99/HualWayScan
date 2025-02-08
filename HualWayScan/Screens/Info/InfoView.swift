//
//  InfoView.swift
//  HualWayScan
//
//  Created by NamTrinh on 22/1/25.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var viewModel = InfoViewModel()
    
    @Binding var isShow: Bool
    
    let heightForView: CGFloat = 30
    
    @Binding var model: ApplianceModel?
    
    @State var isFirstTime = true
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                Spacer()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        categoryView
                        statusView
                        substatusView
                        structIdView
                        partsView
                        poView
                        descriptionView
                        costView
                        repairRequiredView
                        cleaningView
                        recycleView
                        scrapView
                        
                        Spacer()
                    }
                    
                }
                .padding(.horizontal)
                updateButton
            }
            
            if viewModel.isShowSuccess {
                GeometryReader { _ in
                    SuccessPopupView(message: "Your settings have been saved!", onTap: {
                        isShow.toggle()
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
        .errorAlert(isPresented: $viewModel.isError, errorMessage: viewModel.errorStr ?? "")
        .background(.white)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.selectedCategory = CategoryType(rawValue: model?.category ?? "") ?? .cooking
            viewModel.selectedSubStatus = SubStatusType(rawValue: model?.subStatus ?? "") ?? .condition
            viewModel.selectedStatus = StatusType(rawValue: model?.status ?? "") ?? .accepted
            viewModel.parts = model?.repairParts ?? ""
            viewModel.po = model?.repairPo ?? ""
            viewModel.description = model?.repairDescription ?? ""
            
            viewModel.repairRequired = model?.repairRequired ?? false
            viewModel.cleanRequired = model?.cleaningRequired ?? false
            viewModel.recycle = model?.recycle ?? false
            viewModel.scrap = model?.scrap ?? false
            viewModel.truckId = model?.truckId ?? ""
            
            if let cost = model?.repairCost {
                viewModel.cost = String(describing: cost)
            }
        }
    }
}

extension InfoView {
    private var headerView: some View {
        HStack {
            Button {
                isShow.toggle()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.title3)
            }
            Spacer()
        }
        .padding()
    }
    
    private var categoryView: some View {
        CustomPickerView(title: "Category", options: CategoryType.allCases, selectedOption: $viewModel.selectedCategory)
    }
    
    private var statusView: some View {
        CustomPickerView(title: "Status", options: StatusType.allCases, selectedOption: $viewModel.selectedStatus)
            .onChange(of: viewModel.selectedStatus) { newValue in
                if isFirstTime {
                    isFirstTime.toggle()
                    return
                }
                viewModel.selectedSubStatus = nil
            }
    }
    
    private var substatusView: some View {
        if viewModel.selectedStatus == .rejected {
            CustomPickerView(title: "Sub-status", options: SubStatusType.rejected, selectedOption: $viewModel.selectedSubStatus)
        } else {
            CustomPickerView(title: "Sub-status", options: SubStatusType.accepted, selectedOption: $viewModel.selectedSubStatus)
        }
    }
    
    private var structIdView: some View {
        CustomInputWithTitle(text: $viewModel.truckId, title: "Truck ID", placeholder: "Enter truck ID")
    }
    
    private var partsView: some View {
        CustomInputWithTitle(text: $viewModel.parts, title: "Repair parts", placeholder: "Enter repair parts")
    }
    
    private var poView: some View {
        CustomInputWithTitle(text: $viewModel.po, title: "Repair po", placeholder: "Enter repair po")
    }
    
    private var descriptionView: some View {
        CustomInputWithTitle(text: $viewModel.description, title: "Repair description", placeholder: "Enter repair description")
    }
    
    private var costView: some View {
        CustomInputWithTitle(text: $viewModel.cost, title: "Repair cost", placeholder: "Enter repair cost")
    }
    
    private var repairRequiredView: some View {
        HStack {
            Text("Repair required")
                .bold()
                .foregroundStyle(.black)
            Spacer()
            Toggle("", isOn: $viewModel.repairRequired)
                .foregroundStyle(.white)
        }
        .frame(height: 30)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    private var cleaningView: some View {
        HStack {
            Text("Cleaning required")
                .bold()
                .foregroundStyle(.black)
            Spacer()
            Toggle("", isOn: $viewModel.cleanRequired)
                .foregroundStyle(.white)
        }
        .frame(height: 30)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    private var recycleView: some View {
        HStack {
            Text("Recycle")
                .bold()
                .foregroundStyle(.black)
            Spacer()
            Toggle("", isOn: $viewModel.recycle)
                .foregroundStyle(.white)
        }
        .frame(height: 30)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    private var scrapView: some View {
        HStack {
            Text("Scrap")
                .bold()
                .foregroundStyle(.black)
            Spacer()
            Toggle("", isOn: $viewModel.scrap)
                .foregroundStyle(.white)
        }
        .frame(height: 30)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    func isDisable() -> Bool {
//        return viewModel.parts.isEmpty
//        || viewModel.description.isEmpty
//        || viewModel.po.isEmpty
//        || viewModel.cost.isEmpty
        return false
    }
    
    private var updateButton: some View {
        Button {
            viewModel.patchAppliance(barcode: model?.barcode ?? "")
        } label: {
            Text("Update")
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .background(isDisable() ? .gray.opacity(0.3) : .EF_426_F)
                .cornerRadius(8)
        }
        .disabled(isDisable())
        .padding()
    }
    
}

#Preview {
    InfoView(isShow: .constant(true), model: .constant(nil))
}
