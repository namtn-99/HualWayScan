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
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                Spacer()
                ScrollView(showsIndicators: false) {
                    categoryView
                    statusView
                    substatusView
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
        HStack {
            Text("Category")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Picker(selection: $viewModel.selectedCategory, label: Text("Select Category")) {
                ForEach(CategoryType.allCases) { item in
                    Text(item.rawValue)
                }
            }
            .tint(.white)
            .pickerStyle(.menu)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var statusView: some View {
        HStack {
            Text("Status")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Picker(selection: $viewModel.selectedStatus, label: Text("Select Status")) {
                ForEach(StatusType.allCases) { item in
                    Text(item.rawValue)
                }
            }
            .tint(.white)
            .pickerStyle(.menu)
            .onChange(of: viewModel.selectedStatus) { newValue in
                if newValue == .rejected {
                    viewModel.selectedSubStatus = .expensive
                } else {
                    viewModel.selectedSubStatus = .testing
                }
              
            }
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var substatusView: some View {
        HStack {
            Text("Sub Status")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Picker(selection: $viewModel.selectedSubStatus, label: Text("Select Sub Status")) {
                ForEach(viewModel.selectedStatus == .accepted ? SubStatusType.accepted : SubStatusType.rejected) { item in
                    Text(item.rawValue)
                }
            }
            .tint(.white)
            .pickerStyle(.menu)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var partsView: some View {
        HStack {
            Text("Repair parts")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            TextField("Enter repair parts", text: $viewModel.parts)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var poView: some View {
        HStack {
            Text("Repair po")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            TextField("Enter repair po", text: $viewModel.po)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var descriptionView: some View {
        HStack {
            Text("Repair description")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            TextField("Enter repair description", text: $viewModel.description)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var costView: some View {
        HStack {
            Text("Repair cost")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            TextField("Enter repair cost", text: $viewModel.cost)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var repairRequiredView: some View {
        HStack {
            Text("Repair required")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: $viewModel.repairRequired)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var cleaningView: some View {
        HStack {
            Text("Cleaning required")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: $viewModel.cleanRequired)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var recycleView: some View {
        HStack {
            Text("Recycle")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: $viewModel.recycle)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
        .cornerRadius(8)
    }
    
    private var scrapView: some View {
        HStack {
            Text("Scrap")
                .bold()
                .foregroundStyle(.white)
            Spacer()
            Toggle("", isOn: $viewModel.scrap)
                .foregroundStyle(.white)
        }
        .frame(height: heightForView)
        .padding()
        .background(Color._00_A_9_E_0)
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
