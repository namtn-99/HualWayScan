//
//  InputRepairView.swift
//  HualWayScan
//
//  Created by NamTrinh on 21/1/25.
//

import SwiftUI

struct InputRepairView: View {
    @State private var parts = ""
    @State private var po = ""
    @State private var description = ""
    @State private var cost = ""
    
    var onUpdate: ([String: Any]) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Update repair")
                .font(.title2)
                .bold()
            Divider()
            enterPartsView
            enterPOView
            enterDescriptionView
            enterCostView
            Spacer()
            updateButton
        }
        .padding(.top)
    }
}

extension InputRepairView {
    private var enterPartsView: some View {
        VStack(spacing: 4) {
            Text("Repair parts")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            TextField("Enter parts", text: $parts)
                .textFieldStyle(CustomTextFieldStyle())
                .autocapitalization(.none)
        }
        .padding(.horizontal)
    }
    
    private var enterPOView: some View {
        VStack(spacing: 4) {
            Text("Repair PO")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            TextField("Enter po", text: $po)
                .textFieldStyle(CustomTextFieldStyle())
                .autocapitalization(.none)
        }
        .padding(.horizontal)
    }
    
    private var enterDescriptionView: some View {
        VStack(spacing: 4) {
            Text("Repair Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            TextField("Enter description", text: $description)
                .textFieldStyle(CustomTextFieldStyle())
                .autocapitalization(.none)
        }
        .padding(.horizontal)
    }
    
    private var enterCostView: some View {
        VStack(spacing: 4) {
            Text("Repair Cost")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            TextField("Enter cost", text: $cost)
                .textFieldStyle(CustomTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.numberPad)
        }
        .padding(.horizontal)
    }
    
    private var updateButton: some View {
        Button {
            let params: [String: Any] = [
                "repair_parts": parts,
                "repair_po": po,
                "repair_description": description,
                "repair_cost": Int(cost) ?? 0
            ]
            onUpdate(params)
        } label: {
            Text("Update")
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .background(isDisable() ? .gray.opacity(0.3) : .blue)
                .cornerRadius(8)
        }
        .disabled(isDisable())
        .padding()
    }
    
    func isDisable() -> Bool {
        return cost.isEmpty
        || description.isEmpty
        || po.isEmpty
        || parts.isEmpty
    }
}

#Preview {
    InputRepairView() { _ in
        
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.all, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5))
            )
    }
}
