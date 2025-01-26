//
//  CustomPickerView.swift
//  HualWayScan
//
//  Created by NamTrinh on 26/1/25.
//

import SwiftUI

struct CustomPickerView<T: Hashable>: View {
    let title: String           // Title of the picker
    let options: [T]            // Options for selection
    @Binding var selectedOption: T? // Binding for the selected option

    @State private var showPicker = false // Toggles the picker visibility

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Button(action: {
                withAnimation {
                    showPicker.toggle() // Show/hide picker
                }
            }) {
                HStack {
                    Text(selectedOption.map { "\($0)" } ?? "Select \(title.lowercased())")
                        .foregroundColor(selectedOption == nil ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showPicker ? 180 : 0))
                        .animation(.easeInOut, value: showPicker)
                }
                .frame(height: 30)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }

            if showPicker {
                ScrollView {
                    VStack {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selectedOption = option
                                withAnimation {
                                    showPicker = false // Close picker
                                }
                            }) {
                                Text("\(option)")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        selectedOption == option
                                        ? Color.blue.opacity(0.2)
                                        : Color.clear
                                    )
                                    .contentShape(.rect)
                                    .foregroundColor(selectedOption == option ? .blue : .primary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
//                    .padding(.vertical, 5)
                }
                .frame(maxHeight: 200)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }
        }
    }
}
