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
        .padding()
    }
}

extension InputRepairView {
    private var enterPartsView: some View {
        CustomInputWithTitle(text: $parts, title: "Repair parts", placeholder: "Enter repair parts")
    }
    
    private var enterPOView: some View {
        CustomInputWithTitle(text: $po, title: "Repair po", placeholder: "Enter repair po")
    }
    
    private var enterDescriptionView: some View {
        CustomInputWithTitle(text: $description, title: "Repair Description", placeholder: "Enter repair description")
    }
    
    private var enterCostView: some View {
        CustomInputWithTitle(text: $cost, title: "Repair Cost", placeholder: "Enter repair cost", keyboardType: .numberPad)
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
                .background(isDisable() ? .gray.opacity(0.3) : AppConstant.primaryColor)
                .cornerRadius(8)
        }
        .disabled(isDisable())
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

struct CustomInputViewExample: View {
    @State private var username: String = ""
    
    @State private var selectedOption: String? = nil
       let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    var body: some View {
        VStack(spacing: 20) {
            CustomPickerView(title: "Options", options: options, selectedOption: $selectedOption)
            
            CustomInputWithTitle(
                text: $username, title: "Username",
                placeholder: "Enter your username",
                keyboardType: .emailAddress
            )
            
            Button(action: {
                print("Username: \(username)")
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppConstant.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
